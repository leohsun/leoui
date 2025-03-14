import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScratcherParentData extends MultiChildLayoutParentData {}

class Scratcher extends MultiChildRenderObjectWidget {
  Scratcher(
      {Widget? this.mask = const ColoredBox(
        color: Color(0xFFA7A7A0),
      ),
      required this.child})
      : super(children: [mask!, child]);
  final Widget? mask;
  final Widget child;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderScratcher(mask: mask);
}

class RenderScratcher extends RenderProxyBoxWithHitTestBehavior
    with
        ContainerRenderObjectMixin<RenderBox, ScratcherParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ScratcherParentData> {
  final Widget? mask;
  late PanGestureRecognizer panGestureRecognizer;

  RenderScratcher({Widget? this.mask});

  final double scratchSize = 30;

  Offset paintOffset = Offset.zero;

  @override
  void attach(PipelineOwner owner) {
    panGestureRecognizer = PanGestureRecognizer()
      ..onStart = _handlePointerDown
      ..onUpdate = _handlePointerMove
      ..onEnd = _handlePointerUp;

    Future.delayed(Duration.zero, _calcScratchSize);

    super.attach(owner);
  }

  List<Offset?> scratchPoints = [];

  Map<RRect, int> scratchRRectMap = {};

  void _addNewPoint([offset]) {
    if (offset != null) {
      if (scratchPoints.contains(offset)) {
        debugPrint('repeated ignore!');
        return;
      }

      if (!size.contains(offset)) {
        debugPrint('outof range, breaking line!');
        if (scratchPoints.last != null) {
          offset = null;
        } else {
          return;
        }
      }
    }
    scratchPoints.add(offset);
    markNeedsPaint();
  }

  void _handlePointerDown(DragStartDetails details) {
    _addNewPoint(details.localPosition);
  }

  void _handlePointerMove(DragUpdateDetails details) async {
    _addNewPoint(details.localPosition);
  }

  void _handlePointerUp(DragEndDetails details) async {
    _addNewPoint();
    Future.delayed(Duration(milliseconds: 300), _calcScratchSize);
  }

  void _calcScratchSize() {
    if (scratchRRectMap.isEmpty) return;
    debugPrint(scratchRRectMap.toString());

    double area = 0;
    double viewArea = size.width * size.height;
    List<RRect> scratchRRectList = [];
    scratchRRectMap.forEach((current, value) {
      scratchRRectList.add(current);
    });

    for (int i = 0; i < scratchRRectList.length; i++) {
      final current = scratchRRectList[i];
      final currentArea = current.width * current.height;
      double deltaArea = 0;
      for (int j = i + 1; j < scratchRRectList.length; j++) {
        final loop = scratchRRectList[j];

        bool horizontalIntersection =
            (current.right > loop.left && current.right < loop.right) ||
                (current.left > loop.left && current.left < loop.right);

        bool vertialIntersection =
            (current.top > loop.top && current.top < loop.bottom) ||
                (current.bottom > loop.top && current.bottom < loop.bottom);

        if (horizontalIntersection && vertialIntersection) {
          // intersect
          double deltaW =
              min(current.right, loop.right) - max(current.left, loop.left);
          double deltaH =
              min(current.bottom, loop.bottom) - max(current.top, loop.top);

          debugPrint("intersection: $currentArea --> $deltaW -- $deltaH");

          deltaArea += deltaW * deltaH;

          if (deltaArea >= currentArea) {
            debugPrint('break');
            break;
          }
        }
      }
      debugPrint("$i:current area: ${max(0, currentArea - deltaArea)}");
      area += max(0, currentArea - deltaArea);
    }

    debugPrint("view :$viewArea ;area: $area, progress: ${area / viewArea}");
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ScratcherParentData) {
      child.parentData = ScratcherParentData();
    }
  }

  @override
  void performLayout() {
    Size? _size = Size.zero;

    if (lastChild != null) {
      lastChild!.layout(constraints, parentUsesSize: true);
      _size = lastChild!.size;
    }

    if (firstChild != null) {
      firstChild!.layout(
          constraints.tighten(width: _size.width, height: _size.height),
          parentUsesSize: true);
    }

    size = _size;
  }

  void paintScratchPath(Canvas canvas, Offset offset) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.white
      ..blendMode = BlendMode.clear
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.fill;
    for (int i = 0; i < scratchPoints.length - 1; i++) {
      Offset? current = scratchPoints[i];
      Offset? next = scratchPoints[i + 1];

      if (current != null) {
        if (next != null) {
          Offset a = current + offset;
          Offset b = next + offset;
          RRect rrect = RRect.fromLTRBAndCorners(
            max(min(a.dx - scratchSize / 2, b.dx + scratchSize / 2), offset.dx),
            max(min(a.dy - scratchSize / 2, b.dy + scratchSize / 2), offset.dy),
            min(max(a.dx - scratchSize / 2, b.dx + scratchSize / 2),
                offset.dx + size.width),
            min(max(a.dy - scratchSize / 2, b.dy + scratchSize / 2),
                offset.dy + size.height),
            topLeft: Radius.circular(scratchSize / 2),
            topRight: Radius.circular(scratchSize / 2),
            bottomLeft: Radius.circular(scratchSize / 2),
            bottomRight: Radius.circular(scratchSize / 2),
          );
          if (!scratchRRectMap.containsKey(rrect)) {
            scratchRRectMap[rrect] = 1;
          }
          canvas.drawRRect(rrect, paint);
        } else {
          Offset drawingOffset = current + offset;
          RRect rrect = RRect.fromLTRBAndCorners(
            max(drawingOffset.dx - scratchSize / 2, offset.dx),
            max(drawingOffset.dy - scratchSize / 2, offset.dy),
            min(drawingOffset.dx + scratchSize / 2, offset.dx + size.width),
            min(drawingOffset.dy + scratchSize / 2, offset.dy + size.height),
            topLeft: Radius.circular(scratchSize / 2),
            topRight: Radius.circular(scratchSize / 2),
            bottomLeft: Radius.circular(scratchSize / 2),
            bottomRight: Radius.circular(scratchSize / 2),
          );

          if (!scratchRRectMap.containsKey(rrect)) {
            scratchRRectMap[rrect] = 1;
          }
          canvas.drawRRect(rrect, paint);
        }
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    if (lastChild != null) {
      paintOffset = offset;
      context.paintChild(lastChild!, offset);
      // canvas.saveLayer(offset & size, Paint());
      if (firstChild != null) {
        context.paintChild(firstChild!, offset);
      }
      if (scratchPoints.isNotEmpty) {
        paintScratchPath(canvas, offset);
      }
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      panGestureRecognizer.addPointer(event);
    }
    super.handleEvent(event, entry);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(position: position, result);
  }

  @override
  void detach() {
    panGestureRecognizer.dispose();
    super.detach();
  }
}
