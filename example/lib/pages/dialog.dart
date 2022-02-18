import 'package:flutter/material.dart' hide Dialog, showDialog;
import 'package:leoui/leoui.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({Key? key}) : super(key: key);

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Dialog-对话框'),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Alert'),
                    ),
                    ButtonGroup(
                      children: [
                        Button(
                          'dark',
                          color: LeoColors.dark,
                          onTap: () {
                            showAlert(
                                content: '您正在进行非法操作',
                                brightness: LeouiBrightness.dark);
                          },
                        ),
                        Button(
                          'light',
                          color: LeoColors.warn,
                          onTap: () {
                            showAlert(content: '您正在进行非法操作');
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('Confirm'),
                    ),
                    ButtonGroup(
                      children: [
                        Button(
                          'dark',
                          color: LeoColors.dark,
                          onTap: () {
                            showConfirm(
                                brightness: LeouiBrightness.dark,
                                onCancel: () {
                                  showToast('点击了取消');
                                },
                                onConfirm: () {
                                  showToast('点击了确定');
                                });
                          },
                        ),
                        Button(
                          'light',
                          color: LeoColors.warn,
                          onTap: () {
                            showConfirm(onCancel: () {
                              showToast('点击了取消');
                            }, onConfirm: () {
                              showToast('点击了确定');
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('内容插槽，关闭modal:'),
                      subtitle: RichText(
                        text: TextSpan(
                            text: "DialogButton(\n  handler: (",
                            style: TextStyle(
                                color: LeouiTheme.of(context).labelPrimaryColor,
                                height: 1.4),
                            children: [
                              TextSpan(
                                text: ' context ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(
                                text: ') {\n  ModalScope.of(',
                              ),
                              TextSpan(
                                text: ' context ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(
                                text: ')?.closeModal();\n  ......\n},]',
                              )
                            ]),
                      ),
                    ),
                    Button(
                      '插入内容',
                      full: true,
                      color: LeoColors.warn,
                      onTap: () {
                        showLeoDialog(
                            slot: Image.asset(
                              'assets/langzhong.jpeg',
                              fit: BoxFit.cover,
                            ),
                            title: '阆中古城',
                            content:
                                '阆（làng）中古城，是国家AAAAA级旅游景区，千年古县，中国春节文化之乡，中国四大古城之一。',
                            icon: Icons.explore,
                            brightness: LeouiBrightness.dark,
                            layout: DialogLayout.column,
                            buttons: [
                              DialogButton(
                                  text: '好的',
                                  handler: (context) {
                                    ModalScope.of(context)?.closeModal();
                                  },
                                  bold: true,
                                  icon: Icons.check_circle_outline_rounded),
                            ]);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('组件示例'),
                    ),
                    Dialog(
                      slot: Image.asset(
                        'assets/langzhong.jpeg',
                        fit: BoxFit.cover,
                      ),
                      title: '阆中古城',
                      content:
                          '阆（làng）中古城，是国家AAAAA级旅游景区，千年古县，中国春节文化之乡，中国四大古城之一。',
                      icon: Icons.explore,
                      brightness: LeouiBrightness.dark,
                      layout: DialogLayout.column,
                      buttons: [
                        DialogButton(
                            text: '订票',
                            handler: (ctx) {},
                            icon: Icons.book_online_outlined),
                        DialogButton(
                            text: '确认操作', handler: (ctx) {}, loading: true),
                        DialogButton(
                            text: '好的',
                            handler: (ctx) {},
                            icon: Icons.check_circle),
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}
