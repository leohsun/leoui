import 'package:flutter/material.dart' hide Dialog, showDialog;
import 'package:leoui/leoui.dart';

class FieldPage extends StatefulWidget {
  const FieldPage({Key? key}) : super(key: key);

  @override
  _FieldPageState createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Field-区域列表组合'),
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
                      title: Text('基础'),
                    ),
                    Field(
                      // plain: true,
                      title: Row(
                        children: [Text('区域标题'), Icon(Icons.title)],
                      ),
                      brief: Row(
                        children: [Text('区域描述性文本'), Icon(Icons.content_paste)],
                      ),
                      trailing: Row(
                        children: [Text('操作'), Icon(Icons.arrow_right_rounded)],
                      ),
                      children: [
                        FieldItem(
                            title: Text('标题区域'),
                            content: Text('内容文本'),
                            // placeholder: '提示文本',
                            addon: Text(
                              '选择',
                              textAlign: TextAlign.right,
                            ),
                            arrow: true,
                            child: Text(
                              '这是child区域',
                            ),
                            onTap: (ctx) {
                              showToast('点击了');
                            }),
                        FieldItem(
                            title: Text('标题区域'),
                            content: Text('内容文本禁用状态'),
                            disabled: true,
                            addon: Text(
                              '选择',
                              textAlign: TextAlign.right,
                            ),
                            arrow: true,
                            onTap: (ctx) {
                              showToast('点击了');
                            }),
                        FieldItem(
                            title: Text('标题区域'),
                            placeholder: Text('提示文本'),
                            addon: Text(
                              '次要文字',
                              textAlign: TextAlign.right,
                            ),
                            onTap: (ctx) {}),
                      ],
                      footer: Text('区域页脚区域内容'),
                    )
                  ]),
            ),
          ),
        ));
  }
}
