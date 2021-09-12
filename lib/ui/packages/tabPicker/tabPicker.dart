import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leoui/config/size.dart';
import 'package:leoui/config/theme.dart';
import 'package:leoui/utils/index.dart';
import 'package:leoui/utils/size.dart';

class TabPicker extends StatefulWidget {
  final List dataList;
  final String columnKey;
  final String childrenKey;
  final LeouiBrightness? brightness;
  final bool linkage;
  final double selectorHeight;

  TabPicker(
      {Key? key,
      this.columnKey = 'label',
      this.childrenKey = 'options',
      this.brightness = LeouiBrightness.light,
      this.linkage = false,
      double? selectorHeight,
      this.dataList = const [
        {
          "value": "pk",
          "label": "北京市",
          "children": {
            "name": "block",
            "label": "请选择",
            "options": [
              {"value": "hd", "label": "海淀区"},
              {"value": "cp", "label": "昌平区"},
              {"value": "cy", "label": "朝阳区"}
            ]
          }
        },
        {
          "value": "sc",
          "label": "四川省",
          "children": {
            "name": "city",
            "label": "请选择",
            "options": [
              {
                "value": "cd",
                "label": "成都市",
                "children": {
                  "name": "block",
                  "label": "请选择",
                  "options": [
                    {"value": "gx", "label": "高新区"},
                    {"value": "qy", "label": "青羊区"}
                  ]
                }
              },
              {
                "value": "my",
                "label": "绵阳市",
                "children": {
                  "name": "block",
                  "label": "请选择",
                  "options": [
                    {"value": "jn", "label": "金牛区"}
                  ]
                }
              },
              {"value": "lz", "label": "泸州市"},
              {"value": "dy", "label": "德阳市"},
              {"value": "ms", "label": "眉山市"},
              {"value": "ls", "label": "乐山市"},
              {"value": "yb", "label": "宜宾市"},
              {"value": "ya", "label": "雅安市"},
              {"value": "zg", "label": "自贡市"},
              {"value": "pzh", "label": "攀枝花市"},
              {"value": "sn", "label": "遂宁市"},
              {"value": "nc", "label": "南充市"},
              {"value": "nj", "label": "内江市"},
              {"value": "dz", "label": "达州市"},
              {"value": "ga", "label": "广安市"}
            ]
          }
        }
      ]})
      : selectorHeight = selectorHeight ?? sz(LeoSize.itemExtent * 5),
        super(key: key);

  @override
  _TabPickerState createState() => _TabPickerState();
}

class _TabPickerState extends State<TabPicker> {
  List selectedDataList = [{}];

  void _handleSelectChange(cellIdx) {
    print(cellIdx);
  }

  List columnData = [{}];

  @override
  void initState() {
    columnData = widget.dataList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LeoThemeData theme = widget.brightness != null
        ? LeoThemeData(brightness: widget.brightness)
        : LeoTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundPrimaryColor,
        borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
      ),
      child: DefaultTabController(
          length: selectedDataList.length == 0 ? 1 : selectedDataList.length,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: SizeTool.deviceWidth,
                child: TabBar(
                    labelColor: theme.userAccentColor,
                    indicatorColor: theme.userAccentColor,
                    isScrollable: true,
                    tabs: [
                      Container(
                        height: sz(LeoSize.itemExtent),
                        child: Center(
                          child: Text(
                            '请选择',
                            style:
                                TextStyle(fontSize: sz(LeoSize.fontSize.title)),
                          ),
                        ),
                      )
                    ]),
              ),
              Container(
                height: widget.selectorHeight,
                child: TabBarView(
                  children: [
                    CustomScrollView(
                      slivers: [
                        ...columnData.map(
                          (data) => SliverToBoxAdapter(
                            child: buildButtonWidget(
                              onPress: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: theme.fillPrimaryColor))),
                                height: sz(LeoSize.itemExtent),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    data[widget.columnKey] ?? 'text',
                                    style: TextStyle(
                                        fontSize: sz(LeoSize.fontSize.content),
                                        color: theme.labelPrimaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
