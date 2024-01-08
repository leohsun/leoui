import 'package:flutter/material.dart' hide Dialog, showDialog;
import 'package:leoui/leoui.dart';

class InputItemPage extends StatefulWidget {
  const InputItemPage({Key? key}) : super(key: key);

  @override
  _InputItemPageState createState() => _InputItemPageState();
}

class _InputItemPageState extends State<InputItemPage> {
  GlobalKey<FieldState> field = GlobalKey<FieldState>();

  List<ListItem> _children = [
    InputItem(
      title: Text("用户名"),
      icon: Icon(Icons.person),
      placeholder: '请输入用户名',
      fieldKey: 'username',
      fieldLabel: '用户名',
      defaultValue: 'a1234',
      maxLength: 20,
      validatePattern: RegExp(r'^[a-z][a-z\d]{3,}$'),
      patternDescript: '小写字母开头，包含数字，不小于3位',
    ),
    InputItem(
      leading: Row(
        children: [Icon(Icons.lock), Text('密码')],
      ),
      placeholder: '请输入密码',
      obscureText: true,
      fieldKey: 'password',
      fieldLabel: '密码',
      defaultValue: 'a123456',
      validatePattern: RegExp(r'^\S{6,}$'),
      patternDescript: '不包含空格的6位以上字符',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('InputItem-输入框'),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 50),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Field(
                      title: Text('基础'),
                      children: [
                        InputItem(
                          title: Text('普通文本'),
                          placeholder: '普通文本',
                        ),
                        InputItem(
                          title: Text('禁用表单'),
                          placeholder: '禁用表单',
                          disabled: true,
                        ),
                        InputItem(
                          title: Text('只读表单'),
                          placeholder: '只读表单',
                          readonly: true,
                        ),
                        InputItem(
                          title: Text('文字居中'),
                          placeholder: '文字居中',
                          textAlign: TextAlign.center,
                          clearable: false,
                        ),
                        InputItem(
                          title: Text('文字居右'),
                          placeholder: '文字居右',
                          textAlign: TextAlign.right,
                          clearable: false,
                          obscureText: true,
                        ),
                      ],
                      // footer: Text('区域页脚区域内容'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Field(
                      title: Text(
                        '表单校验',
                        style: TextStyle(color: Colors.red),
                      ),
                      key: field,
                      trailing: ButtonGroup(
                        size: ButtonSize.small,
                        children: [
                          Button(
                            'add',
                            onTap: () {
                              _children.add(
                                InputItem(
                                  solid: false,
                                  title: Text(
                                    '用户名' + (_children.length + 1).toString(),
                                  ),
                                  icon: Icon(Icons.person),
                                  placeholder: '请输入用户名' +
                                      (_children.length + 1).toString(),
                                  fieldKey: 'username' +
                                      (_children.length + 1).toString(),
                                  fieldLabel:
                                      '用户名' + (_children.length + 1).toString(),
                                  defaultValue: 'a1234',
                                  validatePattern:
                                      RegExp(r'^[a-z][a-z\d]{3,}$'),
                                  patternDescript: '小写字母开头，包含数字，不小于3位',
                                ),
                              );
                              setState(() {});
                            },
                          ),
                          Button(
                            'remove',
                            onTap: () {
                              setState(() {
                                _children.removeLast();
                              });
                            },
                          ),
                        ],
                      ),
                      children: _children,
                      footer: Button(
                        'validate',
                        full: true,
                        onTap: () {
                          String? valide = field.currentState?.validate();
                          if (valide == '') {
                            var param = field.currentState?.obtainDataMap();
                            showConfirm(content: param.toString(), title: '结果');
                          }
                        },
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
