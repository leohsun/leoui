import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StickyContainer extends SingleChildRenderObjectWidget {
  final double? top;
  final double? bottom;

  StickyContainer({super.key, this.top, this.bottom, super.child})
      : assert(top == null || bottom == null,
            "only can provide one proptery of top and bottom");

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StickyContainerRenderer(top: top, bottom: bottom);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant StickyContainerRenderer renderObject) {
    renderObject
      ..top = top
      ..bottom = bottom;
  }
}

class StickyContainerRenderer extends RenderProxyBox {
  double? top;
  double? bottom;

  Offset stickyOffset = Offset.zero;

  StickyContainerRenderer({required this.top, required this.bottom});
}
