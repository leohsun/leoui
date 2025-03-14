library leoui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/widget/leoui_state.dart';

export './feedback/index.dart';
export './model/index.dart';
export './utils/index.dart';
export './ui/index.dart';
export './config/index.dart';

class Leoui extends MultiChildRenderObjectWidget {
  Leoui(
      {super.key,
      required MaterialApp Function(ValueChanged<VoidCallback> setState)
          childBuilder,
      LeouiConfig? config,
      VoidCallback? initState,
      VoidCallback? dispose,
      Future Function()? setup,
      Widget? setupPlaceholder,
      ValueChanged<AppLifecycleState>? didChangeAppLifecycleState})
      : super(children: [
          LeouiStateWidget(
            childBuilder: childBuilder,
            config: config,
            setup: setup,
            initState: initState,
            didChangeAppLifecycleState: didChangeAppLifecycleState,
            dispose: dispose,
          ),
          setupPlaceholder ?? Container(color: Colors.white)
        ]);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderLeoui();

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class RenderLeouiParentData extends MultiChildLayoutParentData {}

class RenderLeoui extends RenderProxyBox
    with
        ContainerRenderObjectMixin<RenderBox, RenderLeouiParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, RenderLeouiParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! RenderLeouiParentData) {
      child.parentData = RenderLeouiParentData();
    }
  }

  @override
  void performLayout() {
    if (constraints.maxWidth == 0) return;

    RenderObject? child = firstChild;

    while (child != null) {
      RenderLeouiParentData parentData =
          child.parentData! as RenderLeouiParentData;
      child.layout(constraints, parentUsesSize: true);
      child = parentData.nextSibling;
    }

    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.width == 0) {
      context.paintChild(lastChild!, offset);
    } else if (firstChild != null) {
      context.paintChild(firstChild!, offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return firstChild?.hitTest(
          result,
          position: position,
        ) ??
        false;
  }
}
