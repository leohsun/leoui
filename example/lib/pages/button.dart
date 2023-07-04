import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/ui/index.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({Key? key}) : super(key: key);

  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Button-按钮'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('颜色'),
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        Button(
                          'primary',
                          onTap: () {},
                        ),
                        Button(
                          'primary',
                          color: LeoColors.danger,
                          onTap: () {},
                        ),
                        Button(
                          'primary',
                          color: LeoColors.success,
                          onTap: () {},
                        ),
                        Button(
                          'primary',
                          color: LeoColors.warn,
                          onTap: () {},
                        ),
                        Button(
                          'primary',
                          color: LeoColors.dark,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('尺寸'),
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        Button(
                          'primary-small',
                          size: ButtonSize.small,
                          onTap: () {},
                        ),
                        Button(
                          'primary-small',
                          size: ButtonSize.small,
                          color: LeoColors.danger,
                          onTap: () {},
                        ),
                        Button(
                          'primary-small',
                          color: LeoColors.success,
                          size: ButtonSize.small,
                          onTap: () {},
                        ),
                        Button(
                          'primary-small',
                          color: LeoColors.warn,
                          size: ButtonSize.small,
                          onTap: () {},
                        ),
                        Button(
                          'primary-small',
                          size: ButtonSize.small,
                          color: LeoColors.dark,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('类型'),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Button(
                          'primary',
                          onTap: () {},
                        ),
                        Button(
                          'secondary',
                          type: ButtonType.secondary,
                          onTap: () {},
                        ),
                        Button(
                          'primary-disabled',
                          disabled: true,
                          onTap: () {},
                        ),
                        Button(
                          'secondary-disabled',
                          disabled: true,
                          type: ButtonType.secondary,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('圆角'),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button(
                            'circle-primary',
                            circle: true,
                            size: ButtonSize.small,
                            onTap: () {},
                          ),
                          Button(
                            'circle-secondary',
                            size: ButtonSize.small,
                            circle: true,
                            type: ButtonType.secondary,
                            onTap: () {},
                          ),
                        ]),
                    ListTile(
                      title: Text('loading'),
                    ),
                    Button(
                      'circle-primary-loading',
                      loading: true,
                      circle: true,
                      onTap: () {},
                      color: LeoColors.success,
                    ),
                    ListTile(
                      title: Text('通栏'),
                    ),
                    Button(
                      'secondary-full-loading',
                      loading: true,
                      full: true,
                      onTap: () {},
                      color: LeoColors.success,
                    ),
                    ListTile(
                      title: Text('分组'),
                    ),
                    ButtonGroup(color: LeoColors.danger, children: [
                      Button(
                        'first',
                        onTap: () {},
                      ),
                      Button(
                        'middle',
                        color: LeoColors.success,
                        onTap: () {},
                      ),
                      Button(
                        'last',
                        onTap: () {},
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonGroup(
                        type: ButtonType.secondary,
                        circle: true,
                        color: LeoColors.success,
                        size: ButtonSize.small,
                        children: [
                          Button(
                            'first',
                            onTap: () {},
                          ),
                          Button(
                            'second',
                            onTap: () {},
                          ),
                          Button(
                            'thrid',
                            onTap: () {},
                          ),
                          Button(
                            'fourth',
                            onTap: () {},
                          ),
                          Button(
                            'last',
                            onTap: () {},
                          )
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonGroup(children: [
                      Button(
                        '哈哈',
                        onTap: () {},
                      ),
                      Button(
                        '嘻嘻',
                        onTap: () {},
                        // color: Colors.red,
                      ),
                      Button(
                        '嘿嘿',
                        onTap: () {},
                        // color: Colors.blue,
                      ),
                      Button(
                        '嘿嘿',
                        onTap: () {},
                        // color: Colors.orange,
                      )
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
