import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _DrawingBoardPageState createState() => _DrawingBoardPageState();
}

class _DrawingBoardPageState extends State<ColorPickerPage> {
  final GlobalKey<DrawingBoardState> drawingBoard = GlobalKey();

  Color _buttonDialogColor = Colors.blue;

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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 700),
              child: Column(
                children: [
                  ListTile(
                    title: Text('1,组件预览'),
                  ),
                  ColorPicker(
                    brightness: LeouiBrightness.dark,
                    color: Color.fromARGB(200, 255, 255, 0),
                  ),
                  ListTile(
                    title: Text('2,通过showDialog调用'),
                  ),
                  Button(
                    '选取颜色',
                    color: _buttonDialogColor,
                    onTap: () async {
                      Color _color = _buttonDialogColor;
                      await showLeoDialog(
                          closeOnClickMask: true,
                          slot: ColorPicker(
                            color: _buttonDialogColor,
                            onChange: (Color color) {
                              _color = color;
                            },
                          ),
                          layout: DialogLayout.row,
                          buttons: [
                            DialogButton(
                                text: '确定',
                                handler: (ctx) {
                                  ModalScope.of(ctx)!.closeModal();
                                })
                          ]);
                      this.setState(() {
                        _buttonDialogColor = _color;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('2,通过Popover调用'),
                  ),
                  Row(
                    children: [
                      Text('背景色'),
                      Popover.customize(
                          arrowColor:
                              LeouiThemeData(brightness: LeouiBrightness.dark)
                                  .backgroundSecondaryColor,
                          child: Container(
                            width: 80,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _buttonDialogColor,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          hideWarningToast: true,
                          customPopoverWidgetBuilder: (ctx) {
                            return Container(
                              width: 250,
                              color: LeouiThemeData(
                                      brightness: LeouiBrightness.dark)
                                  .backgroundSecondaryColor,
                              padding: EdgeInsets.all(20),
                              child: ColorPicker(
                                brightness: LeouiBrightness.dark,
                                color: _buttonDialogColor,
                                presetColors: null,
                                onChange: (color) {
                                  setState(() {
                                    _buttonDialogColor = color;
                                  });
                                  // PopoverScope.of(ctx)!.close();
                                },
                              ),
                            );
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
