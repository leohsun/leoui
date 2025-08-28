import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/utils/extensions.dart';

class StickyColumnParentData extends MultiChildLayoutParentData {
  int flex;

  Offset nonStickyOffset;

  int index;

  bool isSticky;
  double? top;
  double? bottom;

  StickyColumnParentData(
      {this.index = 0,
      this.flex = 0,
      this.nonStickyOffset = Offset.zero,
      this.isSticky = false,
      this.top,
      this.bottom});

  @override
  String toString() {
    final List<String> values = <String>[
      'flex=$flex',
      'nonStickyOffset=$nonStickyOffset',
      'offset=$offset',
      'index=$index',
      'isSticky=$isSticky',
      if (top != null) 'top=$top',
      if (bottom != null) 'bottom=$bottom',
    ];
    if (values.isEmpty) {
      values.add('not positioned');
    }
    return values.join('; ');
  }
}

class StickyExpanded extends ParentDataWidget<StickyColumnParentData> {
  final int flex = 1;

  StickyExpanded({required super.child});

  @override
  void applyParentData(RenderObject renderObject) {
    final StickyColumnParentData parentData =
        renderObject.parentData! as StickyColumnParentData;
    if (parentData.flex != flex) {
      parentData.flex = flex;
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => StickyColumn;
}

class StickyContainer extends ParentDataWidget<StickyColumnParentData> {
  final bool isSticky = true;
  final double? top;
  final double? bottom;

  StickyContainer({this.top, this.bottom, required super.child});

  @override
  void applyParentData(RenderObject renderObject) {
    final StickyColumnParentData parentData =
        renderObject.parentData! as StickyColumnParentData;
    bool needLayout = false;
    if (parentData.isSticky != isSticky) {
      parentData.isSticky = isSticky;
      needLayout = true;
    }

    if (parentData.top != top) {
      parentData.top = top;
      needLayout = true;
    }

    if (parentData.bottom != bottom) {
      parentData.bottom = bottom;
    }
    if (needLayout) {
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => StickyColumn;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('top', top, defaultValue: null));
    properties.add(DoubleProperty('bottom', bottom, defaultValue: null));
  }
}

class StickyColumn extends MultiChildRenderObjectWidget {
  factory StickyColumn(
      {Key? key,
      ScrollController? scrollController,
      required List<Widget> children}) {
    List<Widget> stickyChildren = [];
    List<Widget> nonStickyChildren = [];
    List<int> stickyChildIndexes = [];
    List<int> noStickyChildIndexes = [];

    children.forEachWithIndex((child, index) {
      if (child is StickyContainer) {
        stickyChildren.add(child);
        stickyChildIndexes.add(index);
      } else {
        nonStickyChildren.add(child);
        noStickyChildIndexes.add(index);
      }
    });

    return StickyColumn.raw(
      key: key,
      children: [...nonStickyChildren, ...stickyChildren],
      childIndexes: [...noStickyChildIndexes, ...stickyChildIndexes],
      scrollController: scrollController,
    );
  }

  final List<int> childIndexes;
  final ScrollController? scrollController;

  StickyColumn.raw(
      {super.key,
      super.children,
      required this.childIndexes,
      this.scrollController});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StickyColumnRenderer(
        childIndexes: childIndexes,
        scrollController: scrollController,
        scrollPosition: Scrollable.of(context).position);
  }
}

class StickyColumnRenderer extends RenderProxyBox
    with
        ContainerRenderObjectMixin<RenderBox, StickyColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StickyColumnParentData> {
  final ScrollPosition? scrollPosition;
  final ScrollController? scrollController;

  final List<int> childIndexes;

  int step = 0;

  List<RenderBox> rawChildren = [];

  double scrollDy = 0;

  StickyColumnRenderer(
      {required this.childIndexes, this.scrollPosition, this.scrollController});

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! StickyColumnParentData) {
      child.parentData = StickyColumnParentData(index: childIndexes[step++]);

      if (step == childIndexes.length) {
        step = 0;
      }
    }
  }

  List<RenderBox> sortChildrenViaRawIndex() {
    List<RenderBox?> result = List.filled(childIndexes.length, null);
    RenderBox? child = firstChild;

    while (child != null) {
      StickyColumnParentData parentData =
          child.parentData as StickyColumnParentData;

      result[parentData.index] = child;

      child = parentData.nextSibling;
    }

    return result.filter((element) => element != null);
  }

  @override
  void attach(PipelineOwner owner) {
    if (scrollController != null) {
      scrollController!.addListener(() {
        scrollDy = scrollController!.position.pixels;
        markNeedsPaint();
      });
    } else if (scrollPosition != null) {
      scrollPosition!.addListener(() {
        scrollDy = scrollPosition!.pixels;
        markNeedsPaint();
      });
    }
    super.attach(owner);
  }

  bool _overflow = false;

  Size _calcSize = Size.zero;

  Offset? _PAINT_OFFSET;

  double totalHeight = 0,
      totalWidth = 0,
      totalFlex = 0,
      calcTotalFlexHeight = 0, // maybe infinite
      totalFiniteFlexHeight = 0,
      nonFlexHeight = 0;

  List<RenderBox> stickyChildren = [];

  Size totalDrySize = Size.zero;

  void resetVariables() {
    totalHeight = totalWidth = totalFlex =
        calcTotalFlexHeight = totalFiniteFlexHeight = nonFlexHeight = 0;
  }

  Size _perfomLayout(BoxConstraints constraints, {bool dry = false}) {
    resetVariables();
    RenderBox? child = firstChild;

    /// non-flex children
    child = firstChild;
    while (child != null) {
      StickyColumnParentData parentData =
          child.parentData as StickyColumnParentData;
      totalFlex += parentData.flex;
      child.layout(constraints, parentUsesSize: true);

      if (parentData.flex == 0) {
        child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
            parentUsesSize: true);
        nonFlexHeight += child.size.height;
      }
      child = parentData.nextSibling;
    }

    calcTotalFlexHeight = constraints.maxHeight - nonFlexHeight;

    if (calcTotalFlexHeight.isNegative) {
      FlutterError.dumpErrorToConsole(FlutterErrorDetails(
          library: "Leoui",
          exception:
              "StickyColumn height is overflow ${-calcTotalFlexHeight} pixels, StickyExpanded is not working!!!"));
      calcTotalFlexHeight = double.infinity;
    }

    ///flex children, constraint its max[min]Height;
    child = firstChild;
    while (child != null) {
      StickyColumnParentData parentData =
          child.parentData as StickyColumnParentData;
      if (parentData.flex > 0) {
        BoxConstraints consts = BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: calcTotalFlexHeight * parentData.flex / totalFlex,
            minHeight: calcTotalFlexHeight.isInfinite
                ? 0
                : calcTotalFlexHeight * parentData.flex / totalFlex);

        child.layout(consts, parentUsesSize: true);
        totalFiniteFlexHeight += child.size.height;
      }
      child = parentData.nextSibling;
    }

    totalHeight = nonFlexHeight + totalFiniteFlexHeight;

    ///distribute non-sticky offset and calc dry size
    double prevHeight = 0;
    var sortedChildren = sortChildrenViaRawIndex();
    for (var child in sortedChildren) {
      StickyColumnParentData parentData =
          child.parentData as StickyColumnParentData;
      if (dry) {
        Size drySize = child.getDryLayout(constraints);
        totalDrySize +=
            Offset(max(totalDrySize.width, drySize.width), drySize.height);
      } else {
        Size childSize = child.size;

        totalWidth = max(totalWidth, childSize.width);

        if (parentData.isSticky) {
          stickyChildren.add(child);
        }
        parentData.nonStickyOffset = Offset(0, prevHeight);
        parentData.offset = Offset(0, prevHeight);

        prevHeight += childSize.height;
      }
    }

    return dry
        ? totalDrySize
        : Size(
            totalWidth,
            constraints.maxHeight.isFinite
                ? max(totalHeight, constraints.maxHeight)
                : totalHeight);
  }

  @override
  void performLayout() {
    _calcSize = _perfomLayout(constraints);
    if (_calcSize.height > constraints.maxHeight) {
      size = constraints.constrain(_calcSize);
      _overflow = true;
    } else {
      size = _calcSize;
      _overflow = false;
    }
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _perfomLayout(constraints, dry: true);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  void _paintChildren(PaintingContext context, Offset offset) {
    if (_PAINT_OFFSET == null) return;

    RenderBox? child = firstChild;

    while (child != null) {
      StickyColumnParentData parentData =
          child.parentData as StickyColumnParentData;
      if (scrollPosition != null &&
          parentData.isSticky &&
          (parentData.top != null || parentData.bottom != null)) {
        double parentHiddenHeight = max(scrollDy - _PAINT_OFFSET!.dy, 0);

        double childTopToEdge = _PAINT_OFFSET!.dy -
            parentData.top! -
            parentData.nonStickyOffset.dy -
            scrollDy;

        if (parentData.top != null) {
          double childTopFactor = _PAINT_OFFSET!.dy +
              totalHeight -
              scrollDy -
              child.size.height -
              parentData.top!;

          double scrollTop = clampDouble(
              -childTopToEdge, 0, parentData.top! + parentHiddenHeight);

          parentData.offset = Offset(0, scrollTop + min(0, childTopFactor));
        } else {
          print("bottom");
          // parentData.offset =
          //     Offset(0, parentData.nonStickyOffset.dy - parentData.bottom!);
        }
      }
      child.paint(context, parentData.offset + offset);

      child = parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_PAINT_OFFSET == null) {
      _PAINT_OFFSET = offset;
      Future.microtask(markNeedsLayout);
      return;
    }
    if (!_overflow) {
      return _paintChildren(context, offset);
    }

    var _layer = layer as ClipRectLayer?;
    layer = context.pushClipRect(true, offset, offset & size, _paintChildren,
        oldLayer: _layer);
  }
}
