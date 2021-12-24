import 'package:flutter/material.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text('主题'),
                    ),
                    Container(
                      height: 500,
                      child: Indexes(
                        // brightness: LeouiBrightness.dark,
                        dataList: [
                          {"key": "B", "label": "Book", "value": 'book'},
                          {"key": "B", "label": "Bag", "value": 'bag'},
                          {"key": "A", "label": "Apple", "value": 'apple'},
                          {"key": "B", "label": "Blue", "value": 'blue'},
                          {"key": "B", "label": "blur", "value": 'blur'},
                          {"key": "B", "label": "bar", "value": 'bar'},
                          {"key": "B", "label": "bady", "value": 'bady'},
                          {"key": "A", "label": "able", "value": 'able'},
                          {"key": "A", "label": "achieve", "value": 'achieve'},
                          {"key": "C", "label": "card", "value": 'card'},
                          {"key": "C", "label": "care", "value": 'care'},
                          {"key": "C", "label": "carry", "value": 'carry'},
                          {"key": "C", "label": "cat", "value": 'cat'},
                        ],
                        indexKey: "key",
                        itemLabel: "label",
                        onItemTap: (data) {
                          print(data);
                        },
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
