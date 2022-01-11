import 'dart:math';

import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({Key? key}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('Color'), ColorWheel()],
    );
  }
}

class ColorWheel extends StatefulWidget {
  final Color? color;
  final ValueChanged<Color>? onColorChange;
  const ColorWheel({Key? key, this.color = Colors.white, this.onColorChange})
      : super(key: key);

  @override
  _ColorWheelState createState() => _ColorWheelState();
}

class _ColorWheelState extends State<ColorWheel> {
  Color choosenColor = Colors.orange;
  double radius = 100;
  double markerWidth = 30;

  late Offset markerPosition;
  @override
  void initState() {
    markerPosition = Offset(radius - markerWidth / 2, radius - markerWidth / 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapDown: (details) {
            print(details.localPosition);
            double dx = details.localPosition.dx - markerWidth / 2;
            double dy = details.localPosition.dy - markerWidth / 2;
            setState(() {
              markerPosition = Offset(dx, dy);
            });
          },
          child: Padding(
            padding: EdgeInsets.all(markerWidth / 2),
            child: CustomPaint(
              size: Size(radius * 2, radius * 2),
              painter: ColorWheelPainter(),
            ),
          ),
        ),
        Container(
          height: markerWidth,
          width: markerWidth,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Color(0xff8e8e8e))),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            height: markerWidth,
            width: markerWidth,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Color(0xff8e8e8e))),
          ),
        ),
        Positioned(
            left: markerPosition.dx,
            top: markerPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                print(details.localPosition);
              },
              child: Container(
                height: markerWidth,
                width: markerWidth,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: choosenColor,
                    border: Border.all(color: Color(0xffffffff))),
              ),
            ))
      ],
    );
  }
}

class ColorWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double totalRadius = size.width / 2;
    //hls
    for (double h = 0; h < 360; h++) {
      for (double s = 0; s < totalRadius; s++) {
        double lightness =
            double.parse((1 - s / totalRadius * .5).toStringAsFixed(2));
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color =
              HSLColor.fromAHSL(1, h, s / totalRadius, lightness).toColor();
        // 360 <==> 2pi
        double startAngel = h * pi / 180;
        double width = size.width / totalRadius * s;
        canvas.drawArc(
            Rect.fromCenter(center: center, width: width, height: width),
            startAngel,
            pi / 90,
            false,
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
