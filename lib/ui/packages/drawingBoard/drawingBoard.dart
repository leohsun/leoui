import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}

class DrawingBoard extends StatefulWidget {
  final double skokeWidth;
  final Color color;
  const DrawingBoard({Key? key, this.skokeWidth = 5, this.color = Colors.black})
      : super(key: key);

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  List<DrawingPoint?> drawingPoints = [];

  final PictureRecorder recorder = PictureRecorder();
  late final Canvas canvasWithRecoder;
  late Size boardSize;
  late double stokeWidth;
  late Color pointColor;

  @override
  void initState() {
    stokeWidth = widget.skokeWidth;
    pointColor = widget.color;
    super.initState();
  }

  Future<MemoryImage> generateImage() async {
    PictureRecorder recorder = PictureRecorder();
    Canvas mirrorCanvas = Canvas(
        recorder, Rect.fromLTWH(0, 0, boardSize.width, boardSize.height));

    for (int i = 0; i < drawingPoints.length - 1; i++) {
      DrawingPoint? current = drawingPoints[i];
      DrawingPoint? next = drawingPoints[i + 1];

      if (current != null) {
        if (next != null) {
          mirrorCanvas.drawLine(current.offset, next.offset, current.paint);
        } else {
          mirrorCanvas.drawPoints(
              PointMode.points, [current.offset], current.paint);
        }
      }
    }
    Picture picture = recorder.endRecording();

    final img =
        await picture.toImage(boardSize.width.ceil(), boardSize.height.ceil());
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    return MemoryImage(pngBytes);
  }

  void addNewPoint([offset]) {
    setState(() {
      if (offset != null) {
        drawingPoints.add(DrawingPoint(
            offset,
            Paint()
              ..strokeWidth = stokeWidth
              ..strokeCap = StrokeCap.round
              ..color = pointColor));
      } else {
        drawingPoints.add(null);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constrs) {
      boardSize = Size(constrs.maxWidth, constrs.maxHeight);
      return GestureDetector(
        onPanDown: (details) {
          addNewPoint(details.localPosition);
        },
        onPanUpdate: (details) {
          addNewPoint(details.localPosition);
        },
        onPanEnd: (details) {
          addNewPoint();
        },
        child: CustomPaint(
          size: Size(constrs.maxWidth, constrs.maxHeight),
          painter: DrawingPinter(drawingPoints: drawingPoints),
        ),
      );
    });
  }
}

class DrawingPinter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPinter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      DrawingPoint? current = drawingPoints[i];
      DrawingPoint? next = drawingPoints[i + 1];

      if (current != null) {
        if (next != null) {
          canvas.drawLine(current.offset, next.offset, current.paint);
        } else {
          canvas.drawPoints(PointMode.points, [current.offset], current.paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
