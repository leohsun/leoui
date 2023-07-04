import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class DrawingBoardPage extends StatefulWidget {
  const DrawingBoardPage({Key? key}) : super(key: key);

  @override
  _DrawingBoardPageState createState() => _DrawingBoardPageState();
}

class _DrawingBoardPageState extends State<DrawingBoardPage> {
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
        title: Text('DarwingBoard-画板'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: DrawingBoard(
            key: drawingBoard,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        onPressed: () async {
          DrawingPayload? drawingPayload =
              await drawingBoard.currentState!.getPayload();

          if (drawingPayload != null) {
            showLeoDialog(slot: Image(image: drawingPayload.image));
          }
        },
      ),
    );
  }
}
