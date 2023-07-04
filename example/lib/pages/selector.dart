import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class SelectorPage extends StatefulWidget {
  const SelectorPage({Key? key}) : super(key: key);

  @override
  _SelectorPageState createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Selector-选择器'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('黑色主题'),
                  ),
                  Selector(
                    columnKey: 'label',
                    onComfrim: (data) {},
                    brightness: LeouiBrightness.dark,
                    dataList: [
                      [
                        {'label': '中国中国中国中国中国中国中国中国中国中国中国中国'},
                        {'label': '美国'},
                        {'label': '英国'},
                      ],
                      [
                        {'label': '男男男男男男男男男男'},
                        {'label': '女'},
                      ],
                      [
                        {'label': '学生'},
                        {'label': '工人'},
                        {'label': '教师'},
                      ],
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('组件式'),
                  ),
                  Button(
                    '普通选择器',
                    full: true,
                    circle: true,
                    color: LeoColors.danger,
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (ctx) {
                            return Selector(
                                onComfrim: (data) {
                                  Navigator.pop(context);
                                  showConfirm(content: data.toString());
                                },
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
                                ]);
                          });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Button(
                    '级联选择器',
                    full: true,
                    circle: true,
                    color: LeoColors.warn,
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (ctx) {
                            return Selector(
                              linkage: true,
                              count: 3,
                              onComfrim: (data) {
                                Navigator.pop(context);
                                showConfirm(content: data.toString());
                              },
                              dataList: [
                                [
                                  {
                                    "label": "动物",
                                    'children': [
                                      {
                                        "label": "狗",
                                        'children': [
                                          {'label': '拉布拉多'},
                                          {'label': '哈士奇'},
                                          {'label': '藏獒'},
                                        ]
                                      },
                                      {"label": "猫"},
                                      {"label": "兔"}
                                    ]
                                  },
                                  {
                                    "label": "植物",
                                    'children': [
                                      {
                                        "label": "树",
                                        'children': [
                                          {'label': '苹果树'}
                                        ]
                                      },
                                      {"label": "草"},
                                    ]
                                  },
                                  {"label": '没有下级'}
                                ],
                              ],
                            );
                          });
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('函数式'),
                  ),
                  Button(
                    '函数式调用',
                    onTap: () async {
                      var result = await showSelector(dataList: [
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
                      ]);

                      print('result-->$result');
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
