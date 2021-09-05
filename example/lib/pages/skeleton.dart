import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({Key? key}) : super(key: key);

  @override
  _SkeletonPageState createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text('Skeleton-骨架屏'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('基础用法'),
          ),
          Skeleton(),
          ListTile(
            title: Text('自定义'),
            subtitle: Text('背景色须为白色'),
          ),
          Skeleton(
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
