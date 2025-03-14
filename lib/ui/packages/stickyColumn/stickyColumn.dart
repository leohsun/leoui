import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/ui/packages/stickyColumn/stickyContainer.dart';

class StickyColumnParentData extends MultiChildLayoutParentData {}

class StickyColumn extends MultiChildRenderObjectWidget {
  StickyColumn({super.key, super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StickyColumnRenderer();
  }
}

class StickyColumnRenderer extends RenderProxyBox
    with
        ContainerRenderObjectMixin<RenderBox, StickyColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StickyColumnParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! StickyColumnParentData) {
      child.parentData = StickyColumnParentData();
    }
  }

  @override
  void performLayout() {
    double totalHeight = 0, totalWidth = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      StickyColumnParentData parentData =
          child.parentData as StickyColumnParentData;

      child.layout(constraints, parentUsesSize: true);

      totalWidth = max(totalWidth, child.size.width);

      parentData.offset = Offset(0, totalHeight);

      totalHeight += child.size.height;

      child = parentData.nextSibling;
    }

    size = Size(totalWidth, totalHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    List<StickyContainerRenderer> stickyChildren = [];

    RenderBox? child = firstChild;

    while (child != null) {
      final StickyColumnParentData childParentData =
          child.parentData! as StickyColumnParentData;

      if (child is StickyContainerRenderer &&
          (child.top != null || child.bottom != null)) {
        if (child.top != null &&
            size.height - child.size.height - child.top! > 0) {
          double stickyTopEdge = childParentData.offset.dy - child.top!;
          double stickyTopEdgeOfScrolling = offset.dy + stickyTopEdge;

          if (stickyTopEdgeOfScrolling < 0) {
            double parentVisibleHeight =
                clampDouble(offset.dy + size.height, 0, size.height);
            double childVisibleHeight = child.size.height + child.top!;
            double dy = min(child.top!,
                parentVisibleHeight - childVisibleHeight + child.top!);
            child.stickyOffset = Offset(0, dy);
            stickyChildren.add(child);
          } else {
            context.paintChild(child, childParentData.offset + offset);
          }
        } else if (child.bottom != null &&
            size.height -
                    childParentData.offset.dy -
                    child.size.height -
                    child.bottom! >
                0) {
          double stickyBottomEdgeOfScrolling = context.estimatedBounds.height -
              offset.dy -
              child.bottom! -
              childParentData.offset.dy -
              child.size.height;

          if (stickyBottomEdgeOfScrolling < 0) {
            double parentVisibleHeight = clampDouble(
                context.estimatedBounds.height - offset.dy, 0, size.height);
            double childVisibleHeight = child.size.height + child.bottom!;

            child.stickyOffset = childParentData.offset +
                offset +
                Offset(
                  0,
                  stickyBottomEdgeOfScrolling -
                      (parentVisibleHeight - childVisibleHeight > 0
                          ? 0
                          : parentVisibleHeight - childVisibleHeight),
                );
            stickyChildren.add(child);
          } else {
            context.paintChild(child, childParentData.offset + offset);
          }
        } else {
          context.paintChild(child, childParentData.offset + offset);
        }
      } else {
        context.paintChild(child, childParentData.offset + offset);
      }

      child = childParentData.nextSibling;
    }

    for (var stickyChild in stickyChildren) {
      context.paintChild(stickyChild, stickyChild.stickyOffset);
    }
  }
}
