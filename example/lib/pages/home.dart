import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('LEOUI'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
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
              Container(height: 1, color: Colors.grey.shade100),
              ListTile(
                title: Text('StickyContainer - 粘性定位'),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Navigator.of(context).pushNamed('stickyContianer');
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
                  ListTile(
                    title: Text('SearchBar - 搜索栏'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('searchBar');
                    },
                  ),
                ]),
            SizedBox(
              height: 20,
            ),
            Collapse(
                title: 'Navigation - 导航',
                leadingColor: Colors.purple.shade400,
                childern: [
                  ListTile(
                    title: Text('Indexes - 索引选择器'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('indexes');
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
                    title: Text('SwipeActions - 滑动菜单'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('swipeActions');
                    },
                  ),
                  Container(height: 1, color: Colors.grey.shade100),
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
                    title: Text('Prompt - 输入框'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('prompt');
                    },
                  ),
                  Container(height: 1, color: Colors.grey.shade100),
                  ListTile(
                    title: Text('Popover - 气泡弹出框'),
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
                  ListTile(
                    title: Text('DrawingBoard - 画板'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('drawingBoard');
                    },
                  ),
                  Container(height: 1, color: Colors.grey.shade100),
                  ListTile(
                    title: Text('ColorPicker - 颜色拾取器'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('colorPicker');
                    },
                  ),
                  ListTile(
                    title: Text('TextEditor - 文本编辑器'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('textEditor');
                    },
                  ),
                ]),
          ]),
        ),
      ),
      // body: ListView.builder(
      //   itemCount: 5,
      //   itemBuilder: (context, index) => Container(
      //       height: 30,
      //       child: ListTile(
      //         title: Text('$index'),
      //       )),
      // ),
    );
  }
}
