import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({Key? key}) : super(key: key);

  @override
  _PromptPageState createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Prompt-简易输入框'),
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
                    ButtonGroup(children: [
                      Button(
                        'dark',
                        onTap: () async {
                          Map? resp = await showPrompt(
                              fieldKey: 'input',
                              brightness: LeouiBrightness.dark,
                              title: '请输入备注');
                          if (resp != null) {
                            showToast('备注: ${resp['input']}');
                          }
                        },
                      ),
                      Button(
                        'light',
                        color: LeoColors.warn,
                        onTap: () async {
                          Map? resp = await showPrompt(
                              fieldKey: 'input', title: '请输入备注');
                          if (resp != null) {
                            showToast('备注: ${resp['input']}');
                          }
                        },
                      )
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('其他用法同InputItem,可检验输入'),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
