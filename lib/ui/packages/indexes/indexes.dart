import 'package:flutter/material.dart';
import 'package:leoui/config/theme.dart';
import 'package:leoui/ui/index.dart';
import 'package:leoui/utils/index.dart';

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
  GlobalKey scrollWidget = GlobalKey();

  late List<GlobalKey> sliverKeys = [];

  late Map<String, double> indexKeyMap;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      var sliverRenderObj = sliverKeys[0].currentContext?.findRenderObject();
      var trasiction = sliverRenderObj?.getTransformTo(null).getTranslation();
      print(trasiction?.y);
    }
    return false;
  }

  List<Map> _assembleListData() {
    print(widget.dataList);
    Map<String, List> tmp = {};

    widget.dataList.forEach((element) {
      String key = element[widget.indexKey];
      if (tmp[key] != null) {
        tmp[key]?.add(element);
      } else {
        tmp.addAll({
          key: [element]
        });
      }
    });
    List<Map<String, dynamic>> sortedList = [];
    tmp.entries.forEach((element) {
      sortedList.add({"key": element.key, "data": element.value});
      sliverKeys
          .add(GlobalKey(debugLabel: element.key)); // used to detect child rect
    });
    sortedList.sort((a, b) {
      return a["key"].compareTo(b["key"]);
    });
    print('sortedList => $sortedList');

    return sortedList;
  }

  late List<Map> scrollListData;

  @override
  void initState() {
    scrollListData = _assembleListData();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox? scrollWidgetRenderbox =
          (scrollWidget.currentContext!.findRenderObject() as RenderBox);
      print(scrollWidgetRenderbox.size);
    });
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
                child: CustomScrollView(
                  key: scrollWidget,
                  slivers: mapWithIndex<Widget>(scrollListData, (item, index) {
                    return SliverToBoxAdapter(
                      key: sliverKeys[index],
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(item[widget.indexKey]),
                          ),
                          ...mapWithIndex<Widget>(item['data'], (item, index) {
                            return ListTile(
                              title: Text(item[widget.itemLabel]),
                            );
                          })
                        ],
                      ),
                    );
                  }),
                ),
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
