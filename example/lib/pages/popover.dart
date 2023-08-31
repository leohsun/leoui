import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class PopoverPage extends StatefulWidget {
  const PopoverPage({Key? key}) : super(key: key);

  @override
  _PopoverPageState createState() => _PopoverPageState();
}

class _PopoverPageState extends State<PopoverPage> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('popover-气泡弹出框'),
        ),
        backgroundColor: Color(0xfffbfbfb),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: SizeTool.deviceHeight * 2,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('1,基本'),
                        subtitle: Text('可根据屏幕布局，自动计算合适的palcement'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Popover(
                            placement: PopoverPlacement.right,
                            child: Button('hello word'),
                            content: 'hellow world',
                          ),
                          Popover(
                            placement: PopoverPlacement.right,
                            child: Button(
                              '黑暗模式',
                              color: Colors.black,
                            ),
                            brightness: LeouiBrightness.dark,
                            content: 'hellow world',
                          ),
                        ],
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('2,Popover.menu'),
                        subtitle: Text('可根据屏幕布局，自动计算合适的palcement'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Popover.menu(
                            placement: PopoverPlacement.right,
                            child: Button('hello word'),
                            actions: [
                              PopoverAction(
                                  text: '删除', icon: Icons.clear_sharp),
                              PopoverAction(
                                  text: '添加', icon: Icons.add, disabled: true)
                            ],
                          ),
                          Popover.menu(
                            placement: PopoverPlacement.left,
                            child: Button(
                              '长按弹出',
                              color: Colors.black,
                              onTap: () {
                                print('on tap trigger');
                              },
                            ),
                            brightness: LeouiBrightness.dark,
                            triggerType: PopoverTriggerType.lonPress,
                            actions: [
                              PopoverAction(
                                  text: '删除', icon: Icons.clear_sharp),
                              PopoverAction(
                                  text: '添加', icon: Icons.add, onPress: () {}),
                              PopoverAction(
                                  text: '编辑',
                                  icon: Icons.edit,
                                  onPress: () {},
                                  disabled: true),
                            ],
                          ),
                        ],
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('3,基本Popover.customize'),
                        subtitle:
                            Text('调用“PopoverScope.of(context)!.close();”来关闭'),
                      ),
                      Column(
                        children: [
                          Popover.customize(
                            placement: PopoverPlacement.top,
                            child: Button('hello top'),
                            customPopoverWidgetBuilder: (context) => Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Popover.customize(
                            placement: PopoverPlacement.bottom,
                            child: Button('hello bottom'),
                            customPopoverWidgetBuilder: (context) => Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.update)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Popover.customize(
                            placement: PopoverPlacement.top,
                            child: Button('hello top left'),
                            arrowColor: Colors.white,
                            customPopoverWidgetBuilder: (context) => Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.update)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts)),
                              ],
                            ),
                          ),
                          Popover.customize(
                            placement: PopoverPlacement.top,
                            child: Button('hello top right'),
                            customPopoverWidgetBuilder: (context) => Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.update)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Popover.customize(
                            placement: PopoverPlacement.bottom,
                            child: Button('hello bottom left'),
                            arrowColor: Colors.white,
                            customPopoverWidgetBuilder: (context) => Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.update)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts)),
                              ],
                            ),
                          ),
                          Popover.customize(
                            placement: PopoverPlacement.bottom,
                            child: Button('hello bottom right'),
                            customPopoverWidgetBuilder: (context) => Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.update)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.mail)),
                                IconButton(
                                    onPressed: () {
                                      PopoverScope.of(context)!.close();
                                    },
                                    icon: Icon(Icons.podcasts))
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('4,通过调用属性"show=$_show"'),
                        subtitle: RichText(
                          text: TextSpan(
                              text: '请通过改变"show"的true或false来关闭\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              children: [
                                TextSpan(
                                    text:
                                        '无法调用“PopoverScope.of(context)!.close();”',
                                    style: TextStyle(color: Colors.red))
                              ]),
                        ),
                      ),
                      Column(
                        children: [
                          Popover.customize(
                            placement: PopoverPlacement.bottom,
                            child: Button(
                              'hello bottom',
                              onTap: () {
                                setState(() {
                                  _show = !_show;
                                });
                              },
                            ),
                            show: _show,
                            arrowColor: Colors.orange,
                            // showArrow: false,
                            customPopoverWidgetBuilder: (context) => Container(
                              color: Colors.orange,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        PopoverScope.of(context)!.close();
                                      },
                                      icon: Icon(Icons.add)),
                                  IconButton(
                                      onPressed: () {
                                        PopoverScope.of(context)!.close();
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        PopoverScope.of(context)!.close();
                                      },
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {
                                        PopoverScope.of(context)!.close();
                                      },
                                      icon: Icon(Icons.update)),
                                  IconButton(
                                      onPressed: () {
                                        PopoverScope.of(context)!.close();
                                      },
                                      icon: Icon(Icons.mail)),
                                  IconButton(
                                      onPressed: () {
                                        PopoverScope.of(context)!.close();
                                      },
                                      icon: Icon(Icons.podcasts))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Popover.customize(
                            placement: PopoverPlacement.left,
                            child: Button('hello top'),
                            arrowColor: Colors.white,
                            customPopoverWidgetBuilder: (context) => Container(
                              height: SizeTool.deviceHeight,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
