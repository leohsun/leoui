library leo_ui.popover;

import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/utils/index.dart';
import 'package:leoui/utils/size.dart';

enum popoverDirection { auto, top, bottom }

class Popover extends StatefulWidget {
  final Alignment? alignment;
  final Widget child;
  final Widget menu;
  final bool showIndicator;
  final bool transparent;
  final popoverDirection direction;
  final double gap;
  final double? menuHeight;
  final LeouiBrightness? brightness;

  const Popover(
      {Key? key,
      this.alignment,
      required this.child,
      required this.menu,
      this.transparent = false,
      this.showIndicator = false,
      this.menuHeight,
      this.brightness,
      this.direction = popoverDirection.auto,
      this.gap = 10})
      : assert(direction == popoverDirection.auto || menuHeight != null,
            'when direction is not \'auto\',then \'menuHeight\' must be provided'),
        super(key: key);

  @override
  _PopoverState createState() => _PopoverState();
}

class _PopoverState extends State<Popover> with SingleTickerProviderStateMixin {
  GlobalKey triggerWidget = GlobalKey(debugLabel: 'triggerWidget');

  OverlayEntry? _overlayEntry;

  bool isExpanded = false;

  late LeouiThemeData theme;

  double gap = 30;

  late AnimationController _controller;
  late Animation<double> _tweenAnimation;

  Size size = SizeTool.deviceSize;

  OverlayEntry buildOverlay(Offset offset) {
    double? top;
    double? bottom;

    Alignment? _alignment = widget.alignment;

    RenderBox? triggerWidgetRenderbox =
        (triggerWidget.currentContext!.findRenderObject() as RenderBox);

    Offset triggerWidgetOffset =
        triggerWidgetRenderbox.localToGlobal(Offset.zero);
    Size triggerWidgetSize = triggerWidgetRenderbox.size;

    if (widget.direction == popoverDirection.auto) {
      bool atLeft = offset.dx < SizeTool.deviceWidth / 2;
      if (offset.dy > size.height / 2) {
        bottom = size.height - offset.dy + widget.gap;
        if (atLeft) {
          _alignment = Alignment.bottomLeft;
        } else
          _alignment = Alignment.bottomRight;
      } else {
        top = triggerWidgetOffset.dy + triggerWidgetSize.height + widget.gap;
        if (atLeft) {
          _alignment = Alignment.topLeft;
        } else
          _alignment = Alignment.topRight;
      }
    } else if (widget.direction == popoverDirection.top) {
      double maxTopGap = triggerWidgetOffset.dy - SizeTool.devicePadding.top;
      if (maxTopGap >= widget.menuHeight!) {
        bottom = SizeTool.deviceHeight - triggerWidgetOffset.dy + widget.gap;
      } else {
        top = triggerWidgetOffset.dy + triggerWidgetSize.height + widget.gap;
      }
    } else if (widget.direction == popoverDirection.bottom) {
      double maxBottomGap = SizeTool.deviceHeight -
          triggerWidgetOffset.dy -
          SizeTool.devicePadding.bottom -
          triggerWidgetSize.height;

      if (maxBottomGap > widget.menuHeight!) {
        top = triggerWidgetOffset.dy + triggerWidgetSize.height + widget.gap;
      } else {
        bottom = SizeTool.deviceHeight - triggerWidgetOffset.dy + widget.gap;
      }
    }

    return OverlayEntry(builder: (BuildContext content) {
      return Stack(
        children: [
          GestureDetector(
            onTap: _remove,
            child: Container(
              color: widget.transparent ? Colors.transparent : Colors.black12,
            ),
          ),
          Positioned(
            top: top,
            left: 20,
            right: 20,
            bottom: bottom,
            child: TweenAnimationBuilder(
              duration: Duration(milliseconds: 300),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeInOutCubic,
              builder: (context, double size, _) {
                Matrix4 _transform;
                if (widget.direction == popoverDirection.auto) {
                  _transform = Matrix4.identity()..scale(size);
                } else if (top == null) {
                  _transform = Matrix4.identity()
                    ..translate(0.0, 30 - 30 * size, 0);
                } else {
                  _transform = Matrix4.identity()
                    ..translate(0.0, size * 30 - 30, 0);
                }

                return Opacity(
                  opacity: size,
                  child: Transform(
                    transform: _transform,
                    alignment: _alignment,
                    child: Material(
                      borderRadius:
                          BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
                      child: widget.menu,
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
    setState(() {
      isExpanded = true;
    });
    if (widget.showIndicator) {
      _controller.forward();
    }
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _remove() {
    setState(() {
      isExpanded = false;
    });
    if (widget.showIndicator) {
      _controller.reverse();
    }
    _overlayEntry!.remove();
  }

  @override
  void initState() {
    if (widget.showIndicator) {
      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300));
      _tweenAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
        ..addListener(() {
          setState(() {});
        });
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.showIndicator) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = widget.brightness != null
        ? LeouiThemeData(brightness: Brightness)
        : LeouiTheme.of(context);
    List<Widget> _children = [
      Flexible(child: widget.child),
    ];

    if (widget.showIndicator) {
      _children.add(Transform(
          transform: Matrix4.identity()
            ..rotateX(_tweenAnimation.value * 3.1415926),
          alignment: Alignment.center,
          child: Icon(Icons.expand_more)));
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      child: Row(
        key: triggerWidget,
        mainAxisSize: MainAxisSize.min,
        children: _children,
      ),
    );
  }
}
