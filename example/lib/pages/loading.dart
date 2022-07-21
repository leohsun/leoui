import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Loading-加载中...'),
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
                        onTap: () {
                          showLoading(
                              duration: Duration(seconds: 3), closable: false);
                        },
                      ),
                      Button(
                        'light',
                        color: LeoColors.warn,
                        onTap: () {
                          showLoading(
                              duration: Duration(seconds: 3),
                              brightness: LeouiBrightness.light);
                        },
                      )
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('title'),
                    ),
                    Button(
                      'dark',
                      full: true,
                      onTap: () {
                        showLoading(title: '正在保存...', closable: true);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('手动关闭loading'),
                      subtitle: Text('调用函数 hideLoading()'),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
