import 'package:flutter/material.dart' hide SearchBar;
import 'package:leoui/leoui.dart';

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({Key? key}) : super(key: key);

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('SearchBar-搜索栏'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      title: Text('1、基础用法'),
                    ),
                    SearchBar(
                      onSubmit: (keywords) {
                        showToast(keywords);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('2、自定义placeholder及搜索按钮文本'),
                    ),
                    SearchBar(
                      placeholder: '搜一搜',
                      // brightness: LeouiBrightness.dark,
                      onSubmit: (keywords) {
                        showToast(keywords);
                      },
                    ),
                    ListTile(
                      title: Text('3、默认值'),
                    ),
                    SearchBar(
                      defaultkeywords: '羽绒服',
                      onSubmit: (keywords) {
                        showToast(keywords);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
