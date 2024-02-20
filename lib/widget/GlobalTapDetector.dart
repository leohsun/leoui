import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/widget/FriendlyTapContainer.dart';

class GlobalTapDetector extends SingleChildRenderObjectWidget {
  GlobalTapDetector({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      GlobalTapDetectorRenderBox();
}

class GlobalTapDetectorRenderBox extends RenderProxyBoxWithHitTestBehavior {
  Set<FriendlyTapContainerRenderBox> _targets = {};

  static GlobalTapDetectorRenderBox of(BuildContext context) {
    GlobalTapDetectorRenderBox? globalTapDetectorRenderBox =
        context.findAncestorRenderObjectOfType<GlobalTapDetectorRenderBox>();
    assert(globalTapDetectorRenderBox != null);
    return globalTapDetectorRenderBox!;
  }

  void register(FriendlyTapContainerRenderBox target) {
    if (_targets.contains(target) || target.onTap == null) return;
    _targets.add(target);
  }

  void unregister(FriendlyTapContainerRenderBox target) {
    if (!_targets.contains(target)) return;
    _targets.remove(target);
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    Offset position = entry.localPosition;
    if (_targets.isEmpty) return;

    _targets.forEach((target) {
      bool aimed = Size(target.validTapRect.width, target.validTapRect.height)
          .contains(target.globalToLocal(Offset(
              position.dx - target.validTapRect.left,
              position.dy - target.validTapRect.top)));

      if (!aimed) return;

      if (event is PointerDownEvent) {
        target.setActive(active: true);
      }
      if (event is PointerUpEvent) {
        target.setActive(active: false);
        target.onTap!();
      }
    });
  }
}
