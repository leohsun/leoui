import 'package:flutter/material.dart';
import 'package:leoui/config/theme.dart';
import 'package:leoui/ui/index.dart';

class Indexes extends StatefulWidget {
  final List<Map> dataList;
  final String indexKey;
  final String itemLabel;
  final LeouiBrightness? brightness;

  const Indexes(
      {Key? key,
      required this.dataList,
      required this.indexKey,
      required this.itemLabel,
      this.brightness})
      : super(key: key);

  @override
  _IndexesState createState() => _IndexesState();
}

class _IndexesState extends State<Indexes> {
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      print(notification.metrics.extentBefore);
    }
    return false;
  }

  List<List> _assembleListData() {
    print(widget.dataList);
    Map<String, List> tmp = {};

    widget.dataList.forEach((element) {
      if (tmp[widget.indexKey] != null) {
        tmp[element[widget.indexKey]]?.add(element);
      } else {
        // tmp.addEntries(newEntries)
      }
    });
    return [[]];
  }

  late List<List> scrollListData;

  @override
  void initState() {
    scrollListData = _assembleListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = widget.brightness == null
        ? LeouiTheme.of(context)
        : LeouiThemeData(brightness: widget.brightness);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchBar(brightness: widget.brightness, onSubmit: (keywords) {}),
        Stack(
          children: [
            Container(
              height: 400,
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: ListView.builder(
                    itemCount: widget.dataList.length,
                    itemBuilder: (ctx, i) {
                      return ListTile(
                        title: Text(widget.dataList[i][widget.itemLabel]),
                      );
                    }),
              ),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  color: Colors.orange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('A'), Text('B')],
                  ),
                ))
          ],
        )
      ],
    );
  }
}
