import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class PopoverPage extends StatefulWidget {
  const PopoverPage({Key? key}) : super(key: key);

  @override
  _PopoverPageState createState() => _PopoverPageState();
}

class _PopoverPageState extends State<PopoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('popover-弹出框'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('1,设定为Top'),
                        subtitle: Text('当Top余量空间不足时，自动显示Bottom'),
                      ),
                      Popover(
                        transparent: true,
                        direction: popoverDirection.top,
                        menuHeight: 50,
                        child: Row(
                          children: [
                            Icon(Icons.thumb_up_alt),
                            Text('122'),
                          ],
                        ),
                        menu: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wallet_giftcard),
                              Icon(Icons.ac_unit),
                              Icon(Icons.backup),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('2,根据点击位置自动弹出'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.face_retouching_natural),
                            Text('宋肥肥')
                          ],
                        ),
                        trailing: Popover(
                          showIndicator: true,
                          transparent: true,
                          child: Container(
                            width: 20,
                            color: Colors.red,
                          ),
                          menu: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.broken_image),
                                    Text('不感兴趣')
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    height: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.face_retouching_off),
                                    Text('屏蔽作者：宋肥肥')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('3,设定为Bottom'),
                        subtitle: Text('当bottom余量空间不足时，自动显示top'),
                      ),
                      Popover(
                        transparent: true,
                        direction: popoverDirection.bottom,
                        menuHeight: 60,
                        child: Row(
                          children: [
                            Icon(Icons.thumb_up_alt),
                            Text('90000'),
                          ],
                        ),
                        menu: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wallet_giftcard),
                              Icon(Icons.ac_unit),
                              Icon(Icons.backup),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
