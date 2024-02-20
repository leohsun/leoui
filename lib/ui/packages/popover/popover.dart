library leo_ui.popover;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class PopoverWidget extends StatelessWidget {
  final String? content;
  final List<PopoverAction>? actions;
  final WidgetBuilder? customPopoverWidgetBuilder;
  final LeouiThemeData theme;
  final Color? backgroundColor;
  final bool? showArrow;
  final PopoverPlacement? placement;
  const PopoverWidget(
      {Key? key,
      this.content,
      required this.theme,
      this.backgroundColor,
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
      _child = ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: ArrowMaxLength, minWidth: ArrowMaxLength),
          child: customPopoverWidgetBuilder!(context));
    } else {
      // action here
      _child = buildActionPopoverWidget(context);
    }

    return ClipRRect(
      borderRadius: customPopoverWidgetBuilder != null
          ? BorderRadius.zero
          : BorderRadius.circular(sz(theme.size!().cardBorderRadius / 2)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.dialogBackgroundColor,
          // boxShadow: theme.boxShadow,
          borderRadius:
              BorderRadius.circular(sz(theme.size!().cardBorderRadius / 2)),
        ),
        constraints: BoxConstraints(minHeight: theme.size!().itemExtent),
        child: _child,
      ),
    );
  }
}

class ArrowContainer extends SingleChildRenderObjectWidget {
  final PopoverPlacement placement;
  final LeouiThemeData theme;
  final Color? color;
  final bool? showArrow;
  final Size triggerWidgetSize;
  final Offset triggerWidgetOffset;

  ArrowContainer({
    super.key,
    super.child,
    required this.placement,
    required this.theme,
    this.color,
    this.showArrow = true,
    required this.triggerWidgetSize,
    required this.triggerWidgetOffset,
  });
  @override
  RenderObject createRenderObject(BuildContext context) =>
      ArrowContainerRenderbox(
        placement: placement,
        theme: theme,
        color: color,
        showArrow: showArrow!,
        triggerWidgetOffset: triggerWidgetOffset,
        triggerWidgetSize: triggerWidgetSize,
      );
}

class ArrowContainerRenderbox extends RenderProxyBox {
  final PopoverPlacement placement;
  final LeouiThemeData theme;
  final Color? color;
  final bool showArrow;
  final Size triggerWidgetSize;
  final Offset triggerWidgetOffset;

  ArrowContainerRenderbox({
    required this.placement,
    required this.theme,
    this.color,
    required this.showArrow,
    required this.triggerWidgetSize,
    required this.triggerWidgetOffset,
  });

  Offset getGlobalOffset() {
    return MatrixUtils.transformPoint(getTransformTo(null), Offset.zero);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    Size childSize = child!.size;
    if (showArrow) {
      paintArrow(context.canvas, childSize, offset);
    }
    context.paintChild(child!, offset);
  }

  void paintArrow(Canvas canvas, Size size, Offset offset) {
    Color _color = color ?? theme.dialogBackgroundColor;
    Offset popoverWidgetOffset = getGlobalOffset();

    Paint pathPaint = new Paint()
      ..strokeWidth = 1
      ..color = _color
      ..style = PaintingStyle.fill;
    Offset center = Offset(
        triggerWidgetSize.width < size.width
            ? triggerWidgetSize.width / 2
            : size.width / 2,
        triggerWidgetSize.height < size.height
            ? triggerWidgetSize.height / 2
            : size.height / 2);

    Path path = new Path();

    ///the extend when triggerWidget's width is less than popoverWidget
    double deltaWidth = triggerWidgetSize.width < size.width
        ? triggerWidgetOffset.dx - popoverWidgetOffset.dx
        : 0;

    ///the extend when triggerWidget's height is less than popoverWidget
    double deltaHeight = triggerWidgetSize.height < size.height
        ? triggerWidgetOffset.dy - popoverWidgetOffset.dy
        : 0;

    ///to clear the gap between popoverWidget and arrow
    double delta = 10;
    switch (placement) {
      case PopoverPlacement.top:
        path.moveTo(center.dx - ArrowMaxLength / 2 + deltaWidth,
            size.height - offset.dy);
        path.lineTo(
            center.dx + deltaWidth, size.height + ArrowMinLength + offset.dy);
        path.lineTo(center.dx + ArrowMaxLength / 2 + deltaWidth,
            size.height + offset.dy);
        path.lineTo(center.dx + ArrowMaxLength / 2 + deltaWidth,
            size.height - delta + offset.dy);
        path.lineTo(center.dx - ArrowMaxLength / 2 + deltaWidth,
            size.height - delta + offset.dy);
        break;
      case PopoverPlacement.bottom:
        path.moveTo(center.dx - ArrowMaxLength / 2 + deltaWidth, offset.dy);
        path.lineTo(center.dx + deltaWidth, -ArrowMinLength + offset.dy);
        path.lineTo(center.dx + ArrowMaxLength / 2 + deltaWidth, offset.dy);
        path.lineTo(
            center.dx + ArrowMaxLength / 2 + deltaWidth, delta + offset.dy);
        path.lineTo(
            center.dx - ArrowMaxLength / 2 + deltaWidth, delta + offset.dy);
        break;
      case PopoverPlacement.left:
        path.moveTo(size.width + offset.dx,
            center.dy - ArrowMaxLength / 2 + deltaHeight);
        path.lineTo(
            size.width + ArrowMinLength + offset.dx, center.dy + deltaHeight);
        path.lineTo(size.width + offset.dx,
            center.dy + ArrowMaxLength / 2 + deltaHeight);
        path.lineTo(size.width - delta + offset.dx,
            center.dy + ArrowMaxLength / 2 + deltaHeight);
        path.lineTo(size.width - delta + offset.dx,
            center.dy - ArrowMaxLength / 2 + deltaHeight);
        break;
      case PopoverPlacement.right:
        path.moveTo(offset.dx, center.dy - ArrowMaxLength / 2 + deltaHeight);
        path.lineTo(offset.dx - ArrowMinLength, center.dy + deltaHeight);
        path.lineTo(offset.dx, center.dy + ArrowMaxLength / 2 + deltaHeight);
        path.lineTo(
            delta + offset.dx, center.dy + ArrowMaxLength / 2 + deltaHeight);
        path.lineTo(
            delta + offset.dx, center.dy - ArrowMaxLength / 2 + deltaHeight);
        break;
    }
    canvas.drawPath(path, pathPaint);
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
  final Color? backgroundColor;
  final double? gap;
  final bool? inSafeArea;
  final bool? hideWarningToast;
  final bool? effective;

  const Popover({
    Key? key,
    required Widget child,
    this.brightness,
    this.placement = PopoverPlacement.left,
    this.showArrow = true,
    PopoverTriggerType? triggerType,
    this.show,
    required this.content,
    this.arrowColor,
    this.backgroundColor,
    this.gap = Gap,
    this.inSafeArea = true,
    this.hideWarningToast = false,
    this.effective = false,
  })  : assert(
            (triggerType != PopoverTriggerType.property && show == null) ||
                (show != null &&
                    (triggerType == PopoverTriggerType.property ||
                        triggerType == null)),
            'When triggerType equal to PopoverTriggerType.property then show must be provided'),
        assert(
            brightness == null ||
                (arrowColor == null && backgroundColor == null),
            'when brightness is provided,the arrowColor and background Color must be null'),
        this.triggerType = triggerType ??
            (show != null
                ? PopoverTriggerType.property
                : PopoverTriggerType.press),
        this.child = child,
        this.actions = null,
        this.customPopoverWidgetBuilder = null,
        super(key: key);

  const Popover.menu({
    Key? key,
    required this.child,
    this.brightness,
    required this.actions,
    this.showArrow = true,
    this.placement = PopoverPlacement.right,
    PopoverTriggerType? triggerType,
    this.show,
    this.arrowColor,
    this.backgroundColor,
    this.gap = Gap,
    this.inSafeArea = true,
    this.hideWarningToast = false,
    this.effective,
  })  : assert(
            (triggerType != PopoverTriggerType.property && show == null) ||
                (show != null &&
                    (triggerType == PopoverTriggerType.property ||
                        triggerType == null)),
            'When triggerType equal to PopoverTriggerType.property then show must be provided'),
        assert(
            brightness == null ||
                (arrowColor == null && backgroundColor == null),
            'when brightness is provided,the arrowColor and background Color must be null'),
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
      this.backgroundColor,
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
        assert(
            brightness == null ||
                (arrowColor == null && backgroundColor == null),
            'when brightness is provided,the arrowColor and background Color must be null'),
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
  OverlayEntry? _overlayEntry;
  PopoverPlacement? computedPlacement;

  late LeouiThemeData theme;

  late PopoverWidget popoverWidget;

  late RenderBox triggerWidgetRenderbox;

  late Size popoverWidgetSize;

  late Size triggerWidgetSize;

  Offset get triggerWidgetOffset {
    return triggerWidgetRenderbox.localToGlobal(Offset.zero);
  }

  void _initPopoverWidgetConfig() {
    theme = LeouiTheme.of(context)!.theme(brightness: widget.brightness);
    popoverWidget = PopoverWidget(
      showArrow: widget.showArrow,
      placement: computedPlacement,
      theme: theme,
      content: widget.content,
      actions: widget.actions,
      backgroundColor: widget.backgroundColor,
      customPopoverWidgetBuilder: widget.customPopoverWidgetBuilder,
    );

    popoverWidgetSize = measureWidget(popoverWidget);

    triggerWidgetRenderbox =
        (triggerWidget.currentContext!.findRenderObject() as RenderBox);

    triggerWidgetSize = triggerWidgetRenderbox.size;

    if (widget.show == true) {
      _overlayEntry = buildOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  PopoverPosition calcPosition() {
    final double devicePaddingTop =
        widget.inSafeArea == true ? SizeTool.devicePadding.top : 0;
    final double devicePaddingBottom =
        widget.inSafeArea == true ? SizeTool.devicePadding.bottom : 0;

    final double validViewHeight =
        SizeTool.deviceHeight - devicePaddingBottom - devicePaddingTop;

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
        canLeft: popoverWidgetSize.width <= leftMaxGap &&
            popoverWidgetSize.height <= validViewHeight,
        canTop: popoverWidgetSize.height <= topMaxGap &&
            popoverWidgetSize.width <= SizeTool.deviceWidth,
        canRight: popoverWidgetSize.width <= rightMaxGap &&
            popoverWidgetSize.height <= validViewHeight,
        canBottom: popoverWidgetSize.height <= bottomMaxGap &&
            popoverWidgetSize.width <= SizeTool.deviceWidth);
  }

  calcCorrectPlacement() {
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

    RenderBox? triggerWidgetRenderbox =
        (triggerWidget.currentContext!.findRenderObject() as RenderBox);

    Size triggerWidgetSize = triggerWidgetRenderbox.size;

    calcCorrectPlacement();

    if (computedPlacement == null) {
      if (widget.hideWarningToast == false) {
        showToast('Not enough size of show popover', type: ToastType.warning);
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
        double popoverWidgetPlaceHeight = SizeTool.deviceHeight -
            top -
            (widget.inSafeArea == true ? SizeTool.devicePadding.bottom : 0);
        if (popoverWidgetPlaceHeight < popoverWidgetSize.height) {
          top -= (popoverWidgetSize.height - popoverWidgetPlaceHeight);
        }

        left = triggerWidgetOffset.dx - popoverWidgetSize.width - widget.gap!;
        if (widget.showArrow) {
          left = left! - ArrowMinLength;
        }

        break;
      case PopoverPlacement.right:
        top = triggerWidgetOffset.dy;
        double popoverWidgetPlaceHeight = SizeTool.deviceHeight -
            top -
            (widget.inSafeArea == true ? SizeTool.devicePadding.bottom : 0);
        if (popoverWidgetPlaceHeight < popoverWidgetSize.height) {
          top -= (popoverWidgetSize.height - popoverWidgetPlaceHeight);
        }
        left = triggerWidgetOffset.dx + triggerWidgetSize.width + widget.gap!;
        break;
    }
    late OverlayEntry popoverEntry;

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
                    ..translate(0.0, size * Translate, 0.0);
                  break;
                case PopoverPlacement.left:
                  _transform = Matrix4.identity()
                    ..translate(Translate - size * Translate, 0.0, 0);
                  break;
                case PopoverPlacement.right:
                  _transform = Matrix4.identity()
                    ..translate(size * Translate, 0.0, 0);
                  break;
              }

              return Opacity(
                opacity: size,
                child: Transform(
                  transform: _transform,
                  // child: CustomPaint(
                  //     painter: ArrowPainter(
                  //         placement: computedPlacement!,
                  //         theme: theme,
                  //         color: widget.arrowColor,
                  //         triggerWidgetSize: triggerWidgetSize,
                  //         triggerWidgetOffset: triggerWidgetOffset),
                  //     child: popoverWidget),
                  child: ArrowContainer(
                      placement: computedPlacement!,
                      theme: theme,
                      showArrow: widget.showArrow,
                      color: widget.arrowColor,
                      triggerWidgetSize: triggerWidgetSize,
                      triggerWidgetOffset: triggerWidgetOffset,
                      child: popoverWidget),
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
            child: widget.effective == true
                ? buildBlurWidget(
                    sigmaX: 15,
                    sigmaY: 15,
                    child: Container(
                      color: theme.backgroundPrimaryColor.withOpacity(.4),
                    ),
                  )
                : Container(color: Colors.transparent),
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
    Future.microtask(_initPopoverWidgetConfig);
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
    return GestureDetector(
      onTapDown:
          widget.triggerType == PopoverTriggerType.press ? _onTapDown : null,
      onLongPress: widget.triggerType == PopoverTriggerType.lonPress
          ? _onLongPress
          : null,
      key: triggerWidget,
      child: widget.child,
    );
  }
}
