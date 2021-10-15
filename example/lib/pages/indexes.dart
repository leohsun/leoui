import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/leoui.dart';

class IndexesPage extends StatefulWidget {
  const IndexesPage({Key? key}) : super(key: key);

  @override
  _IndexesPageState createState() => _IndexesPageState();
}

class _IndexesPageState extends State<IndexesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LeouiTheme.of(context).backgroundPrimaryColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Indexes-索引选择器...'),
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
                      title: Text('主题'),
                    ),
                    Indexes(
                      // brightness: LeouiBrightness.dark,
                      dataList: [
                        {"key": "A", "label": "Apple", "value": 'apple'},
                        {"key": "B", "label": "Blue", "value": 'blue'}
                      ],
                      indexKey: "key",
                      itemLabel: "label",
                    )
                  ]),
            ),
          ),
        ));
  }
}
