import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leoui/leoui.dart';

Size measureWidget(Widget widget) {
  final PipelineOwner pipelineOwner = PipelineOwner();
  final MeasurementView rootView = pipelineOwner.rootNode = MeasurementView();
  // final MeasurementView rootView = pipelineOwner.rootNode = LeoFeedback.currentContext!.owner;
  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  final RenderObjectToWidgetElement<RenderBox> element =
      RenderObjectToWidgetAdapter<RenderBox>(
    container: rootView,
    debugShortDescription: '[root]',
    child: LeoFeedback.rootWidget(child: widget),
  ).attachToRenderTree(buildOwner);
  try {
    rootView.scheduleInitialLayout();
    pipelineOwner.flushLayout();
    return rootView.size;
  } finally {
    // Clean up.
    element.update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
    buildOwner.finalizeTree();
  }
}

class MeasurementView extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    assert(child != null);
    child!.layout(const BoxConstraints(), parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;
}
