import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/index.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f4f5),
      appBar: AppBar(
        title: Text('LEOUI'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Button('modal', full: true, onTap: () async {
                showMessage('haha', type: MessageType.error);
              }),
              SizedBox(
                height: 20,
              ),
              Collapse(title: 'Basic - 基础', childern: [
                ListTile(
                  title: Text('Button - 按钮'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.of(context).pushNamed('button');
                  },
                ),
                Container(height: 1, color: Colors.grey.shade100),
                ListTile(
                  title: Text('Skeleton - 骨架屏'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.of(context).pushNamed('skeleton');
                  },
                ),
                Container(height: 1, color: Colors.grey.shade100),
                ListTile(
                  title: Text('NoticeBar - 通知栏'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.of(context).pushNamed('noticeBar');
                  },
                ),
                Container(height: 1, color: Colors.grey.shade100),
                ListTile(
                  title: Text('ScalableText - 响应尺寸文字'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.of(context).pushNamed('scalableText');
                  },
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Collapse(
                  title: 'Form - 表单',
                  leadingColor: Colors.green.shade400,
                  childern: [
                    ListTile(
                      title: Text('Field - 区域列表组合'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('field');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('InputItem - 输入框'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('inputItem');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                  ]),
              SizedBox(
                height: 20,
              ),
              Collapse(
                  title: 'Feedback - 反馈',
                  leadingColor: Colors.orange.shade400,
                  childern: [
                    ListTile(
                      title: Text('Selector - 选择器'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('selector');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('TabPiker - 多频道选择器'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('tabPicker');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('Message - 消息'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('message');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('Toast - 轻提示'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('toast');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('Modal - 模态框'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('modal');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('Loading - 加载中'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('loading');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('Dialog - 对话框'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('dialog');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                    ListTile(
                      title: Text('Popover - 弹出框'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('popover');
                      },
                    ),
                  ]),
              SizedBox(
                height: 20,
              ),
              Collapse(
                  title: 'Other - 其他',
                  leadingColor: Colors.red.shade400,
                  childern: [
                    ListTile(
                      title: Text('Utils - 工具'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.of(context).pushNamed('utils');
                      },
                    ),
                    Container(height: 1, color: Colors.grey.shade100),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
