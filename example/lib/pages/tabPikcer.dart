import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class TabPickerPage extends StatefulWidget {
  const TabPickerPage({Key? key}) : super(key: key);

  @override
  _TabPickerPageState createState() => _TabPickerPageState();
}

class _TabPickerPageState extends State<TabPickerPage> {
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
                        placeholder: Text("请选择地址"),
                        arrow: true,
                        onTap: () {},
                      )
                    ],
                  ),
                  ListTile(
                    title: Text('组件示例'),
                  ),
                  TabPicker()
                ],
              ),
            ),
          ),
        ));
  }
}
