import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class TabPickerPage extends StatefulWidget {
  const TabPickerPage({Key? key}) : super(key: key);

  @override
  _TabPickerPageState createState() => _TabPickerPageState();
}

class _TabPickerPageState extends State<TabPickerPage> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('TabPicker-多频道选择器'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text('基础'),
                    ),
                    Field(
                      // color: Colors.red,
                      title: Text('地址选择'),
                      children: [
                        FieldItem(
                          title: Text('联系地址'),
                          placeholder:
                              content.isNotEmpty ? null : Text("请选择地址"),
                          content: content.isNotEmpty ? Text(content) : null,
                          arrow: true,
                          onTap: (ctx) async {
                            List<Map>? result = await showTabPicker(dataList: [
                              [
                                {
                                  "value": "pk",
                                  "label": "北京市",
                                  "children": [
                                    {"value": "hd", "label": "海淀区"},
                                    {"value": "cp", "label": "昌平区"},
                                    {"value": "cy", "label": "朝阳区"}
                                  ]
                                },
                                {
                                  "value": "sc",
                                  "label": "四川省",
                                  "children": [
                                    {
                                      "value": "cd",
                                      "label": "成都市",
                                      "children": [
                                        {"value": "gx", "label": "高新区"},
                                        {"value": "qy", "label": "青羊区"}
                                      ]
                                    },
                                    {
                                      "value": "my",
                                      "label": "绵阳市",
                                      "children": [
                                        {"value": "jn", "label": "金牛区"}
                                      ]
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
                                },
                              ]
                            ], linkage: true);
                            if (result == null) return;
                            setState(() {
                              var res = result.reduce((s, n) =>
                                  ({"label": "${s['label']}-${n['label']}"}));
                              content = res['label'];
                            });
                          },
                        )
                      ],
                    ),
                    ListTile(
                      title: Text('组件示例'),
                    ),
                    TabPicker(
                      dataList: [
                        [
                          {
                            "value": "pk",
                            "label": "北京市",
                            "children": [
                              {"value": "hd", "label": "海淀区"},
                              {"value": "cp", "label": "昌平区"},
                              {"value": "cy", "label": "朝阳区"}
                            ]
                          },
                          {
                            "value": "sc",
                            "label": "四川省",
                            "children": [
                              {
                                "value": "cd",
                                "label": "成都市",
                                "children": [
                                  {"value": "gx", "label": "高新区"},
                                  {"value": "qy", "label": "青羊区"}
                                ]
                              },
                              {
                                "value": "my",
                                "label": "绵阳市",
                                "children": [
                                  {"value": "jn", "label": "金牛区"}
                                ]
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
                          },
                        ]
                      ],
                      linkage: true,
                      onSubmit: (result) {
                        showConfirm(content: result.toString());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TabPicker(
                      dataList: [
                        [
                          {'label': '中国'},
                          {'label': '美国'},
                          {'label': '英国'},
                        ],
                        [
                          {'label': '男'},
                          {'label': '女'},
                        ],
                        [
                          {'label': '学生'},
                          {'label': '工人'},
                          {'label': '教师'},
                        ],
                      ],
                      onSubmit: (result) {
                        showConfirm(content: result.toString());
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
