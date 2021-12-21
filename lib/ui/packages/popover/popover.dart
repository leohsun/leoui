library leo_ui.popover1;

import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';

enum PopoverPlacement { top, bottom, left, right }

const double Gap = 10;
const double Translate = 10;

class PopoverPosition {
  final bool canLeft;
  final bool canTop;
  final bool canRight;
  final bool canBottom;

  PopoverPlacement? get firstValidPlacement {
    if (canLeft) return PopoverPlacement.left;
    if (canTop) return PopoverPlacement.top;
    if (canRight) return PopoverPlacement.right;
    if (canRight) return PopoverPlacement.right;
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
  final bool disabled;
  final VoidCallback? onPress;

  PopoverAction(
      {required this.text, this.icon, this.disabled = false, this.onPress});
}

class PopoverWidget extends StatelessWidget {
  final String? content;
  final LeouiThemeData theme;
  const PopoverWidget({Key? key, this.content, required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.backgroundPrimaryColor,
          boxShadow: theme.boxShadow,
          borderRadius: BorderRadius.circular(theme.size.cardBorderRadius)),
      padding: EdgeInsets.all(sz(theme.size.title / 2)),
      child: DefaultTextIconStyle(
          color: theme.labelPrimaryColor, child: Text(content!)),
    );
  }
}

class Popover extends StatefulWidget {
  final Widget child;
  final String? content;
  final LeouiBrightness? brightness;
  final PopoverAction? actions;
  final PopoverPlacement? placement;

  const Popover(
      {Key? key,
      required Widget child,
      this.brightness,
      this.placement = PopoverPlacement.left,
      required this.content})
      : this.child = child,
        this.actions = null,
        super(key: key);

  const Popover.menu(
      {Key? key,
      required this.child,
      this.brightness = LeouiBrightness.light,
      required this.actions,
      this.placement = PopoverPlacement.right})
      : this.content = null,
        super(key: key);

  @override
  _PopoverState createState() => _PopoverState();
}

class _PopoverState extends State<Popover> {
  Size size = SizeTool.deviceSize;
  GlobalKey triggerWidget = GlobalKey(debugLabel: 'triggerWidget');
  GlobalKey popoverWidgetKey = GlobalKey(debugLabel: 'Key');
  late OverlayEntry _overlayEntry;
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

    final double leftMaxGap = triggerWidgetOffset.dx - Gap;
    final double topMaxGap =
        triggerWidgetOffset.dy - Gap - SizeTool.devicePadding.top;
    final double rightMaxGap = SizeTool.deviceWidth -
        triggerWidgetOffset.dx -
        triggerWidgetSize.width -
        Gap;
    final double bottomMaxGap = SizeTool.deviceHeight -
        triggerWidgetOffset.dy -
        triggerWidgetSize.height -
        Gap -
        SizeTool.devicePadding.bottom;

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
      return; // has not enough size to place popover widget

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

  OverlayEntry buildOverlay(Offset offset) {
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
      showToast('Not enough size to show popover', type: ToastType.warning);
    }

    switch (computedPlacement!) {
      case PopoverPlacement.top:
        double exceptLeft = triggerWidgetOffset.dx -
            (triggerWidgetSize.height - popoverWidgetSize.height).abs() / 2;
        bool rightOverflow =
            exceptLeft + popoverWidgetSize.width > SizeTool.deviceWidth;

        if (rightOverflow) {
          right = SizeTool.deviceWidth -
              triggerWidgetOffset.dx -
              triggerWidgetSize.width;
        } else {
          left = exceptLeft;
        }

        top = triggerWidgetOffset.dy - popoverWidgetSize.height - Gap;

        break;
      case PopoverPlacement.bottom:
        top = triggerWidgetOffset.dy + triggerWidgetSize.height + Gap;
        left = triggerWidgetOffset.dx -
            (triggerWidgetSize.height - popoverWidgetSize.height).abs() / 2;
        break;
      case PopoverPlacement.left:
        top = triggerWidgetOffset.dy;
        left = triggerWidgetOffset.dx - popoverWidgetSize.width - Gap;

        break;
      case PopoverPlacement.right:
        top = triggerWidgetOffset.dy;
        left = triggerWidgetOffset.dx + triggerWidgetSize.width + Gap;
        break;
    }

    return OverlayEntry(builder: (BuildContext ctx) {
      return Stack(
        children: [
          GestureDetector(
            onTap: _remove,
            child: Container(
              color: Colors.transparent,
            ),
          ),
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

                return Opacity(
                  opacity: size,
                  child: Transform(
                    transform: _transform,
                    child: PopoverWidget(
                      theme: theme,
                      content: widget.content!,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }

  void _onTapDown(TapDownDetails details) {
    _overlayEntry = buildOverlay(details.globalPosition);
    Overlay.of(context)!.insert(_overlayEntry);
  }

  void _remove() {
    _overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);
    return GestureDetector(
        onTapDown: _onTapDown,
        key: triggerWidget,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
            Offstage(
              offstage: true,
              child: PopoverWidget(
                theme: theme,
                key: popoverWidgetKey,
                content: widget.content,
              ),
            ),
          ],
        ));
  }
}
