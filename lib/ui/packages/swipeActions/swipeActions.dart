import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/utils/animationCallback.dart';
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

double kFullSwipeGap = friendlyTapSize.width * 4;

class SwipeActionConfig {
  final RenderBox first;
  final List<RenderBox> children = [];
  double childrenDryWidth = 0;

  SwipeActionConfig({required this.first});

  void addChild(RenderBox child) {
    final parentData = child.parentData as SwipeActionParentData;
    children.add(child);
    childrenDryWidth += parentData.dryWidthRaw;
  }

  @override
  String toString() {
    return '''
  first: $first;
  childrenDryWidth: $childrenDryWidth;
''';
  }
}

class SwipeActions extends MultiChildRenderObjectWidget {
  final Widget child;

  ///前置动作，排序为:左->右
  final List<SwipeAction>? leadingActions;

  ///后置动作，排序为:右->左
  final List<SwipeAction>? trailingActions;

  ///允许动作菜单中的[第一项]的onTap在长距离滑动中被调用，默认[true]
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
      SwipeAction action, int idx, SwipeActionType type) {
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
      type: type,
      child: Container(
          color: action.backgroudColor ??
              defaultColors[idx % defaultColors.length],
          constraints: BoxConstraints(
              minHeight: friendlyTapSize.height,
              minWidth: friendlyTapSize.width),
          alignment: type == SwipeActionType.leading
              ? Alignment.centerRight
              : Alignment.centerLeft,
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
      return _buidActionWidget(action, index, SwipeActionType.leading);
    });

    if (leadingActionWidgets != null) {
      children.insertAll(0, leadingActionWidgets);
    }

    List<SwipeAction>? reversedTrailingAction =
        trailingActions?.reversed.toList();

    if (reversedTrailingAction != null) {
      List<Widget>? trailingActionWidgets =
          reversedTrailingAction.mapWithIndex((action, index) {
        return _buidActionWidget(action, index, SwipeActionType.trailing);
      });
      children.addAll(trailingActionWidgets);
    }

    return children;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSwipeActions(
      allowsFullSwipe: allowsFullSwipe!,
      leadingDefaultCallback: leadingActions?.first.onTap,
      trailingDefaultCallback: trailingActions?.first.onTap,
    );
  }
}

class RenderSwipeActions extends RenderProxyBoxWithHitTestBehavior
    with
        ContainerRenderObjectMixin<RenderBox, SwipeActionParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SwipeActionParentData> {
  final bool allowsFullSwipe;
  final VoidCallback? leadingDefaultCallback;
  final VoidCallback? trailingDefaultCallback;

  RenderSwipeActions({
    super.behavior,
    super.child,
    required this.allowsFullSwipe,
    this.leadingDefaultCallback,
    this.trailingDefaultCallback,
  });

  bool isMoving = false;
  bool isOnFullSwipePending = false;

  late HorizontalDragGestureRecognizer horizontalDragGestureRecognizer;

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

  SwipeActionConfig? leadingConfig;
  SwipeActionConfig? trailingConfig;

  bool leadingExpanded = false;
  bool trailingExpanded = false;

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
    isMoving = true;
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

    isMoving = true;
    await animationCallback(
      start: currentDx,
      end: end,
      duration: Duration(milliseconds: 300),
      callback: (value) {
        currentDx = value;
        markNeedsLayout();
      },
    );
    isMoving = false;

    currentDx = prevStartDx = end;
  }

  void calcActionsConfig() {
    if (hasLeading || hasTrailing) {
      return;
    }
    RenderBox? child = firstChild;

    final trailingRenderBoxList = [];

    while (child != null) {
      final parentData = child.parentData as SwipeActionParentData;
      double dryHeight = 0;
      if (child is SwipeActionRenderBox) {
        final drySize = child.getDryLayout(BoxConstraints());
        parentData.dryWidth = parentData.dryWidthRaw = drySize.width;
        if (child.type == SwipeActionType.trailing) {
          trailingActionsTotalWidth += drySize.width;
          trailingActionsTotalCount += 1;
          trailingRenderBoxList.add(child);
        } else {
          leadingActionsTotalWidth += drySize.width;
          leadingActionsTotalCount += 1;
          if (leadingConfig == null) {
            leadingConfig = SwipeActionConfig(first: child);
          } else {
            leadingConfig!.addChild(child);
          }
        }
      } else {
        child.layout(constraints, parentUsesSize: true);
        dryHeight = child.size.height;
      }

      intrinsicHeight = max(intrinsicHeight, dryHeight);

      child = parentData.nextSibling;
    }

    if (trailingConfig == null && hasTrailing) {
      trailingConfig = SwipeActionConfig(first: trailingRenderBoxList.last);
      trailingRenderBoxList.removeLast();
      trailingRenderBoxList.forEach(
        (child) {
          trailingConfig!.addChild(child);
        },
      );
    }

    assert(leadingActionsTotalWidth <= constraints.maxWidth,
        "前置动作菜单的视图渲染总宽度不能大于:${constraints.maxWidth}");
    assert(trailingActionsTotalWidth <= constraints.maxWidth,
        "后置动作菜单的视图渲染总宽度不能大于:${constraints.maxWidth}");
  }

  Future<void> animateActionDryWidth() async {
    if (!allowsFullSwipe) return;
    double expanedWidth = constraints.maxWidth - kFullSwipeGap;

    ValueChanged? callBack;

    if (currentDx > 0) {
      if (currentDx > expanedWidth) {
        if (!leadingExpanded) {
          leadingExpanded = true;
          callBack = (value) {
            final firstParentData =
                leadingConfig!.first.parentData as SwipeActionParentData;
            firstParentData.dryWidth = firstParentData.dryWidthRaw +
                leadingConfig!.childrenDryWidth * value;
            leadingConfig?.children.forEach((child) {
              final parentData = child.parentData as SwipeActionParentData;
              parentData.dryWidth =
                  parentData.dryWidthRaw - parentData.dryWidthRaw * value;
            });

            markNeedsLayout();
          };
        }
      } else if (leadingExpanded) {
        leadingExpanded = false;
        callBack = (value) {
          final firstParentData =
              leadingConfig!.first.parentData as SwipeActionParentData;
          firstParentData.dryWidth = firstParentData.dryWidthRaw +
              leadingConfig!.childrenDryWidth -
              leadingConfig!.childrenDryWidth * value;
          leadingConfig?.children.forEach((child) {
            final parentData = child.parentData as SwipeActionParentData;
            parentData.dryWidth = parentData.dryWidthRaw * value;
          });

          markNeedsLayout();
        };
      }
    } else {
      if (currentDx < -expanedWidth) {
        if (!trailingExpanded) {
          trailingExpanded = true;
          callBack = (value) {
            final firstParentData =
                trailingConfig!.first.parentData as SwipeActionParentData;
            firstParentData.dryWidth = firstParentData.dryWidthRaw +
                trailingConfig!.childrenDryWidth * value;
            trailingConfig?.children.forEach((child) {
              final parentData = child.parentData as SwipeActionParentData;
              parentData.dryWidth =
                  parentData.dryWidthRaw - parentData.dryWidthRaw * value;
            });

            markNeedsLayout();
          };
        }
      } else if (trailingExpanded) {
        trailingExpanded = false;
        callBack = (value) {
          final firstParentData =
              trailingConfig!.first.parentData as SwipeActionParentData;
          firstParentData.dryWidth = firstParentData.dryWidthRaw +
              trailingConfig!.childrenDryWidth -
              trailingConfig!.childrenDryWidth * value;
          trailingConfig?.children.forEach((child) {
            final parentData = child.parentData as SwipeActionParentData;
            parentData.dryWidth = parentData.dryWidthRaw * value;
          });

          markNeedsLayout();
        };
      }
    }

    if (callBack == null) {
      return;
    }
    if (isMoving) {
      HapticFeedback.heavyImpact();
    }
    return animationCallback(
        callback: callBack,
        start: 0,
        end: 1,
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOut);
  }

  @override
  void performLayout() {
    calcActionsConfig();

    RenderBox? child = firstChild;

    double prevDx = currentDx > 0 ? 0 : currentDx;

    double trailingMoveDxFactor =
        hasTrailing ? currentDx / trailingActionsTotalWidth : 0;
    double leadingMoveDxFactor =
        hasLeading ? currentDx / leadingActionsTotalWidth : 0;

    while (child != null) {
      final parentData = child.parentData as SwipeActionParentData;
      parentData.offset = Offset(prevDx, 0);
      if (child is SwipeActionRenderBox) {
        final factor = child.type == SwipeActionType.trailing
            ? -trailingMoveDxFactor
            : leadingMoveDxFactor;
        double clipWidth =
            (parentData.dryWidth * factor).clamp(0, double.infinity);

        parentData.clipWidth = clipWidth;

        child.layout(
            BoxConstraints(
                maxWidth: max(parentData.dryWidthRaw, clipWidth),
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
    return !isMoving &&
        !isOnFullSwipePending &&
        defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  void _handlePointerDown(DragStartDetails details) {
    startDx = details.localPosition.dx;
  }

  void _handlePointerMove(DragUpdateDetails details) async {
    isMoving = true;

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

    await animateActionDryWidth();

    markNeedsLayout();
  }

  void _handlePointerUp(DragEndDetails details) async {
    if (!isMoving) return;
    isMoving = false;

    double expanedWidth = constraints.maxWidth - kFullSwipeGap;

    FutureOr<void> Function()? onFullSwipe;
    if (currentDx > 0) {
      if (currentDx > expanedWidth && allowsFullSwipe == true) {
        destination = SwiperAnimationDestination.leadingDefaultExpand;
        onFullSwipe = leadingDefaultCallback;
      } else if (currentDx > leadingActionsTotalWidth / 2) {
        destination = SwiperAnimationDestination.leadingOpen;
      } else {
        destination = SwiperAnimationDestination.leadingClose;
      }
    } else {
      if (currentDx < -expanedWidth && allowsFullSwipe == true) {
        destination = SwiperAnimationDestination.trailingDefaultExpand;
        onFullSwipe = trailingDefaultCallback;
      } else if (currentDx < -trailingActionsTotalWidth / 2) {
        destination = SwiperAnimationDestination.trailingOpen;
      } else {
        destination = SwiperAnimationDestination.trailingClose;
      }
    }

    await animateSwiperTo(destination);

    if (onFullSwipe != null) {
      isOnFullSwipePending = true;
      await onFullSwipe();
      isOnFullSwipePending = false;
      destination = SwiperAnimationDestination.leadingClose;
      await animateSwiperTo(destination);
    }

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

  @override
  void detach() {
    horizontalDragGestureRecognizer.dispose();
    super.detach();
  }
}

class SwipeActionParentData extends MultiChildLayoutParentData {
  Offset offset = Offset.zero;

  ///acion实际宽度备份,便于[allowsFullSwipe=true]时，展开菜单第一个项的宽度，缩小其项的宽度
  double dryWidthRaw = 0;

  ///acion实际宽度
  double dryWidth = 0;

  ///Action显示宽度
  double clipWidth = 0;

  @override
  String toString() => 'offset=$offset';
}
