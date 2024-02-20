import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/utils/tickerCallback.dart';
import 'package:leoui/widget/FriendlyTapContainer.dart';

part './actions.dart';

enum SwiperAnimationDestination {
  leadingClose,
  leadingOpen,
  leadingDefaultExpand,
  trailingClose,
  trailingOpen,
  trailingDefaultExpand
}

class SwipeActions extends MultiChildRenderObjectWidget {
  final Widget child;

  ///前置动作，排序为:左->右
  final List<SwipeAction>? leadingActions;

  ///后置动作，排序为:右->左
  final List<SwipeAction>? trailingActions;

  ///允许第一个动作在长距离滑动中被调用，默认[true]
  final bool? allowsFullSwipe;

  SwipeActions(
      {super.key,
      this.leadingActions,
      this.trailingActions,
      this.allowsFullSwipe = true,
      required this.child})
      : assert(leadingActions != null || trailingActions != null),
        super(children: _buildChildren(leadingActions, child, trailingActions));

  static List<Color> defaultColors = [
    Color(0xff990000),
    Color(0xff6897bb),
    Color(0xffdaa520),
    Color(0xff0e2f44),
    Color(0xff666600),
    Color(0xff006666),
    Color(0xffb300b3),
    Color(0xff330066),
    Color(0xff510051),
    Color(0xff751975),
  ];

  static Widget _buidActionWidget(
      SwipeAction action, int idx, SwipeDirection direction) {
    LeouiThemeData theme = LeouiTheme.of(LeoFeedback.currentContext!)!.theme();
    TextStyle style = action.textStyle ??
        TextStyle(
            color: Color(0xffffffff), height: 1, fontSize: theme.size!().title);
    final child = action.child ??
        Text(
          '  ${action.text}  ',
          strutStyle: StrutStyle(
            leading: 0,
          ),
          maxLines: 1,
          style: style,
        );
    return ClipAction(
      onTap: action.onTap,
      direction: direction,
      child: Container(
          color: action.backgroudColor ??
              defaultColors[idx % defaultColors.length],
          constraints: BoxConstraints(
              minHeight: friendlyTapSize.height,
              minWidth: friendlyTapSize.width),
          alignment: direction == SwipeDirection.ltr
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: child),
    );
  }

  static List<Widget> _buildChildren(
    List<SwipeAction>? leadingActions,
    Widget child,
    List<SwipeAction>? trailingActions,
  ) {
    List<Widget> children = [
      ConstrainedBox(
          constraints: BoxConstraints(minHeight: friendlyTapSize.height),
          child: child)
    ];

    List<Widget>? leadingActionWidgets =
        leadingActions?.mapWithIndex((action, index) {
      return _buidActionWidget(action, index, SwipeDirection.ltr);
    });

    if (leadingActionWidgets != null) {
      children.insertAll(0, leadingActionWidgets);
    }

    List<SwipeAction>? reversedTrailingAction =
        trailingActions?.reversed.toList();

    if (reversedTrailingAction != null) {
      List<Widget>? trailingActionWidgets =
          reversedTrailingAction.mapWithIndex((action, index) {
        return _buidActionWidget(action, index, SwipeDirection.rtl);
      });
      children.addAll(trailingActionWidgets);
    }

    return children;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSwipeActions();
  }
}

class RenderSwipeActions extends RenderProxyBoxWithHitTestBehavior
    with
        ContainerRenderObjectMixin<RenderBox, SwipeActionParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SwipeActionParentData> {
  bool isMoving = false;
  bool isAnimation = false;

  late HorizontalDragGestureRecognizer horizontalDragGestureRecognizer;

  Offset origin = Offset.zero;

  SwiperAnimationDestination destination =
      SwiperAnimationDestination.leadingClose;

  double startDx = 0;
  double startDy = 0;

  double movingDx = 0;
  double prevStartDx = 0;
  double currentDx = 0;

  double leadingActionsTotalCount = 0;
  double leadingActionsTotalWidth = 0;

  double trailingActionsTotalCount = 0;
  double trailingActionsTotalWidth = 0;

  double intrinsicHeight = 0;

  ParentData swipeActionParentData = SwipeActionParentData();

  bool get movingToLeft => movingDx < 0;
  bool get movingToRight => movingDx > 0;
  bool get hasLeading => leadingActionsTotalCount > 0;
  bool get hasTrailing => trailingActionsTotalCount > 0;

  @override
  void attach(PipelineOwner owner) {
    horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..onStart = _handlePointerDown
      ..onUpdate = _handlePointerMove
      ..onEnd = _handlePointerUp;
    super.attach(owner);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    child.parentData = SwipeActionParentData();
  }

  Future<void> animateSwiperTo(SwiperAnimationDestination destination) async {
    isAnimation = true;
    late double end;

    switch (destination) {
      case SwiperAnimationDestination.trailingClose:
      case SwiperAnimationDestination.leadingClose:
        end = 0;
      case SwiperAnimationDestination.leadingOpen:
        end = leadingActionsTotalWidth;
      case SwiperAnimationDestination.leadingDefaultExpand:
        end = constraints.maxWidth;
      case SwiperAnimationDestination.trailingOpen:
        end = -trailingActionsTotalWidth;
      case SwiperAnimationDestination.trailingDefaultExpand:
        end = -constraints.maxWidth;
    }

    isAnimation = true;
    await animationCallback(
      start: currentDx,
      end: end,
      duration: Duration(milliseconds: 300),
      callback: (value) {
        currentDx = value;
        markNeedsLayout();
      },
    );
    isAnimation = false;

    currentDx = prevStartDx = end;
  }

  void calcActionsConfig() {
    if (trailingActionsTotalWidth != 0 || leadingActionsTotalWidth != 0) {
      return;
    }
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as SwipeActionParentData;

      double dryHeight = 0;
      if (child is SwipeActionRenderBox) {
        final drySize = child.getDryLayout(BoxConstraints());
        parentData.dryWidth = drySize.width;
        if (child.direction == SwipeDirection.rtl) {
          trailingActionsTotalWidth += drySize.width;
          trailingActionsTotalCount += 1;
        } else {
          leadingActionsTotalWidth += drySize.width;
          leadingActionsTotalCount += 1;
        }
      } else {
        child.layout(constraints, parentUsesSize: true);
        dryHeight = child.size.height;
      }

      intrinsicHeight = max(intrinsicHeight, dryHeight);

      child = parentData.nextSibling;
    }

    assert(leadingActionsTotalWidth <= constraints.maxWidth,
        "前置动作的视图渲染总宽度不能大于:${constraints.maxWidth}");
    assert(trailingActionsTotalWidth <= constraints.maxWidth,
        "后置动作的视图渲染总宽度不能大于:${constraints.maxWidth}");
  }

  @override
  void performLayout() {
    calcActionsConfig();

    RenderBox? child = firstChild;

    double prevDx = currentDx > 0 ? 0 : currentDx;

    double trailingMoveDxFactor = trailingActionsTotalWidth == 0
        ? 0
        : currentDx / trailingActionsTotalWidth;
    double leadingMoveDxFactor = leadingActionsTotalCount == 0
        ? 0
        : currentDx / leadingActionsTotalWidth;

    while (child != null) {
      final parentData = child.parentData as SwipeActionParentData;
      parentData.offset = Offset(prevDx, 0);
      if (child is SwipeActionRenderBox) {
        final factor = child.direction == SwipeDirection.rtl
            ? -trailingMoveDxFactor
            : leadingMoveDxFactor;
        double clipWidth =
            (parentData.dryWidth * factor).clamp(0, double.infinity);

        parentData.clipWidth = clipWidth;

        child.layout(
            BoxConstraints(
                maxWidth: max(parentData.dryWidth, clipWidth),
                maxHeight: intrinsicHeight),
            parentUsesSize: true);
        prevDx += clipWidth;
      } else {
        child.layout(constraints, parentUsesSize: true);
        prevDx += child.size.width;
      }

      child = parentData.nextSibling;
    }

    size = Size(constraints.maxWidth, intrinsicHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  void _handlePointerDown(DragStartDetails details) {
    startDx = details.localPosition.dx;
  }

  void _handlePointerMove(DragUpdateDetails details) {
    if (isAnimation) {
      return;
    }

    movingDx = details.localPosition.dx - startDx;
    currentDx = movingDx + prevStartDx;
    bool needUpdate = true;
    if ((!hasTrailing && currentDx <= 0) || (!hasLeading && currentDx >= 0)) {
      currentDx = 0;
      needUpdate = false;
    }

    if (!needUpdate) {
      return;
    }

    isMoving = true;
    markNeedsLayout();
  }

  void _handlePointerUp(DragEndDetails details) async {
    if (!isMoving || isAnimation) return;

    SwiperAnimationDestination? destination =
        SwiperAnimationDestination.trailingClose;

    if (movingToLeft && currentDx < -trailingActionsTotalWidth / 2) {
      //handle trailing actions
      if (currentDx < -constraints.maxWidth / 2) {
        destination = SwiperAnimationDestination.trailingDefaultExpand;
      } else {
        destination = SwiperAnimationDestination.trailingOpen;
      }
    } else {
      /// handle leading acitons
      if (currentDx > leadingActionsTotalWidth / 2) {
        if (currentDx > constraints.maxWidth / 2) {
          destination = SwiperAnimationDestination.leadingDefaultExpand;
        } else {
          destination = SwiperAnimationDestination.leadingOpen;
        }
      }
    }
    await animateSwiperTo(destination);
    resetChildConfig();
  }

  void resetChildConfig() {
    RenderBox? child = firstChild;

    while (child != null) {
      final parentData = child.parentData as SwipeActionParentData;
      parentData.clipWidth = 0;

      if (child is SwipeActionRenderBox) {
        parentData.clipWidth = parentData.clipWidth < parentData.dryWidth
            ? 0
            : parentData.dryWidth;
      }

      child = parentData.nextSibling;
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      horizontalDragGestureRecognizer.addPointer(event);
    }
    super.handleEvent(event, entry);
  }
}

class SwipeActionParentData extends MultiChildLayoutParentData {
  Offset offset = Offset.zero;
  Offset origin = Offset.zero;

  ///acion实际宽度
  double dryWidth = 0;

  ///Action显示宽度
  double clipWidth = 0;

  @override
  String toString() => 'offset=$offset';
}
