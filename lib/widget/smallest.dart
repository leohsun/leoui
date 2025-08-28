import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Smallest extends SingleChildRenderObjectWidget {
  const Smallest({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => CreateSmallest();
}

class CreateSmallest extends RenderProxyBoxWithHitTestBehavior {
  @override
  set behavior(HitTestBehavior _behavior) => HitTestBehavior.opaque;

  @override
  void performLayout() {
    child?.layout(BoxConstraints(), parentUsesSize: true);
    size = child?.size ?? Size.zero;
  }
}
