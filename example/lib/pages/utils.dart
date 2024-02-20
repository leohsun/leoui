import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/ui/packages/scalableText/scalableText.dart';
import 'package:leoui/utils/index.dart';

class UtilsPage extends StatefulWidget {
  const UtilsPage({Key? key}) : super(key: key);

  @override
  _UtilsPageState createState() => _UtilsPageState();
}

class _UtilsPageState extends State<UtilsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utils-工具'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('1、Color hex(String color);'),
              subtitle: Text('处理hex格式color值'),
            ),
            Container(
              padding: EdgeInsets.all(12),
              width: SizeTool.deviceWidth,
              color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
              child: Text('hex(#f2f2f2)'),
            ),
            ListTile(
              title: Text(
                '2、List mapWithIndex(List data,\n MapWithIndexCallBack cb)',
                maxLines: 2,
              ),
              subtitle: Text('map方法，可同时返回item及index'),
            ),
            Container(
              padding: EdgeInsets.all(12),
              width: SizeTool.deviceWidth,
              color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
              child: ScalableText(
                ' children: [\n  ...mapWithIndex(columnDataList, (e, idx) {\n  return _buildTabViewChild(e, idx, theme);\n  })\n],',
                maxLines: 5,
                minFontSize: 10,
              ),
            ),
            ListTile(
              title: Text('3、SizeTool()'),
              subtitle: Text('尺寸工具：\n可根据设计图缩放尺寸、获取设备尺寸'),
            ),
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 20),
              width: SizeTool.deviceWidth,
              color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
              child: ScalableText(
                'double sz(double design) =>\n  SizeTool(designWidth: 375,designHeight: 800)\n.sizeWidth(design);',
                minFontSize: 12,
                maxLines: 3,
              ),
            ),
            Container(
                padding: EdgeInsets.all(12),
                width: SizeTool.deviceWidth,
                color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScalableText(
                      'Size _deviceSize = SizeTool.deviceSize',
                    ),
                    ScalableText(
                      'dobule _deviceWidth = SizeTool.deviceWidth',
                    ),
                    ScalableText(
                      'dobule _deviceHeight = SizeTool.deviceHeight',
                    ),
                    ScalableText(
                      'EdgeInsets _devicePadding = SizeTool.devicePadding',
                    ),
                  ],
                )),
            ListTile(
              title: Text('4、NumberPrecision()'),
              subtitle: Text('处理数字运算精度问题'),
            ),
            Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 20),
                width: SizeTool.deviceWidth,
                color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScalableText(
                      'dobule res = NumberPrecision.plus([0.01,0.1])',
                    ),
                    ScalableText(
                      'dobule res = NumberPrecision.minus([0.01,0.1])',
                    ),
                    ScalableText(
                      'dobule res = NumberPrecision.times([0.01,0.1])',
                    ),
                    ScalableText(
                      'dobule res = NumberPrecision.divide([0.01,0.1])',
                    ),
                  ],
                )),
            ListTile(
              title: Text(
                  '5、darken(Colors.red, 50) \n      lighten(Colors.red, 50)'),
              subtitle: Text('处理颜色'),
            ),
            Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 20),
                width: SizeTool.deviceWidth,
                color: LeouiTheme.of(context)!.theme().fillTertiaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text('红色-加深50%'),
                          color: darken(Colors.red, 50),
                          width: 100,
                          height: 50,
                        ),
                        Container(
                          child: Text('红色'),
                          color: Colors.red,
                          width: 100,
                          height: 50,
                        ),
                        Container(
                          child: Text('红色-减轻50%'),
                          color: lighten(Colors.red, 50),
                          width: 100,
                          height: 50,
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
