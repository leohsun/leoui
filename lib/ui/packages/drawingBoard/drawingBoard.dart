import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}

class DrawingPayload {
  final MemoryImage image;
  final List<DrawingPoint?> drawingPoints;

  DrawingPayload(this.image, this.drawingPoints);
}

class DrawingBoard extends StatefulWidget {
  final double skokeWidth;
  final Color color;
  final bool disable;
  final List<DrawingPoint?>? drawingPoints;
  const DrawingBoard(
      {Key? key,
      this.skokeWidth = 5,
      this.color = Colors.black,
      this.disable = false,
      this.drawingPoints})
      : super(key: key);

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  late List<DrawingPoint?> _drawingPoints;

  late Size _boardSize;
  late double _stokeWidth;
  late Color _pointColor;

  @override
  void initState() {
    _stokeWidth = widget.skokeWidth;
    _pointColor = widget.color;
    _drawingPoints = widget.drawingPoints ?? [];
    super.initState();
  }

  Future<DrawingPayload?> getPayload() async {
    if (_drawingPoints.length == 0) return null;
    PictureRecorder _recorder = PictureRecorder();
    Canvas mirrorCanvas = Canvas(
        _recorder, Rect.fromLTWH(0, 0, _boardSize.width, _boardSize.height));

    for (int i = 0; i < _drawingPoints.length - 1; i++) {
      DrawingPoint? current = _drawingPoints[i];
      DrawingPoint? next = _drawingPoints[i + 1];

      if (current != null) {
        if (next != null) {
          mirrorCanvas.drawLine(current.offset, next.offset, current.paint);
        } else {
          mirrorCanvas.drawPoints(
              PointMode.points, [current.offset], current.paint);
        }
      }
    }
    Picture picture = _recorder.endRecording();

    final img = await picture.toImage(
        _boardSize.width.ceil(), _boardSize.height.ceil());
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    return DrawingPayload(MemoryImage(pngBytes), _drawingPoints);
  }

  void clear() {
    setState(() {
      _drawingPoints = [];
    });
  }

  void _addNewPoint([offset]) {
    if (widget.disable) return;
    setState(() {
      if (offset != null) {
        _drawingPoints.add(DrawingPoint(
            offset,
            Paint()
              ..strokeWidth = _stokeWidth
              ..strokeCap = StrokeCap.round
              ..color = _pointColor));
      } else {
        _drawingPoints.add(null);
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
      _boardSize = Size(constrs.maxWidth, constrs.maxHeight);
      return GestureDetector(
        onPanDown: (details) {
          _addNewPoint(details.localPosition);
        },
        onPanUpdate: (details) {
          _addNewPoint(details.localPosition);
        },
        onPanEnd: (details) {
          _addNewPoint();
        },
        child: CustomPaint(
          size: Size(constrs.maxWidth, constrs.maxHeight),
          painter: DrawingPinter(drawingPoints: _drawingPoints),
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
