import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class ModalPage extends StatefulWidget {
  const ModalPage({Key? key}) : super(key: key);

  @override
  _ModalPageState createState() => _ModalPageState();
}

class _ModalPageState extends State<ModalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Modal-模态框'),
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
                        title: Text('1、在child里需要关闭Modal，可以调用:'),
                        subtitle: Text(
                            'ModalScope.of(context)?.closeModal(payload);'),
                      ),
                      ListTile(
                        title: Text('2、[payload]参数传递， 可通过:'),
                        subtitle:
                            Text('\'var result = await showModal(...)\'来接收'),
                      ),
                      ListTile(
                        title: Text(
                            '3、[tragToClose:true]拖动关闭，\n不适用与[ModalDirection.center]'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Button('中', full: true, onTap: () {
                        showModal(
                          modal: Modal(
                            closeOnClickMask: true,
                            childBuilder: (c) => Container(
                              height: SizeTool.deviceWidth / 2,
                              width: SizeTool.deviceWidth - 20,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'from center',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Button('左', full: true, onTap: () {
                        showModal(
                          modal: Modal(
                            closeOnClickMask: true,
                            dragToClose: true,
                            direction: ModalDirection.left,
                            childBuilder: (c) => Container(
                              color: Colors.white,
                              height: SizeTool.deviceHeight,
                              width: SizeTool.deviceWidth / 2,
                              child: Center(
                                child: Text(
                                  'from left',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Button('上', full: true, onTap: () {
                        showModal(
                          modal: Modal(
                            closeOnClickMask: true,
                            direction: ModalDirection.top,
                            dragToClose: true,
                            childBuilder: (c) => Container(
                              color: Colors.white,
                              height: SizeTool.deviceHeight / 5,
                              child: Center(
                                child: Text(
                                  'from top',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Button('右', full: true, onTap: () {
                        showModal(
                          modal: Modal(
                            closeOnClickMask: true,
                            direction: ModalDirection.right,
                            dragToClose: true,
                            childBuilder: (c) => Container(
                              color: Colors.white,
                              width: 300,
                              height: SizeTool.deviceHeight,
                              child: Center(
                                child: Text(
                                  'from right',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Button('下', full: true, onTap: () {
                        showModal(
                          modal: Modal(
                            closeOnClickMask: true,
                            noMask: true,
                            direction: ModalDirection.bottom,
                            dragToClose: true,
                            childBuilder: (c) => Container(
                              color: Colors.white,
                              width: SizeTool.deviceWidth,
                              height: SizeTool.deviceHeight / 5,
                              child: Center(
                                child: Text(
                                  'from bottom',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      InputItem(
                        title: Text('输入框'),
                        placeholder: '触发键盘',
                      )
                    ]),
              ),
            ),
          ),
        ));
  }
}
