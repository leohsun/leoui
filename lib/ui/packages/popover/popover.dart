library leo_ui.popover;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';

enum PopoverPlacement { top, bottom, left, right }

enum PopoverTriggerType { press, lonPress, property }

const double Gap = 4;
const double Translate = 10;
const double ArrowMaxLength = 20;
const double ArrowMinLength = 8;

class PopoverPosition {
  final bool canLeft;
  final bool canTop;
  final bool canRight;
  final bool canBottom;

  PopoverPlacement? get firstValidPlacement {
    if (canLeft) return PopoverPlacement.left;
    if (canTop) return PopoverPlacement.top;
    if (canRight) return PopoverPlacement.right;
    if (canBottom) return PopoverPlacement.bottom;
    return null;
  }

  String toString() {
    return 'canLeft: $canLeft, \n canTop: $canTop, \n canRight: $canRight,\n canBottom: $canBottom;';
  }

  PopoverPosition(
      {required this.canLeft,
      required this.canTop,
      required this.canRight,
      required this.canBottom});
}

class PopoverAction {
  final String text;
  final IconData? icon;
  final Color? color;
  final bool disabled;
  final VoidCallback? onPress;

  PopoverAction(
      {required this.text,
      this.icon,
      this.color,
      this.disabled = false,
      this.onPress});
}

class ArrowPainter extends CustomPainter {
  final PopoverPlacement placement;
  final LeouiThemeData theme;
  final Color? color;

  ArrowPainter({required this.placement, required this.theme, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Color _color = color ?? theme.dialogBackgroundColor;
    Paint pathPaint = new Paint();
    pathPaint.strokeWidth = 1;
    pathPaint.color = _color;
    pathPaint.style = PaintingStyle.fill;

    Path path = new Path();
    double delta = 1; //to clear the gap between popoverWidget and arrow
    switch (placement) {
      case PopoverPlacement.top:
        path.moveTo(-delta, -delta);
        path.lineTo(size.width + delta, -delta);
        path.lineTo(size.width / 2, size.height);
        break;
      case PopoverPlacement.bottom:
        path.moveTo(-delta, size.height + delta);
        path.lineTo(size.width / 2, -delta);
        path.lineTo(size.width, size.height);
        break;
      case PopoverPlacement.left:
        path.moveTo(-delta, -delta);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(-delta, size.height + delta);
        break;
      case PopoverPlacement.right:
        path.moveTo(size.width + delta, -delta);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width + delta, size.height + delta);
        break;
    }
    // canvas.drawShadow(path, _color, 1, _color.alpha == 255);
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PopoverWidget extends StatelessWidget {
  final String? content;
  final List<PopoverAction>? actions;
  final WidgetBuilder? customPopoverWidgetBuilder;
  final LeouiThemeData theme;
  final bool? showArrow;
  final PopoverPlacement? placement;
  const PopoverWidget(
      {Key? key,
      this.content,
      required this.theme,
      this.showArrow = true,
      this.actions,
      this.customPopoverWidgetBuilder,
      this.placement = PopoverPlacement.left})
      : super(key: key);

  Widget buildAction(PopoverAction action, BuildContext ctx,
      [bool border = false]) {
    VoidCallback? _onPress;

    if (!action.disabled && action.onPress != null) {
      _onPress = () {
        PopoverScope.of(ctx)!.close();
        action.onPress!();
      };
    }

    return buildButtonWidget(
      onTap: _onPress,
      child: Opacity(
        opacity: action.disabled ? 0.4 : 1,
        child: Container(
          constraints: BoxConstraints(
              minHeight: theme.size!().itemExtent,
              maxWidth: SizeTool.deviceWidth,
              minWidth: theme.size!().buttonSmallMinWidth),
          decoration: BoxDecoration(
              border: border
                  ? Border(
                      bottom: BorderSide(
                          width: 1, color: theme.nonOpaqueSeparatorColor))
                  : null),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: sz(theme.size!().title / 2)),
            child: DefaultTextIconStyle(
              color: action.color ?? theme.labelPrimaryColor,
              size: theme.size!().title,
              child: Row(
                children: [
                  ...(action.icon != null
                      ? [
                          Padding(
                            padding: EdgeInsets.only(
                                right: sz(theme.size!().title / 2)),
                            child: Icon(action.icon),
                          ),
                          Text(
                            action.text,
                          )
                        ]
                      : [Text(action.text)])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionPopoverWidget(BuildContext ctx) {
    List<Widget> _children = [];
    int length = actions!.length;
    forEachWithIndex(actions!, (action, index) {
      bool border = index != length - 1;
      _children.add(buildAction(action, ctx, border));
    });

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(sz(theme.size!().cardBorderRadius / 2)),
      child: IntrinsicWidth(
        child: Column(
          children: _children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late Widget _child;
    if (content != null) {
      _child = Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sz(theme.size!().title / 2)),
          child: DefaultTextIconStyle(
              color: theme.labelPrimaryColor, child: Text(content!)),
        ),
      );
    } else if (customPopoverWidgetBuilder != null) {
      _child = Material(
        child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: ArrowMaxLength, minWidth: ArrowMaxLength),
            child: customPopoverWidgetBuilder!(context)),
      );
    } else {
      // action here
      _child = buildActionPopoverWidget(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        boxShadow: theme.boxShadow,
        borderRadius:
            BorderRadius.circular(sz(theme.size!().cardBorderRadius / 2)),
      ),
      constraints: BoxConstraints(minHeight: theme.size!().itemExtent),
      child: _child,
    );
  }
}

class PopoverScope extends InheritedWidget {
  final Widget child;
  final OverlayEntry popoverEntry;
  final PopoverTriggerType triggerType;
  final bool? show;
  void close([data]) async {
    if (triggerType != PopoverTriggerType.property) {
      popoverEntry.remove();
    }
  }

  PopoverScope(
      {required this.child,
      required this.popoverEntry,
      this.show,
      required this.triggerType})
      : super(child: child);

  static PopoverScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PopoverScope>();
  }

  @override
  bool updateShouldNotify(covariant PopoverScope oldWidget) =>
      show != oldWidget.show;
}

class Popover extends StatefulWidget {
  final Widget child;
  final String? content;
  final LeouiBrightness? brightness;
  final List<PopoverAction>? actions;
  final PopoverPlacement? placement;
  final bool showArrow;
  final PopoverTriggerType triggerType;
  final bool? show;
  final WidgetBuilder? customPopoverWidgetBuilder;
  final Color? arrowColor;
  final double? gap;
  final bool? inSafeArea;
  final bool? hideWarningToast;
  final bool? effective;

  const Popover(
      {Key? key,
      required Widget child,
      this.brightness,
      this.placement = PopoverPlacement.left,
      this.showArrow = true,
      PopoverTriggerType? triggerType,
      this.show,
      required this.content,
      this.arrowColor,
      this.gap = Gap,
      this.inSafeArea = true,
      this.hideWarningToast = false,
      this.effective = false})
      : assert(
            (triggerType != PopoverTriggerType.property && show == null) ||
                (show != null &&
                    (triggerType == PopoverTriggerType.property ||
                        triggerType == null)),
            'When triggerType equal to PopoverTriggerType.property then show must be provided'),
        this.triggerType = triggerType ??
            (show != null
                ? PopoverTriggerType.property
                : PopoverTriggerType.press),
        this.child = child,
        this.actions = null,
        this.customPopoverWidgetBuilder = null,
        super(key: key);

  const Popover.menu(
      {Key? key,
      required this.child,
      this.brightness,
      required this.actions,
      this.showArrow = true,
      this.placement = PopoverPlacement.right,
      PopoverTriggerType? triggerType,
      this.show,
      this.arrowColor,
      this.gap = Gap,
      this.inSafeArea = true,
      this.hideWarningToast = false,
      this.effective = true})
      : assert(
            (triggerType != PopoverTriggerType.property && show == null) ||
                (show != null &&
                    (triggerType == PopoverTriggerType.property ||
                        triggerType == null)),
            'When triggerType equal to PopoverTriggerType.property then show must be provided'),
        this.triggerType = triggerType ??
            (show != null
                ? PopoverTriggerType.property
                : PopoverTriggerType.press),
        this.content = null,
        this.customPopoverWidgetBuilder = null,
        super(key: key);
  const Popover.customize(
      {Key? key,
      required this.child,
      this.brightness,
      this.showArrow = true,
      this.placement = PopoverPlacement.right,
      PopoverTriggerType? triggerType,
      this.show,
      required this.customPopoverWidgetBuilder,
      this.arrowColor,
      this.gap = Gap,
      this.inSafeArea = true,
      this.hideWarningToast = false,
      this.effective = false})
      : assert(
            (triggerType != PopoverTriggerType.property && show == null) ||
                (show != null &&
                    (triggerType == PopoverTriggerType.property ||
                        triggerType == null)),
            'When triggerType equal to PopoverTriggerType.property then show must be provided'),
        this.triggerType = triggerType ??
            (show != null
                ? PopoverTriggerType.property
                : PopoverTriggerType.press),
        this.actions = null,
        this.content = null,
        super(key: key);

  @override
  _PopoverState createState() => _PopoverState();
}

class _PopoverState extends State<Popover> {
  Size size = SizeTool.deviceSize;
  GlobalKey triggerWidget = GlobalKey(debugLabel: 'triggerWidget');
  GlobalKey popoverWidgetKey = GlobalKey(debugLabel: 'Key');
  OverlayEntry? _overlayEntry;
  PopoverPlacement? computedPlacement;

  PopoverPosition calcPosition() {
    RenderBox? triggerWidgetRenderbox =
        (triggerWidget.currentContext!.findRenderObject() as RenderBox);
    Offset triggerWidgetOffset =
        triggerWidgetRenderbox.localToGlobal(Offset.zero);
    Size triggerWidgetSize = triggerWidgetRenderbox.size;

    RenderBox? popoverWidgetRenderbox =
        (popoverWidgetKey.currentContext!.findRenderObject() as RenderBox);
    Size popoverWidgetSize = popoverWidgetRenderbox.size;

    final double devicePaddingTop =
        widget.inSafeArea == true ? SizeTool.devicePadding.top : 0;
    final double devicePaddingBottom =
        widget.inSafeArea == true ? SizeTool.devicePadding.bottom : 0;

    final double leftMaxGap = triggerWidgetOffset.dx - widget.gap!;
    final double topMaxGap =
        triggerWidgetOffset.dy - widget.gap! - devicePaddingTop;
    final double rightMaxGap = SizeTool.deviceWidth -
        triggerWidgetOffset.dx -
        triggerWidgetSize.width -
        widget.gap!;
    final double bottomMaxGap = SizeTool.deviceHeight -
        triggerWidgetOffset.dy -
        triggerWidgetSize.height -
        widget.gap! -
        devicePaddingBottom;

    return PopoverPosition(
        canLeft: popoverWidgetSize.width <= leftMaxGap,
        canTop: popoverWidgetSize.height <= topMaxGap,
        canRight: popoverWidgetSize.width <= rightMaxGap,
        canBottom: popoverWidgetSize.height <= bottomMaxGap);
  }

  calcRightPlacement() {
    PopoverPosition popoverPosition = calcPosition();
    bool canLeft = popoverPosition.canLeft;
    bool canTop = popoverPosition.canTop;
    bool canRight = popoverPosition.canRight;
    bool canBottom = popoverPosition.canBottom;
    if (!canLeft && !canTop && !canRight && !canBottom)
      // has not enough size to place popover widget
      return computedPlacement = null;

    switch (widget.placement!) {
      case PopoverPlacement.top:
        computedPlacement = canTop
            ? PopoverPlacement.top
            : canBottom
                ? PopoverPlacement.bottom
                : popoverPosition.firstValidPlacement;
        break;
      case PopoverPlacement.bottom:
        computedPlacement = canBottom
            ? PopoverPlacement.bottom
            : canTop
                ? PopoverPlacement.top
                : popoverPosition.firstValidPlacement;
        break;
      case PopoverPlacement.left:
        computedPlacement = canLeft
            ? PopoverPlacement.left
            : popoverPosition.firstValidPlacement;
        break;
      case PopoverPlacement.right:
        computedPlacement = canRight
            ? PopoverPlacement.right
            : popoverPosition.firstValidPlacement;
        break;
    }
  }

  OverlayEntry? buildOverlay() {
    double? top;
    double? bottom;
    double? left;
    double? right;

    LeouiThemeData theme = widget.brightness != null
        ? LeouiTheme.of(context).copyWith(brightness: widget.brightness)
        : LeouiTheme.of(context);
    RenderBox? triggerWidgetRenderbox =
        (triggerWidget.currentContext!.findRenderObject() as RenderBox);

    Offset triggerWidgetOffset =
        triggerWidgetRenderbox.localToGlobal(Offset.zero);
    Size triggerWidgetSize = triggerWidgetRenderbox.size;
    RenderBox? popoverWidgetRenderbox =
        (popoverWidgetKey.currentContext!.findRenderObject() as RenderBox);
    Size popoverWidgetSize = popoverWidgetRenderbox.size;

    calcRightPlacement();

    if (computedPlacement == null) {
      if (widget.hideWarningToast == false) {
        showToast('Not enough size to show popover', type: ToastType.warning);
      }
      return null;
    }

    void calcVertialPosition() {
      double calcLeft = triggerWidgetOffset.dx -
          (popoverWidgetSize.width - triggerWidgetSize.width) / 2;
      double exceptLeft = calcLeft > -1 ? calcLeft : triggerWidgetOffset.dx;

      bool rightOverflowWhenSetLeft =
          exceptLeft + popoverWidgetSize.width > SizeTool.deviceWidth;

      double exceptRight = SizeTool.deviceWidth -
          triggerWidgetOffset.dx -
          triggerWidgetSize.width;

      bool leftOverflowWhenSetRight =
          exceptRight + popoverWidgetSize.width > SizeTool.deviceWidth;

      if (!rightOverflowWhenSetLeft) {
        left = exceptLeft;
        right = null;
      } else if (!leftOverflowWhenSetRight) {
        left = null;
        right = exceptRight;
      } else {
        if (popoverWidgetSize.width > SizeTool.deviceWidth) {
          tracePrint('***The child\'s width is bigger than device width***');
        }
        left = (SizeTool.deviceWidth - popoverWidgetSize.width) / 2;
        right = null;
      }
    }

    switch (computedPlacement!) {
      case PopoverPlacement.top:
        calcVertialPosition();

        top = triggerWidgetOffset.dy - popoverWidgetSize.height - widget.gap!;

        if (widget.showArrow) {
          top -= ArrowMinLength;
        }

        break;
      case PopoverPlacement.bottom:
        calcVertialPosition();
        top = triggerWidgetOffset.dy + triggerWidgetSize.height + widget.gap!;
        break;
      case PopoverPlacement.left:
        top = triggerWidgetOffset.dy;
        left = triggerWidgetOffset.dx - popoverWidgetSize.width - widget.gap!;
        if (widget.showArrow) {
          left = left! - ArrowMinLength;
        }

        break;
      case PopoverPlacement.right:
        top = triggerWidgetOffset.dy;
        left = triggerWidgetOffset.dx + triggerWidgetSize.width + widget.gap!;
        break;
    }
    late OverlayEntry popoverEntry;

    bool popoverWidgetWidthIsBigger =
        popoverWidgetSize.width > triggerWidgetSize.width;

    Offset arrowOffest = Offset.zero;

    void clacArrowPosition() {
      double dx = 0;

      if (popoverWidgetWidthIsBigger) {
        if (right != null) {
          dx = triggerWidgetSize.width / 2;
        }
        if (left != null) {
          dx = triggerWidgetSize.width / 2 - popoverWidgetSize.width / 2;
        }
      }
      // if (right != null) {
      //   dx -= triggerWidgetSize.width / 2;
      // }
      // if (left != null) {
      //   dx = -dx + triggerWidgetSize.width / 2;
      // }
      arrowOffest = Offset(dx, 0);
    }

    popoverEntry = OverlayEntry(builder: (BuildContext ctx) {
      List<Widget> _children = [
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeInOutCubic,
            builder: (context, double size, _) {
              late Matrix4 _transform;
              switch (computedPlacement!) {
                case PopoverPlacement.top:
                  _transform = Matrix4.identity()
                    ..translate(0.0, Translate - size * Translate, 0.0);
                  break;
                case PopoverPlacement.bottom:
                  _transform = Matrix4.identity()
                    ..translate(0.0, size * Translate - Translate, 0.0);
                  break;
                case PopoverPlacement.left:
                  _transform = Matrix4.identity()
                    ..translate(Translate - size * Translate, 0.0, 0);
                  break;
                case PopoverPlacement.right:
                  _transform = Matrix4.identity()
                    ..translate(size * Translate - Translate, 0.0, 0);
                  break;
              }

              late Widget _child;

              switch (computedPlacement!) {
                case PopoverPlacement.top:
                  if (widget.showArrow) {
                    clacArrowPosition();
                  }
                  _child = widget.showArrow
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PopoverWidget(
                              showArrow: widget.showArrow,
                              placement: computedPlacement!,
                              theme: theme,
                              content: widget.content,
                              actions: widget.actions,
                              customPopoverWidgetBuilder:
                                  widget.customPopoverWidgetBuilder,
                            ),
                            Transform.translate(
                              offset: arrowOffest,
                              child: SizedBox(
                                width: ArrowMaxLength,
                                height: ArrowMinLength,
                                child: CustomPaint(
                                  painter: ArrowPainter(
                                      color: widget.arrowColor,
                                      placement: PopoverPlacement.top,
                                      theme: theme),
                                ),
                              ),
                            )
                          ],
                        )
                      : PopoverWidget(
                          showArrow: widget.showArrow,
                          placement: computedPlacement,
                          theme: theme,
                          content: widget.content,
                          actions: widget.actions,
                          customPopoverWidgetBuilder:
                              widget.customPopoverWidgetBuilder,
                        );
                  break;
                case PopoverPlacement.bottom:
                  if (widget.showArrow) {
                    clacArrowPosition();
                  }
                  _child = widget.showArrow
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: arrowOffest,
                              child: SizedBox(
                                width: ArrowMaxLength,
                                height: ArrowMinLength,
                                child: CustomPaint(
                                  painter: ArrowPainter(
                                      placement: PopoverPlacement.bottom,
                                      color: widget.arrowColor,
                                      theme: theme),
                                ),
                              ),
                            ),
                            PopoverWidget(
                              showArrow: widget.showArrow,
                              placement: computedPlacement!,
                              theme: theme,
                              content: widget.content,
                              actions: widget.actions,
                              customPopoverWidgetBuilder:
                                  widget.customPopoverWidgetBuilder,
                            ),
                          ],
                        )
                      : PopoverWidget(
                          showArrow: widget.showArrow,
                          placement: computedPlacement!,
                          theme: theme,
                          content: widget.content,
                          actions: widget.actions,
                          customPopoverWidgetBuilder:
                              widget.customPopoverWidgetBuilder,
                        );
                  break;
                case PopoverPlacement.left:
                  _child = widget.showArrow
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopoverWidget(
                              showArrow: widget.showArrow,
                              placement: computedPlacement!,
                              theme: theme,
                              content: widget.content,
                              actions: widget.actions,
                              customPopoverWidgetBuilder:
                                  widget.customPopoverWidgetBuilder,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: (theme.size!().itemExtent -
                                          ArrowMaxLength) /
                                      2),
                              child: SizedBox(
                                width: ArrowMinLength,
                                height: ArrowMaxLength,
                                child: CustomPaint(
                                  painter: ArrowPainter(
                                      placement: PopoverPlacement.left,
                                      color: widget.arrowColor,
                                      theme: theme),
                                ),
                              ),
                            ),
                          ],
                        )
                      : PopoverWidget(
                          showArrow: widget.showArrow,
                          placement: computedPlacement!,
                          theme: theme,
                          content: widget.content,
                          actions: widget.actions,
                          customPopoverWidgetBuilder:
                              widget.customPopoverWidgetBuilder,
                        );
                  break;
                case PopoverPlacement.right:
                  _child = widget.showArrow
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: (theme.size!().itemExtent -
                                          ArrowMaxLength) /
                                      2),
                              child: SizedBox(
                                width: ArrowMinLength,
                                height: ArrowMaxLength,
                                child: CustomPaint(
                                  painter: ArrowPainter(
                                      placement: PopoverPlacement.right,
                                      color: widget.arrowColor,
                                      theme: theme),
                                ),
                              ),
                            ),
                            PopoverWidget(
                              showArrow: widget.showArrow,
                              placement: computedPlacement,
                              theme: theme,
                              content: widget.content,
                              actions: widget.actions,
                              customPopoverWidgetBuilder:
                                  widget.customPopoverWidgetBuilder,
                            ),
                          ],
                        )
                      : PopoverWidget(
                          showArrow: widget.showArrow,
                          placement: computedPlacement,
                          theme: theme,
                          content: widget.content,
                          actions: widget.actions,
                          customPopoverWidgetBuilder:
                              widget.customPopoverWidgetBuilder,
                        );
                  break;
              }

              return Opacity(
                opacity: size,
                child: Transform(
                  transform: _transform,
                  child: _child,
                ),
              );
            },
          ),
        )
      ];

      if (widget.triggerType != PopoverTriggerType.property) {
        _children.insert(
          0,
          GestureDetector(
            onTap: _remove,
            child: buildBlurWidget(
              sigmaX: 5,
              sigmaY: 5,
              child: Container(
                color: theme.backgroundPrimaryColor.withOpacity(.5),
              ),
            ),
          ),
        );
      }
      if (widget.effective == true) {
        HapticFeedback.heavyImpact();

        _children.insert(
            1,
            Positioned(
                left: triggerWidgetOffset.dx,
                top: triggerWidgetOffset.dy,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: triggerWidgetSize.width,
                        maxHeight: triggerWidgetSize.height),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(theme.size!().cardBorderRadius),
                      child: TweenAnimationBuilder(
                          duration: Duration(milliseconds: 300),
                          tween: Tween<double>(begin: 0, end: 1),
                          curve: Curves.easeInOutCubic,
                          child: IgnorePointer(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: theme.dialogBackgroundColor,
                                    borderRadius: BorderRadius.circular(
                                        theme.size!().cardBorderRadius)),
                                child: widget.child),
                          ),
                          builder: (_, double value, child) {
                            final delta = value < 0.8 ? 1 : -1;
                            return Transform.scale(
                              scale: 1 + value * 0.05 * delta,
                              child: child,
                            );
                          }),
                    ))));
      }
      return PopoverScope(
        popoverEntry: popoverEntry,
        show: widget.show,
        triggerType: widget.triggerType,
        child: Stack(
          children: _children,
        ),
      );
    });

    return popoverEntry;
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.triggerType == PopoverTriggerType.press) {
      _overlayEntry = buildOverlay();
      if (_overlayEntry != null) {
        Overlay.of(LeoFeedback.currentContext!).insert(_overlayEntry!);
      }
    }
  }

  void _onLongPress() {
    if (widget.triggerType == PopoverTriggerType.lonPress) {
      _overlayEntry = buildOverlay();
      if (_overlayEntry != null) {
        Overlay.of(LeoFeedback.currentContext!).insert(_overlayEntry!);
      }
    }
  }

  void _remove() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
  }

  @override
  void initState() {
    if (widget.show == true) {
      //show can be null or bool so do this
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _overlayEntry = buildOverlay();
        Overlay.of(context).insert(_overlayEntry!);
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Popover oldWidget) {
    if (widget.show != oldWidget.show) {
      if (widget.show == true) {
        //show can be null or bool so do this
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _overlayEntry = buildOverlay();
          Overlay.of(context).insert(_overlayEntry!);
        });
      } else if (widget.show == false) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _remove();
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);
    return GestureDetector(
        onTapDown:
            widget.triggerType == PopoverTriggerType.press ? _onTapDown : null,
        onLongPress: widget.triggerType == PopoverTriggerType.lonPress
            ? _onLongPress
            : null,
        key: triggerWidget,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
            Offstage(
              offstage: true,
              child: Column(
                children: [
                  PopoverWidget(
                    theme: theme,
                    key: popoverWidgetKey,
                    content: widget.content,
                    actions: widget.actions,
                    customPopoverWidgetBuilder:
                        widget.customPopoverWidgetBuilder,
                  ),
                  ...(widget.customPopoverWidgetBuilder != null
                      ? [widget.customPopoverWidgetBuilder!(context)]
                      : [])
                ],
              ),
            ),
          ],
        ));
  }
}
