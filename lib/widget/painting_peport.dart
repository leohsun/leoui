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
    super.child,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (onPainting != null) {
      onPainting!(offset, size);
    }
  }
}
