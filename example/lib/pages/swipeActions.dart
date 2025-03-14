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
          SwipeActions(
            leadingActions: [
              SwipeAction(
                  text: "置顶",
                  onTap: () {
                    showToast('置顶');
                  }),
              SwipeAction(text: "删除"),
              SwipeAction(child: Icon(Icons.abc))
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
                  text: "置顶",
                  onTap: () {
                    showToast('置顶');
                  }),
            ],
            trailingActions: [
              SwipeAction(
                  text: "删除",
                  onTap: () async {
                    showToast('确认删除?');
                    await Future.delayed(Duration(seconds: 2));
                    showToast('删除');
                  }),
              SwipeAction(
                  child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
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
