import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/widget/friendly_tap_container.dart';

class GlobalTapDetector extends SingleChildRenderObjectWidget {
  GlobalTapDetector({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      GlobalTapDetectorRenderBox();
}

class GlobalTapDetectorRenderBox extends RenderProxyBoxWithHitTestBehavior {
  @override
  HitTestBehavior get behavior => HitTestBehavior.opaque;

  List<FriendlyTapContainerRenderBox> _targets = [];

  static GlobalTapDetectorRenderBox? of(BuildContext context) {
    GlobalTapDetectorRenderBox? globalTapDetectorRenderBox =
        context.findAncestorRenderObjectOfType<GlobalTapDetectorRenderBox>();
    return globalTapDetectorRenderBox;
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
    if (_targets.isEmpty) return;
    Offset globalPosition = entry.target.localToGlobal(entry.localPosition);

    for (int i = _targets.length - 1; i >= 0; i--) {
      FriendlyTapContainerRenderBox target = _targets[i];

      Offset targetGlobalPosition = target.localToGlobal(
          Offset(target.validTapRect.left, target.validTapRect.top));

      bool aimed = Size(target.validTapRect.width, target.validTapRect.height)
          .contains(globalPosition - targetGlobalPosition);

      if (!aimed) continue;

      if (event is PointerDownEvent) {
        target.setActive(active: true);
      }
      if (event is PointerUpEvent) {
        target.setActive(active: false);
        target.handleTap();
      }

      break;
    }
  }
}
