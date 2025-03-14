import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/utils/animationCallback.dart';
import 'package:leoui/widget/leoui_state.dart';

extension offsetExts on Offset {
  double to(Offset other) {
    return sqrt(pow(dx - other.dx, 2) + pow(dy - other.dy, 2));
  }

  Offset middleTo(Offset other) {
    return Offset((other.dx - dx) / 2 + dx, (other.dy - dy) / 2 + dy);
  }
}

class CurrentPageShadowPaths {
  final Path aToJ;
  final Path aToC;

  CurrentPageShadowPaths({required this.aToJ, required this.aToC});
}

class VisiblePagePaths {
  final Path topLeft;
  final Path topRight;
  final Path bottomLeft;
  final Path bottomRight;

  VisiblePagePaths(
      {required this.topLeft,
      required this.topRight,
      required this.bottomLeft,
      required this.bottomRight});
}

class FlipLimitPoints {
  final Offset c;
  final Offset j;

  FlipLimitPoints({required this.c, required this.j});
}

enum FlipDirection { left, right, topLeft, topRight, bottomLeft, bottomRight }

enum SwipeDirection { ltr, rtl }

class FlipPoints {
  final Offset a;
  final Offset b;
  final Offset c;
  final Offset d;
  final Offset e;
  final Offset f;
  final Offset g;
  final Offset h;
  final Offset i;
  final Offset j;
  final Offset k;
  final Offset l;
  final Offset m;
  final Canvas viewCanvas;
  final Offset viewOffset;
  final Size viewSize;
  final Map<FlipDirection, Path> visiblePagePaths;
  final FlipDirection direction;
  final Path viewPath;
  final Path flipedPath;

  factory FlipPoints(
      {required Offset a,
      required Offset b,
      required Offset c,
      required Offset d,
      required Offset e,
      required Offset f,
      required Offset g,
      required Offset h,
      required Offset i,
      required Offset j,
      required Offset k,
      required Offset l,
      required Offset m,
      required Canvas viewCanvas,
      required Offset viewOffset,
      required Size viewSize,
      required FlipDirection direction}) {
    Path bottomRight = Path()
      ..moveTo(viewOffset.dx, viewOffset.dy)
      ..lineTo(viewOffset.dx, viewSize.height + viewOffset.dy)
      ..lineTo(c.dx, viewSize.height + viewOffset.dy)
      ..quadraticBezierTo(e.dx, e.dy, b.dx, b.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(k.dx, k.dy)
      ..quadraticBezierTo(h.dx, h.dy, j.dx, j.dy)
      ..lineTo(viewSize.width + viewOffset.dx, viewOffset.dy)
      ..close();

    Path topRight = Path()
      ..moveTo(viewOffset.dx, viewOffset.dy)
      ..lineTo(viewOffset.dx, viewSize.height + viewOffset.dy)
      ..lineTo(viewOffset.dx + viewSize.width, viewSize.height + viewOffset.dy)
      ..lineTo(j.dx, j.dy)
      ..quadraticBezierTo(h.dx, h.dy, k.dx, k.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..quadraticBezierTo(e.dx, e.dy, c.dx, c.dy)
      ..close();

    Path topLeft = Path()
      ..moveTo(j.dx, j.dy)
      ..lineTo(viewOffset.dx, viewSize.height + viewOffset.dy)
      ..lineTo(viewOffset.dx + viewSize.width, viewSize.height + viewOffset.dy)
      ..lineTo(viewOffset.dx + viewSize.width, viewOffset.dy)
      ..lineTo(c.dx, c.dy)
      ..quadraticBezierTo(e.dx, e.dy, b.dx, b.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(k.dx, k.dy)
      ..quadraticBezierTo(h.dx, h.dy, j.dx, j.dy);

    Path bottomLeft = Path()
      ..moveTo(viewOffset.dx, viewOffset.dy)
      ..lineTo(j.dx, j.dy)
      ..quadraticBezierTo(h.dx, h.dy, k.dx, k.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..quadraticBezierTo(e.dx, e.dy, c.dx, c.dy)
      ..lineTo(viewOffset.dx + viewSize.width, viewOffset.dy + viewSize.height)
      ..lineTo(viewOffset.dx + viewSize.width, viewOffset.dy)
      ..close();

    Map<FlipDirection, Path> visiblePagePaths = {
      FlipDirection.left: bottomLeft,
      FlipDirection.right: bottomRight,
      FlipDirection.topLeft: topLeft,
      FlipDirection.topRight: topRight,
      FlipDirection.bottomLeft: bottomLeft,
      FlipDirection.bottomRight: bottomRight
    };

    Path viewPath = Path()
      ..moveTo(viewOffset.dx, viewOffset.dy)
      ..lineTo(viewOffset.dx, viewOffset.dy + viewSize.height)
      ..lineTo(viewOffset.dx + viewSize.width, viewOffset.dy + viewSize.height)
      ..lineTo(viewOffset.dx + viewSize.width, viewOffset.dy)
      ..close();

    Path flipedPath = Path()
      ..moveTo(d.dx, d.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(k.dx, k.dy)
      ..lineTo(i.dx, i.dy)
      ..close();

    return FlipPoints.raw(
        a,
        b,
        c,
        d,
        e,
        f,
        g,
        h,
        i,
        j,
        k,
        l,
        m,
        viewCanvas,
        viewOffset,
        viewSize,
        visiblePagePaths,
        direction,
        viewPath,
        flipedPath);
  }

  FlipPoints.raw(
      this.a,
      this.b,
      this.c,
      this.d,
      this.e,
      this.f,
      this.g,
      this.h,
      this.i,
      this.j,
      this.k,
      this.l,
      this.m,
      this.viewCanvas,
      this.viewOffset,
      this.viewSize,
      this.visiblePagePaths,
      this.direction,
      this.viewPath,
      this.flipedPath);

  void paintEachPoint() {
    final textList = [
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m"
    ];
    [
      this.a,
      this.b,
      this.c,
      this.d,
      this.e,
      this.f,
      this.g,
      this.h,
      this.i,
      this.j,
      this.k,
      this.l,
      this.m
    ].forEachWithIndex((key, index) {
      if (key.isFinite) {
        TextPainter a = TextPainter(
            text: TextSpan(
                text: textList[index], style: TextStyle(color: Colors.red)),
            textDirection: TextDirection.ltr);
        a.layout(minWidth: 0, maxWidth: 20);
        a.paint(this.viewCanvas, key);
      }
    });
  }

  void paintNextPageCornerRect() {
    Path nextPageCorner = Path.combine(
        PathOperation.difference,
        this.viewPath,
        Path.combine(PathOperation.union,
            this.visiblePagePaths[this.direction]!, this.flipedPath));

    this.viewCanvas.drawPath(nextPageCorner, Paint()..color = Colors.blue);
  }

  void paintCurrentPageRect() {
    this.viewCanvas.drawPath(
        Path.combine(PathOperation.intersect,
            this.visiblePagePaths[this.direction]!, this.viewPath),
        Paint()
          ..color = Color(0xff75FB4C)
          ..style = PaintingStyle.fill);
  }

  Path? get currentPageClipPath {
    if (!canClip()) {
      return null;
    }
    return Path.combine(PathOperation.intersect,
        this.visiblePagePaths[this.direction]!, this.viewPath);
  }

  CurrentPageShadowPaths get currentPageShadowPaths {
    Path aToC = Path()
      ..moveTo(c.dx, c.dy)
      ..quadraticBezierTo(e.dx, e.dy, b.dx, b.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(a.dx, a.dy);
    Path aToJ = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(k.dx, k.dy)
      ..quadraticBezierTo(h.dx, h.dy, j.dx, j.dy)
      ..quadraticBezierTo(h.dx, h.dy, k.dx, k.dy);

    return CurrentPageShadowPaths(aToJ: aToJ, aToC: aToC);
  }

  double get currentPageShadowRadius => 1;

  bool canClip() {
    // print("a: $a; f: $f;");
    switch (direction) {
      case FlipDirection.bottomRight:
      case FlipDirection.topRight:
        if (a == f || a.dx == -f.dx) return false;

      case FlipDirection.right:
        if (a.dx.abs() == f.dx) {
          return false;
        }
      case FlipDirection.left:
      case FlipDirection.topLeft:
      case FlipDirection.bottomLeft:
      // do noting
    }
    return true;
  }

  Path? get nextPageClipPath {
    if (!canClip()) {
      return null;
    }
    return Path.combine(
        PathOperation.intersect,
        Path()
          ..moveTo(c.dx, c.dy)
          ..quadraticBezierTo(i.dx, i.dy, d.dx, d.dy)
          ..lineTo(i.dx, i.dy)
          ..quadraticBezierTo(m.dx, m.dy, j.dx, j.dy)
          ..lineTo(f.dx, f.dy)
          ..close(),
        this.viewPath);
  }

  Path? get flipPageClipPath {
    if (!canClip()) {
      return null;
    }
    return Path.combine(PathOperation.reverseDifference,
        this.visiblePagePaths[this.direction]!, this.flipedPath);
  }

  Path? get NextPageShadowPath {
    if (nextPageClipPath == null) return null;
    double lenght = 20;
    Path shandow = Path()
      ..moveTo(c.dx, c.dy)
      ..lineTo(j.dx, j.dy)
      ..lineTo(j.dx + lenght, j.dy + lenght)
      ..lineTo(c.dx + lenght, c.dy + lenght)
      ..close();
    return Path.combine(PathOperation.intersect, nextPageClipPath!, shandow);
  }

  void paintFlipRect() {
    this.viewCanvas.drawPath(
        Path.combine(
            PathOperation.intersect,
            Path.combine(PathOperation.reverseDifference,
                this.visiblePagePaths[this.direction]!, this.flipedPath),
            this.viewPath),
        Paint()
          ..color = Color(0xffFFFF55)
          ..style = PaintingStyle.fill);
  }
}

enum FlipViewPinnedSide { left, top, right, bottom }

enum FlipViewState { idle, flipped, scaled, flipping }

class FlipView extends MultiChildRenderObjectWidget {
  final FlipViewPinnedSide pinnedSide = FlipViewPinnedSide.left;
  const FlipView({super.children});
  @override
  RenderObject createRenderObject(BuildContext context) =>
      CreateFlipViewRender(pinnedSide: pinnedSide);
}

class FlipviewParentData extends MultiChildLayoutParentData {}

class CreateFlipViewRender extends RenderProxyBoxWithHitTestBehavior
    with
        ContainerRenderObjectMixin<RenderBox, FlipviewParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlipviewParentData> {
  final FlipViewPinnedSide pinnedSide;

  CreateFlipViewRender({super.behavior, super.child, required this.pinnedSide});

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! FlipviewParentData) {
      child.parentData = FlipviewParentData();
    }
  }

  late ScaleGestureRecognizer scaleGestureRecognizer;

  final double swipeLimit = 150; // 触发自动翻页动画的阈值
  final double swipeTiggerLimit = 100; // 触发翻页的视图内边距阈值

  int currentPage = 1;
  int? currentExpectionPage;
  List<RenderBox> children = [];
  RenderBox? get currentPageRenderBox {
    if (currentPage < 0 && currentPage > children.length - 1) return null;
    return children[currentPage];
  }

  RenderBox? get nextPageRenderBox {
    int index = currentPage + 1;
    if (index < 0 || index > children.length - 1) return null;
    return children[index];
  }

  FlipViewState state = FlipViewState.idle;

  late Offset paintOffset;
  late Canvas paintCanvas;
  late PaintingContext paintContext;

  FlipPoints? flipPoints;

  Offset? tapOffset;
  Offset? tapStartOffset;

  FlipDirection? flipDirection;
  SwipeDirection? swipeDirection;

  @override
  void attach(PipelineOwner owner) {
    scaleGestureRecognizer = ScaleGestureRecognizer()
      ..onStart = (ScaleStartDetails details) {
        int pointerCount = details.pointerCount;
        if (pointerCount == 1) {
          _handleFlipPointerDown(details.focalPoint);
        } else if (pointerCount == 2) {
          state = FlipViewState.scaled;
        }
      }
      ..onUpdate = (ScaleUpdateDetails details) {
        if (state == FlipViewState.flipped) {
          _handleFlipPointerMove(details.focalPoint);
        } else if (state == FlipViewState.scaled) {
          _handlePointerScale(details.scale);
        }
      }
      ..onEnd = (ScaleEndDetails details) {
        if (state == FlipViewState.flipped) {
          _handleFlipPointerUp();
        } else if (state == FlipViewState.scaled &&
            details.scaleVelocity == 1) {
          state == FlipViewState.idle;
        }
      };
    super.attach(owner);
  }

  void _handleFlipPointerDown(Offset global) {
    if (state != FlipViewState.idle) return;
    tapStartOffset = global;
    state = FlipViewState.flipped;
    swipeDirection = flipDirection = currentExpectionPage = null;
  }

  void _handleFlipPointerMove(Offset global) async {
    if (state == FlipViewState.flipping) return;

    tapOffset = global;
    swipeDirection ??= getSwipeDirection(global);
    flipDirection ??= getFlidDirection(global);

    print("move: $state $swipeDirection $flipDirection");

    /// flip back;
    if (swipeDirection == SwipeDirection.ltr) {
      currentExpectionPage ??= currentPage - 1;
      if (atValidPage(currentExpectionPage)) {
        currentPage = currentExpectionPage!;
      } else {
        return;
      }
    }

    if (!atValidPage() || !canFlip()) {
      print("xxxxxx: ${canFlip()}");
      return;
    }

    markNeedsPaint();
  }

  void _handleFlipPointerUp() async {
    if (state == FlipViewState.flipping || !atValidPage() || flipPoints == null)
      return resetStateParams();
    ;
    switch (flipDirection) {
      case FlipDirection.right:
      case FlipDirection.topRight:
      case FlipDirection.bottomRight:
        if (swipeDirection == SwipeDirection.rtl) {
          if (flipPoints!.a.dx < (paintOffset.dx + size.width - swipeLimit)) {
            Offset newA = flipDirection == FlipDirection.topRight
                ? Offset(-paintOffset.dx - size.width, paintOffset.dy)
                : Offset(
                    -paintOffset.dx - size.width, paintOffset.dy + size.height);
            fullFlipCurrentPage(newA);
          } else {
            annimateBack();
          }
        } else {
          // SwipeDirection.ltr
          if (flipPoints!.a.dx > (swipeLimit + paintOffset.dx)) {
            Offset newA = paintOffset +
                Offset(
                    size.width,
                    flipDirection == FlipDirection.bottomRight
                        ? size.height
                        : 0);

            fullFlipCurrentPage(newA);
          } else {
            annimateBack();
          }
        }

        break;
      case FlipDirection.left:
      case FlipDirection.topLeft:
      case FlipDirection.bottomLeft:
        if (flipPoints!.a.dx > (size.width * 1 / 2 + paintOffset.dx)) {
          fullFlipCurrentPage(Offset(
              paintOffset.dx + size.width * 2, paintOffset.dy + size.height));
        } else {
          annimateBack();
        }
        break;
      case null:
    }
  }

  void _handlePointerScale(double scale) {
    print('scale to x$scale');
    state = scale != 1 ? FlipViewState.scaled : FlipViewState.idle;
  }

  @override
  void performLayout() {
    double width = constraints.maxWidth;
    double height = 0;
    RenderBox? loopChild = firstChild;
    while (loopChild != null) {
      children.add(loopChild);
      FlipviewParentData loopParentData =
          loopChild.parentData as FlipviewParentData;
      loopChild.layout(constraints, parentUsesSize: true);
      height = max(height, loopChild.size.height);
      loopChild = loopParentData.nextSibling;
    }

    height = constraints.maxHeight == double.infinity
        ? height
        : constraints.maxHeight;

    size = Size(width, height);
  }

  SwipeDirection? getSwipeDirection(Offset moveOffset) {
    if (pinnedSide == FlipViewPinnedSide.left) {
      if (moveOffset.dx > tapStartOffset!.dx) {
        return SwipeDirection.ltr;
      } else {
        return SwipeDirection.rtl;
      }
    }
    return null;
  }

  FlipDirection getFlidDirection(Offset tapLocalOffset) {
    late FlipDirection direction;

    // if (tapLocalOffset.dx < size.width / 2) {
    //   if (tapLocalOffset.dy < size.height / 5) {
    //     direction = FlipDirection.topLeft;
    //   } else if (tapLocalOffset.dy < size.height * 4 / 5) {
    //     direction = FlipDirection.left;
    //   } else {
    //     direction = FlipDirection.bottomLeft;
    //   }
    // } else {
    if (tapLocalOffset.dy < size.height / 3) {
      direction = FlipDirection.topRight;
    } else if (tapLocalOffset.dy < size.height * 2 / 3) {
      direction = FlipDirection.right;
    } else {
      direction = FlipDirection.bottomRight;
    }
    // }

    return direction;
  }

  bool atValidPage([int? page]) {
    int exceptPage = page ?? currentPage;
    switch (swipeDirection) {
      case SwipeDirection.ltr:
        return exceptPage > -1 && exceptPage < children.length;

      case SwipeDirection.rtl:
        return exceptPage > -1 && exceptPage < children.length - 1;

      case null:
        return false;
    }
  }

  bool canFlip() {
    if (tapOffset == null || swipeDirection == null) return false;

    Offset a = tapOffset!;

    FlipLimitPoints getLimitPoints(Offset f) {
      Offset g = Offset((a.dx + f.dx) / 2, (a.dy + f.dy) / 2);

      Offset e =
          Offset(g.dx - (f.dy - g.dy) * (f.dy - g.dy) / (f.dx - g.dx), f.dy);

      Offset c = Offset(e.dx - (f.dx - e.dx) / 2, f.dy);

      Offset h =
          Offset(f.dx, g.dy - (f.dx - g.dx) * (f.dx - g.dx) / (f.dy - g.dy));
      Offset j = Offset(f.dx, h.dy - (f.dy - h.dy) / 2);

      return FlipLimitPoints(c: c, j: j);
    }

    switch (flipDirection) {
      case FlipDirection.left:
        return true;
      case FlipDirection.right:
        if (swipeDirection == SwipeDirection.rtl) {
          return tapStartOffset!.dx > size.width - swipeTiggerLimit;
        } else if (swipeDirection == SwipeDirection.ltr) {
          return tapStartOffset!.dx <= swipeTiggerLimit;
        } else {
          throw FlutterError('Incorrect swipeDirection [$swipeDirection]\n');
        }
      case FlipDirection.topLeft:
        var limits = getLimitPoints(Offset.zero);
        return a.dx > 0 &&
            a.dx < size.width &&
            a.dy > 0 &&
            limits.c.dx < size.width;

      case FlipDirection.topRight:
        var limits = getLimitPoints(Offset(size.width, 0));
        return a.dx > 0 && a.dx < size.width && a.dy > 0 && limits.c.dx > 0;
      case FlipDirection.bottomRight:
        var limits = getLimitPoints(Offset(size.width, size.height));

        bool triggerValid = false;

        if (swipeDirection == SwipeDirection.rtl) {
          triggerValid = tapStartOffset!.dx > size.width - swipeTiggerLimit;
        } else if (swipeDirection == SwipeDirection.ltr) {
          triggerValid = tapStartOffset!.dx <= swipeTiggerLimit;
        } else {
          throw FlutterError('Incorrect swipeDirection [$swipeDirection]\n');
        }

        return triggerValid &&
            a.dx > 0 &&
            a.dx < size.width &&
            a.dy < size.height &&
            limits.c.dx > 0;
      case FlipDirection.bottomLeft:
        return a.dx > 0 && a.dx < size.width && a.dy > 0 && a.dy < size.height;
      case null:
      // do nothing...
    }

    return false;
  }

  FlipPoints? getFlipPoints() {
    if (tapOffset == null || flipDirection == null) return null;

    late Offset f;

    Offset a = tapOffset! + paintOffset;

    if (flipDirection == FlipDirection.left) {
      a = Offset(tapOffset!.dx, size.height - 30) + paintOffset;
    } else if (flipDirection == FlipDirection.right) {
      a = Offset(tapOffset!.dx, size.height - 30) + paintOffset;
    }

    switch (flipDirection) {
      case FlipDirection.topLeft:
        f = paintOffset;
        break;

      case FlipDirection.topRight:
        f = Offset(size.width + paintOffset.dx, paintOffset.dy);
        break;

      case FlipDirection.right:
      case FlipDirection.bottomRight:
        f = Offset(paintOffset.dx + size.width, size.height + paintOffset.dy);
        break;

      case FlipDirection.left:
      case FlipDirection.bottomLeft:
        f = Offset(paintOffset.dx, size.height + paintOffset.dy);
        break;
      case null:
      // do nothing...
    }

    Offset g = Offset((a.dx + f.dx) / 2, (a.dy + f.dy) / 2);

    Offset e =
        Offset(g.dx - (f.dy - g.dy) * (f.dy - g.dy) / (f.dx - g.dx), f.dy);

    Offset c = Offset(e.dx - (f.dx - e.dx) / 2, f.dy);

    Offset h =
        Offset(f.dx, g.dy - (f.dx - g.dx) * (f.dx - g.dx) / (f.dy - g.dy));
    Offset j = Offset(f.dx, h.dy - (f.dy - h.dy) / 2);

    Offset b = getIntersectionPoint(a, e, c, j);
    Offset k = getIntersectionPoint(a, h, c, j);

    Offset d =
        Offset((c.dx + 2 * e.dx + b.dx) / 4, (2 * e.dy + c.dy + b.dy) / 4);
    Offset i =
        Offset((j.dx + 2 * h.dx + k.dx) / 4, (2 * h.dy + j.dy + k.dy) / 4);
    Offset l = Offset((e.dx - c.dx) / 2 + c.dx, c.dy);

    Offset m = Offset(j.dx, (j.dy - h.dy) / 2 + h.dy);

    return FlipPoints(
        a: a,
        b: b,
        c: c,
        d: d,
        e: e,
        f: f,
        g: g,
        h: h,
        i: i,
        j: j,
        k: k,
        l: l,
        m: m,
        viewCanvas: paintCanvas,
        viewOffset: paintOffset,
        viewSize: size,
        direction: flipDirection!);
  }

  Offset getIntersectionPoint(Offset a, Offset b, Offset c, Offset d) {
    double x1, y1, x2, y2, x3, y3, x4, y4;
    x1 = a.dx;
    y1 = a.dy;
    x2 = b.dx;
    y2 = b.dy;
    x3 = c.dx;
    y3 = c.dy;
    x4 = d.dx;
    y4 = d.dy;

    double pointX =
        ((x1 - x2) * (x3 * y4 - x4 * y3) - (x3 - x4) * (x1 * y2 - x2 * y1)) /
            ((x3 - x4) * (y1 - y2) - (x1 - x2) * (y3 - y4));
    double pointY =
        ((y1 - y2) * (x3 * y4 - x4 * y3) - (x1 * y2 - x2 * y1) * (y3 - y4)) /
            ((y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4));

    return Offset(pointX, pointY);
  }

  void annimateBack() async {
    Offset disOffset = flipPoints!.f - flipPoints!.a;
    state = FlipViewState.flipping;
    final Offset rawA = flipPoints!.a;

    await animationCallback(
      start: 0,
      end: 1,
      duration: Duration(milliseconds: 300),
      callback: (value) {
        tapOffset = rawA + disOffset * value - paintOffset;
        markNeedsPaint();
      },
    );
    resetStateParams();
  }

  void resetStateParams() {
    state = FlipViewState.idle;
    flipPoints = flipDirection = currentExpectionPage =
        tapOffset = tapStartOffset = swipeDirection = null;
  }

  void fullFlipCurrentPage(Offset newA) async {
    Offset disOffset = newA - flipPoints!.a;
    final Offset rawA = flipPoints!.a;
    state = FlipViewState.flipping;

    await animationCallback(
      start: 0,
      end: 1,
      duration: Duration(milliseconds: 500),
      callback: (value) {
        tapOffset = rawA + disOffset * value - paintOffset;
        if (value == 1) {
          if (swipeDirection == SwipeDirection.rtl &&
              currentPage != children.length - 1) {
            currentPage++;
          }
          // else if (swipeDirection == SwipeDirection.ltr && currentPage > 0) {
          //   // currentPage--; //minus in tapmove function
          // }
        }
        markNeedsPaint();
      },
    );
    resetStateParams();
  }

  void paintPageBackground([Color? color]) {
    paintCanvas.drawRect(
        Rect.fromLTWH(paintOffset.dx, paintOffset.dy, size.width, size.height),
        Paint()
          ..color = color ?? Color(0xffEEE2CB)
          ..style = PaintingStyle.fill);
  }

  void paintPageIndecator([int? current]) {
    TextPainter page = TextPainter(
      text: TextSpan(
          text: "${current ?? currentPage + 1}/${children.length}",
          style: TextStyle(color: Color(0xff000000))),
      textDirection: ui.TextDirection.ltr,
    );
    page.layout(maxWidth: size.width);

    page.paint(paintCanvas,
        paintOffset + Offset((size.width - page.width) / 2, size.height - 50));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    paintContext = context;
    paintCanvas = context.canvas;
    paintOffset = offset;
    flipPoints = getFlipPoints();

    // #region  paint next page
    if (flipPoints != null && flipPoints!.nextPageClipPath != null) {
      paintCanvas.save();
      paintCanvas.clipPath(flipPoints!.nextPageClipPath!);
      paintPageBackground();
      nextPageRenderBox?.paint(context, offset);
      Paint shadowPaint = Paint()
        ..shader = ui.Gradient.linear(flipPoints!.a, flipPoints!.f,
            [Colors.black45, Colors.transparent], [0.1, 0.5]);
      paintCanvas.drawPath(flipPoints!.nextPageClipPath!, shadowPaint);
      paintPageIndecator(currentPage + 2);

      paintCanvas.restore();
    } else {
      paintPageBackground();
      nextPageRenderBox?.paint(context, offset);
      paintPageIndecator(currentPage + 2);
    }
    // #endregion

    /// #region  paint visible page
    if (flipPoints != null && flipPoints!.currentPageClipPath != null) {
      paintCanvas.save();

      paintCanvas.clipPath(flipPoints!.currentPageClipPath!);
      paintPageBackground();
      currentPageRenderBox?.paint(context, offset);
      Paint linePaint = Paint()
        ..color = Colors.black87
        ..style = ui.PaintingStyle.stroke;

      paintCanvas.drawPath(flipPoints!.currentPageShadowPaths.aToJ, linePaint);
      paintCanvas.drawPath(flipPoints!.currentPageShadowPaths.aToC, linePaint);
      paintPageIndecator();
      paintCanvas.restore();
    } else {
      paintPageBackground();
      currentPageRenderBox?.paint(context, offset);
      paintPageIndecator();
    }

    /// #endregion

    // #region  paint flip page
    if (flipPoints != null && flipPoints!.flipPageClipPath != null) {
      paintCanvas.save();
      paintCanvas.clipPath(flipPoints!.flipPageClipPath!);
      paintPageBackground();
      paintCanvas.restore();
    }
    // #endregion

    // flipPoints?.paintFlipRect();

    // flipPoints?.paintNextPageCornerRect();

    // flipPoints?.paintEachPoint();
    // flipPoints.paintFlipRect(canvas, offset, flipPoints);
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      scaleGestureRecognizer.addPointer(event);
    }
    super.handleEvent(event, entry);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(position: position, result);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void detach() {
    scaleGestureRecognizer.dispose();
    super.detach();
  }
}
