import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class NoticeBarPage extends StatelessWidget {
  const NoticeBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text('NoticeBar-通知栏'),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: SizeTool.devicePadding.bottom),
            child: Column(
              children: [
                ListTile(
                  title: Text('基础'),
                ),
                NoticeBar(
                  content: '为了确保您的资金安全，请设置支付密码。',
                ),
                ListTile(
                  title: Text('设置图标'),
                ),
                NoticeBar(
                  content: '为了确保您的资金安全，请设置支付密码。',
                  icon: Icon(
                    Icons.shield,
                  ),
                  scrollable: false,
                  closable: true,
                ),
                ListTile(
                  title: Text('圆角'),
                ),
                NoticeBar(
                  content: '为了确保您的资金安全，请设置支付密码。',
                  icon: Icon(
                    Icons.shield,
                  ),
                  scrollable: false,
                  round: true,
                  closable: true,
                ),
                ListTile(
                  title: Text('样式'),
                ),
                NoticeBar(
                  content: '为了确保您的资金安全，请设置支付密码。',
                  icon: Icon(
                    Icons.shield,
                  ),
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
                NoticeBar(
                    content: '为了确保您的资金安全，请设置支付密码。',
                    icon: Icon(
                      Icons.shield,
                    ),
                    color: Colors.orange),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text('事件'),
                ),
                NoticeBar(
                    content: '为了确保您的资金安全，请设置支付密码。',
                    icon: Icon(
                      Icons.shield,
                    ),
                    closable: true,
                    onClose: () {
                      showToast('关闭了');
                    },
                    onTap: () {
                      showToast('点击了notice bar');
                    },
                    color: Colors.orange),
                ListTile(
                  title: Text('多行显示'),
                ),
                NoticeBar(
                  content:
                      '为了确保您的资金安全，请设置支付密码。为了确保您的资金安全，请设置支付密码。为了确保您的资金安全，请设置支付密码。为了确保您的资金安全，请设置支付密码。',
                  icon: Icon(
                    Icons.shield,
                  ),
                  color: Colors.red,
                  round: true,
                  link: true,
                ),
                ListTile(
                  title: Text('滚动播放'),
                ),
                NoticeBar(
                  content:
                      '为了确保您的资金安全，请设置支付密码。为了确保您的资金安全，请设置支付密码。为了确保您的资金安全，请设置支付密码。为了确保您的资金安全，请设置支付密码。',
                  icon: Icon(
                    Icons.alarm,
                  ),
                  color: Colors.red,
                  scrollable: true,
                  closable: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
