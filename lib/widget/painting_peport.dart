import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef PaintingReportCallBack = void Function(Offset offset, Size size);

class PaintingReport extends SingleChildRenderObjectWidget {
  final PaintingReportCallBack? onPainting;
  const PaintingReport({super.child, this.onPainting});
  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderPaintingReport(onPainting);
}

class RenderPaintingReport extends RenderProxyBoxWithHitTestBehavior {
  final PaintingReportCallBack? onPainting;

  RenderPaintingReport(
    this.onPainting, {
    super.behavior,
  });

  late Size loosenSize;

  Size? cbSize;

  bool get trigger => cbSize != loosenSize;

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    if (child == null) return;
    child!.layout(BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true);
    loosenSize = child!.size;

    super.performLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (onPainting != null && trigger) {
      onPainting!(offset, loosenSize);
      cbSize = loosenSize;
    }
  }
}
