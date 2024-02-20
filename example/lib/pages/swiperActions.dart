import 'package:flutter/material.dart';
import 'package:leoui/feedback/index.dart';
import 'package:leoui/ui/packages/swipeActions/swipeActions.dart';

class SwipeActionsPage extends StatefulWidget {
  const SwipeActionsPage({super.key});

  @override
  State<SwipeActionsPage> createState() => _SwipeActionSPagetate();
}

class _SwipeActionSPagetate extends State<SwipeActionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SwipeActions - 滑动菜单')),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Divider(),
          SwipeActions(
            leadingActions: [
              SwipeAction(
                  child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
              SwipeAction(
                  text: "置顶",
                  onTap: () {
                    showToast('置顶');
                  }),
            ],
            child: Container(
              width: double.infinity,
              color: Colors.amber,
              child: ListTile(title: Text('leading only')),
            ),
          ),
          Divider(),
          SwipeActions(
            trailingActions: [
              SwipeAction(
                  child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
              SwipeAction(
                  text: "置顶",
                  onTap: () {
                    showToast('置顶');
                  }),
            ],
            child: Container(
              width: double.infinity,
              color: Colors.amber,
              child: ListTile(title: Text('trailing only')),
            ),
          ),
          Divider(),
          SwipeActions(
            leadingActions: [
              SwipeAction(
                  child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
              SwipeAction(
                  text: "置顶",
                  onTap: () {
                    showToast('置顶');
                  }),
            ],
            trailingActions: [
              SwipeAction(
                  child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
              SwipeAction(
                  text: "置顶",
                  onTap: () {
                    showToast('置顶');
                  }),
            ],
            child: Container(
              width: double.infinity,
              color: Colors.amber,
              child: ListTile(title: Text('leading + trailing')),
            ),
          ),
          SizedBox(
            height: 300,
          )
        ],
      )),
    );
  }
}
