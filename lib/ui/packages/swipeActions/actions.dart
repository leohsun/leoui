part of './swipeActions.dart';

class SwipeAction {
  final String? text;
  final TextStyle? textStyle;
  final Color? backgroudColor;
  final Widget? child;
  final VoidCallback? onTap;

  SwipeAction(
      {this.text, this.textStyle, this.backgroudColor, this.child, this.onTap})
      : assert(
            (text == null && child != null) || (text != null && child == null));
}

enum SwipeActionType { leading, trailing }

abstract class SwipeActionRenderBox extends RenderProxyBoxWithHitTestBehavior {
  SwipeActionType get type;
}

class ClipAction extends SingleChildRenderObjectWidget {
  final FutureOr<void> Function()? onTap;
  final SwipeActionType type;

  ClipAction({super.key, required this.type, this.onTap, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderClipAcion(type: type, onTap: onTap);
  }
}

class RenderClipAcion extends SwipeActionRenderBox {
  final FutureOr<void> Function()? onTap;
  final SwipeActionType type;

  late TapGestureRecognizer _tapGesture;

  RenderClipAcion({required this.type, this.onTap});

  @override
  void attach(PipelineOwner owner) {
    if (onTap != null) {
      _tapGesture = TapGestureRecognizer()
        ..onTap = () {
          onTap!();
        };
    }
    super.attach(owner);
  }

  @override
  void performLayout() {
    if (child == null) {
      return;
    }

    child!.layout(constraints, parentUsesSize: true);

    size = child!.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child == null) {
      layer = null;
      return;
    }

    final parentData = this.parentData as SwipeActionParentData;

    bool overflow = parentData.clipWidth < parentData.dryWidth;

    if (overflow) {
      // print('WWWWW:${parentData.clipWidth}, ${parentData.dryWidth}---$offset');
      layer = context.pushClipRect(
        needsCompositing,
        offset,
        Rect.fromLTWH(0, 0, parentData.clipWidth, child.size.height),
        super.paint,
        oldLayer: layer as ClipRectLayer?,
      );
    } else {
      layer = null;

      context.paintChild(child, offset);
    }
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent && onTap != null) {
      _tapGesture.addPointer(event);
    }
  }
}
