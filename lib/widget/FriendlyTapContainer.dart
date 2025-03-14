import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/config/theme.dart';
import 'package:leoui/feedback/index.dart';
import 'package:leoui/utils/measureWidget.dart';
import 'package:leoui/widget/GlobalTapDetector.dart';

const Size friendlyTapSize = Size(44, 44);

class FriendlyTapContainer extends SingleChildRenderObjectWidget {
  final VoidCallback? onTap;
  final Widget child;

  /// size width and height to [friendlyTapSize]
  final bool? useFridendlySize;

  /// transparent when tapdown; default is true
  final bool? transparentWhenActive;
  final bool? hideExpandedAreaInDebugMode;

  FriendlyTapContainer(
      {super.key,
      this.onTap,
      required this.child,
      this.useFridendlySize = false,
      this.transparentWhenActive = true,
      this.hideExpandedAreaInDebugMode = false})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return FriendlyTapContainerRenderBox(
        onTap: onTap,
        useFridendlySize: useFridendlySize!,
        transparentWhenActive: transparentWhenActive!,
        hideExpandedAreaInDebugMode: hideExpandedAreaInDebugMode!,
        childWidget: child,
        detector: GlobalTapDetectorRenderBox.of(context));
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant FriendlyTapContainerRenderBox renderObject) {
    renderObject
      ..onTap = onTap
      ..useFridendlySize = useFridendlySize!
      ..transparentWhenActive = transparentWhenActive!
      ..hideExpandedAreaInDebugMode = hideExpandedAreaInDebugMode!
      ..childWidget = child;
  }
}

class FriendlyTapContainerRenderBox extends RenderProxyBox {
  VoidCallback? onTap;
  Widget childWidget;
  bool useFridendlySize;
  bool transparentWhenActive;
  bool hideExpandedAreaInDebugMode;
  GlobalTapDetectorRenderBox detector;

  FriendlyTapContainerRenderBox(
      {this.onTap,
      required this.transparentWhenActive,
      required this.hideExpandedAreaInDebugMode,
      required this.childWidget,
      required this.detector,
      required this.useFridendlySize});

  /// 有效的tap区域
  late final Rect validTapRect;

  /// 额外的tap区域，用于debug时，画出溢出child的有效的tap区域
  late final List<Rect>? expandTapRects;

  late final Size childWidgetSize;

  bool _active = false;

  @override
  bool get isRepaintBoundary => _active && transparentWhenActive;

  void handleTap() {
    if (onTap != null) {
      onTap!();
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      return;
    }

    BoxConstraints _constraints = useFridendlySize
        ? BoxConstraints(
            maxHeight: constraints.maxHeight,
            maxWidth: constraints.maxWidth,
            minWidth: friendlyTapSize.width,
            minHeight: friendlyTapSize.height)
        : constraints;

    child!.layout(_constraints, parentUsesSize: true);

    size = child!.size;
  }

  Rect _getValidTapRect() {
    if (childWidgetSize > friendlyTapSize) {
      return Rect.fromLTWH(0, 0, childWidgetSize.width, childWidgetSize.height);
    }

    double left = childWidgetSize.width < friendlyTapSize.width
        ? (childWidgetSize.width - friendlyTapSize.width) / 2
        : 0;

    double top = childWidgetSize.height < friendlyTapSize.height
        ? (childWidgetSize.height - friendlyTapSize.height) / 2
        : 0;

    double width = max(childWidgetSize.width, friendlyTapSize.width);

    double height = max(childWidgetSize.height, friendlyTapSize.height);

    return Rect.fromLTWH(left, top, width, height);
  }

  List<Rect>? _getExpandeRects() {
    if (hideExpandedAreaInDebugMode || childWidgetSize > friendlyTapSize) {
      return null;
    }

    if (friendlyTapSize > childWidgetSize) {
      return [validTapRect];
    }

    if (friendlyTapSize.width > childWidgetSize.width) {
      double leftForLeftRect =
          (childWidgetSize.width - friendlyTapSize.width) / 2;
      double leftForRightRect = childWidgetSize.width;
      double top = 0;
      double width = -leftForLeftRect;
      double height = childWidgetSize.height;

      return [
        Rect.fromLTWH(leftForLeftRect, top, width, height),
        Rect.fromLTWH(leftForRightRect, top, width, height)
      ];
    } else if (friendlyTapSize.height > childWidgetSize.height) {
      double left = 0;
      double topOfTopRect =
          (childWidgetSize.height - friendlyTapSize.height) / 2;
      double topOfbottomRect = childWidgetSize.height;
      double width = childWidgetSize.width;
      double height = (friendlyTapSize.height - childWidgetSize.height) / 2;

      return [
        Rect.fromLTWH(left, topOfTopRect, width, height),
        Rect.fromLTWH(left, topOfbottomRect, width, height)
      ];
    }

    return null;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    Size childSize = child!.size;
    context.paintChild(child!, offset);
    paintExpandedAreas(context.canvas, childSize, offset);
  }

  void paintExpandedAreas(Canvas canvas, childSize, offset) {
    if (expandTapRects == null ||
        kReleaseMode ||
        (kDebugMode && hideExpandedAreaInDebugMode == true)) return;

    final _theme = LeouiTheme.of(LeoFeedback.currentContext!)?.theme();

    expandTapRects!.forEach((rect) {
      Rect _expandeReact = Rect.fromLTWH(
          rect.left + offset.dx, rect.top + offset.dy, rect.width, rect.height);

      Paint paint = Paint()
        ..color = _theme?.userAccentColor.withValues(alpha: 0.2) ??
            Colors.orange.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;

      canvas.drawRect(_expandeReact, paint);
    });
  }

  void setActive({bool active = false}) {
    if (_active == active) return;
    _active = active;
    markNeedsCompositedLayerUpdate();
  }

  @override
  OffsetLayer updateCompositedLayer({required OpacityLayer? oldLayer}) {
    final OpacityLayer layer = oldLayer ?? OpacityLayer();
    layer.alpha = 153;
    return layer;
  }

  @override
  void attach(PipelineOwner owner) {
    if (onTap == null) return;
    childWidgetSize = measureWidget(ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
          minWidth: useFridendlySize ? friendlyTapSize.width : 0,
          minHeight: useFridendlySize ? friendlyTapSize.height : 0),
      child: childWidget,
    ));
    validTapRect = _getValidTapRect();
    expandTapRects = _getExpandeRects();
    detector.register(this);
    super.attach(owner);
  }

  @override
  void detach() {
    if (onTap != null) {
      detector.unregister(this);
    }
    super.detach();
  }
}
