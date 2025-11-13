import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/config/theme.dart';
import 'package:leoui/feedback/index.dart';
import 'package:leoui/widget/global_tap_detector.dart';

const Size friendlyTapSize = Size(44, 44);

class FriendlyTapContainer extends SingleChildRenderObjectWidget {
  final VoidCallback onTap;
  final Widget child;

  /// size width and height to [friendlyTapSize]
  final bool? useFridendlySize;

  /// transparent when tapdown; default is true
  final bool? transparentWhenActive;
  final bool? hideExpandedAreaInDebugMode;

  FriendlyTapContainer(
      {super.key,
      required this.onTap,
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
  GlobalTapDetectorRenderBox? detector;

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

  bool _initialized = false;

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

    _initVariables();
  }

  _initVariables() {
    if (_initialized) return;
    validTapRect = _getValidTapRect();
    expandTapRects = _getExpandeRects();
    _initialized = true;
  }

  Rect _getValidTapRect() {
    if (size > friendlyTapSize) {
      return Rect.fromLTWH(0, 0, size.width, size.height);
    }

    double left = size.width < friendlyTapSize.width
        ? (size.width - friendlyTapSize.width) / 2
        : 0;

    double top = size.height < friendlyTapSize.height
        ? (size.height - friendlyTapSize.height) / 2
        : 0;

    double width = max(size.width, friendlyTapSize.width);

    double height = max(size.height, friendlyTapSize.height);

    return Rect.fromLTWH(left, top, width, height);
  }

  List<Rect>? _getExpandeRects() {
    if (hideExpandedAreaInDebugMode || size > friendlyTapSize) {
      return null;
    }

    if (friendlyTapSize > size) {
      return [validTapRect];
    }

    if (friendlyTapSize.width > size.width) {
      double leftForLeftRect = (size.width - friendlyTapSize.width) / 2;
      double leftForRightRect = size.width;
      double top = 0;
      double width = -leftForLeftRect;
      double height = size.height;

      return [
        Rect.fromLTWH(leftForLeftRect, top, width, height),
        Rect.fromLTWH(leftForRightRect, top, width, height)
      ];
    } else if (friendlyTapSize.height > size.height) {
      double left = 0;
      double topOfTopRect = (size.height - friendlyTapSize.height) / 2;
      double topOfbottomRect = size.height;
      double width = size.width;
      double height = (friendlyTapSize.height - size.height) / 2;

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
    detector?.register(this);
    super.attach(owner);
  }

  @override
  void detach() {
    if (onTap != null) {
      detector?.unregister(this);
    }
    super.detach();
  }
}
