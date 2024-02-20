import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leoui/widget/leoui_state.dart';

class DottedDivider extends StatelessWidget {
  final double? radius;
  final double? gap;
  final Color? color;
  final double? width;
  final double? height;
  final bool? vertical;
  const DottedDivider(
      {super.key,
      this.radius = 1,
      this.color,
      this.gap = 4,
      this.width,
      this.height,
      this.vertical});

  @override
  Widget build(BuildContext context) {
    Color _color = color ?? LeouiTheme.of(context)!.theme().userAccentColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        double _height = height ??
            (constraints.maxHeight.isInfinite
                ? radius! * 2
                : constraints.maxHeight);
        double _width = width ??
            (constraints.maxWidth.isInfinite
                ? radius! * 2
                : constraints.maxWidth);
        bool _vertical = vertical ?? _height > _width;
        return SizedBox(
          // color: Colors.cyanAccent,
          width: _width,
          height: _height,
          child: CustomPaint(
            painter: DotPainter(
                color: _color, gap: gap!, radius: radius!, vertical: _vertical),
          ),
        );
      },
    );
  }
}

class DotPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double gap;
  final bool vertical;

  DotPainter(
      {super.repaint,
      required this.color,
      required this.radius,
      required this.gap,
      required this.vertical});
  @override
  void paint(Canvas canvas, Size size) {
    Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 2;

    double width = size.width;
    double height = size.height;

    Offset startOffset =
        vertical ? Offset(width / 2, radius) : Offset(radius, height / 2);

    double lenght = vertical ? height : width;

    int startNum =
        ((vertical ? startOffset.dy : startOffset.dx) + radius * 2) < lenght
            ? 1
            : 0;
    if (startNum == 0) return;

    double gapToNext = radius * 2 + gap;
    int total = (lenght - radius * 2) ~/ gapToNext + startNum;

    List<Offset> dots = List.generate(total, (int index) {
      if (vertical) {
        return Offset(startOffset.dx, index * gapToNext + startOffset.dy);
      }

      return Offset(index * gapToNext + startOffset.dx, startOffset.dy);
    }, growable: true);

    canvas.drawPoints(PointMode.points, dots, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
