import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _DrawingBoardPageState createState() => _DrawingBoardPageState();
}

class _DrawingBoardPageState extends State<ColorPickerPage> {
  final GlobalKey<DrawingBoardState> drawingBoard = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text('ColorPicker-颜色拾取器'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ColorPicker(),
        ),
      ),
    );
  }
}
