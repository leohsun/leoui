import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class ToastPage extends StatefulWidget {
  const ToastPage({Key? key}) : super(key: key);

  @override
  _ToastPageState createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Toast-轻提示'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text('主题'),
                  ),
                  ButtonGroup(
                    children: [
                      Button('dark', onTap: () {
                        showToast('轻提示', brightness: LeouiBrightness.dark);
                      }),
                      Button('light', color: LeoColors.warn, onTap: () {
                        showToast('轻提示', brightness: LeouiBrightness.light);
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text('成功'),
                  ),
                  Button('成功', color: LeoColors.success, onTap: () {
                    showToast(null, type: ToastType.success);
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text('失败'),
                  ),
                  Button('失败', color: LeoColors.danger, onTap: () {
                    showToast(null, type: ToastType.error);
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text('长文字'),
                  ),
                  Button('长文字', color: LeoColors.warn, full: true, onTap: () {
                    showToast(
                      '长文字的请用\'showMessage(...)\'，长文字的请用\'showMessage(...)\'，长文字的请用\'showMessage(...)\'，长文字的请用\'showMessage(...)\'',
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
