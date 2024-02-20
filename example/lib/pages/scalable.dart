import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/ui/packages/scalableText/scalableText.dart';

class ScalableTextPage extends StatefulWidget {
  const ScalableTextPage({Key? key}) : super(key: key);

  @override
  _ScalableTextPageState createState() => _ScalableTextPageState();
}

class _ScalableTextPageState extends State<ScalableTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScalableText-响应尺寸文本'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('基本用法'),
            subtitle: Text('不限制最小字体,此时maxLines不生效'),
          ),
          Container(
            padding: EdgeInsets.all(12),
            color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
            child: ScalableText(
              '根据一项新的研究，与减肥成败最密切相关的因素是肠道微生物群，与体重指数（BMI）无关。',
            ),
          ),
          ListTile(
            title: Text('高级'),
            subtitle: Text('限制最小字体'),
          ),
          Container(
            padding: EdgeInsets.all(12),
            color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
            child: ScalableText(
              '根据一项新的研究，与减肥成败最密切相关的因素是肠道微生物群，与体重指数（BMI）无关。',
              minFontSize: 12,
            ),
          ),
          ListTile(
            title: Text('高级'),
            subtitle: Text('限制最小字体-多行'),
          ),
          Container(
            padding: EdgeInsets.all(12),
            color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
            child: ScalableText(
              '根据一项新的研究，与减肥成败最密切相关的因素是肠道微生物群，与体重指数（BMI）无关。',
              minFontSize: 12,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
