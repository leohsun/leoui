import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leoui/leoui.dart';

class IndexesItemBuilderCallback {
  final Map data;
  final int filedIndex;
  final int itemIndex;

  IndexesItemBuilderCallback(this.data, this.filedIndex, this.itemIndex);

  @override
  String toString() {
    return "data: ${data.toString()};\n\t filedIndex:$filedIndex;\nitemIndex:$itemIndex; ";
  }
}

class Indexes extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;
  final String indexKey;
  final String itemLabel;
  final LeouiBrightness? brightness;
  final ValueChanged? onItemTap;
  final Widget Function(IndexesItemBuilderCallback)? itemBuilder;

  const Indexes(
      {Key? key,
      required this.dataList,
      required this.indexKey,
      required this.itemLabel,
      this.onItemTap,
      this.brightness,
      this.itemBuilder})
      : super(key: key);

  @override
  _IndexesState createState() => _IndexesState();
}

class IndexPostion {
  double startY;
  double endY;
  IndexPostion(this.startY, this.endY);
  @override
  String toString() {
    return 'startY->$startY endY->$endY';
  }
}

class _IndexesState extends State<Indexes> {
  ScrollController scrollView = ScrollController();
  List<GlobalKey> sliverKeys = [];
  List<String> indexKeyList = [];
  double indexKeyExtend = 0;
  List<IndexPostion> indexPostionList = [];
  String activeKey = 'c';
  double maxScrollExtend = 0;

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      calcActivekey(notification.metrics.extentBefore);
    }
    return false;
  }

  List<Map> _assembleListData() {
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
    sortedList.forEach((element) {
      indexKeyList.add(element['key']);

      indexPostionList.add(IndexPostion(0, 0));
    });

    activeKey = indexKeyList.first;

    return sortedList;
  }

  late List<Map> scrollListData;

  void calcSliverPostions() {
    for (int i = 0; i < sliverKeys.length; i++) {
      RenderBox? sliverRenderBox =
          sliverKeys[i].currentContext?.findRenderObject() as RenderBox;

      double startY = i == 0 ? 0 : indexPostionList[i - 1].endY;
      double endY = startY + sliverRenderBox.size.height;

      indexPostionList[i].startY = startY;
      indexPostionList[i].endY = endY;
    }
  }

  void calcActivekey(double offset) {
    late int activeKeyIndex;

    if (offset <= 0)
      activeKeyIndex = 0;
    else if (offset >= indexPostionList.last.endY)
      activeKeyIndex = indexPostionList.length - 1;
    else
      activeKeyIndex = indexPostionList.indexWhere((indexPostion) =>
          offset >= indexPostion.startY && offset < indexPostion.endY);

    String aimedKey = indexKeyList[activeKeyIndex];
    if (mounted) {
      setState(() {
        activeKey = aimedKey;
      });
    }
  }

  @override
  void initState() {
    scrollListData = _assembleListData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calcSliverPostions();
      maxScrollExtend = scrollView.position.maxScrollExtent;
    });
    super.initState();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    int index = (details.localPosition.dy ~/ indexKeyExtend)
        .clamp(0, indexKeyList.length - 1);

    if (activeKey != indexKeyList[index]) {
      setState(() {
        activeKey = indexKeyList[index];
        showToast(activeKey);
      });
      _handleScroll(index);
    }
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    calcActivekey(scrollView.offset);
    showToast(activeKey);
  }

  void _handleTapDown(TapDownDetails details) {
    int index = (details.localPosition.dy ~/ indexKeyExtend)
        .clamp(0, indexKeyList.length - 1);
    if (activeKey != indexKeyList[index]) {
      setState(() {
        activeKey = indexKeyList[index];
      });
      _handleScroll(index);
    }
  }

  void _handleScroll(int activeIndex) {
    double expectPostionStartY = indexPostionList[activeIndex].startY;

    double startY = min(expectPostionStartY, maxScrollExtend);
    HapticFeedback.lightImpact();
    scrollView.jumpTo(startY);
  }

  void _handleTapUp(TapUpDetails details) {
    calcActivekey(scrollView.offset);
    showToast(activeKey);
  }

  @override
  void dispose() {
    scrollView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = widget.brightness == null
        ? LeouiTheme.of(context)
        : LeouiThemeData(brightness: widget.brightness);
    indexKeyExtend = theme.size!().tertiary * 1.5;
    return LayoutBuilder(builder: (context, constrains) {
      double contentHeight = constrains.maxHeight == double.infinity
          ? SizeTool.deviceHeight / 2
          : constrains.maxHeight;
      return Stack(
        children: [
          SizedBox(
              height: contentHeight,
              child: NotificationListener(
                onNotification: _onScrollNotification,
                child: SingleChildScrollView(
                    controller: scrollView,
                    child: Column(
                      children: [
                        ...mapWithIndex<Widget, Map>(scrollListData,
                            (item, filedIndex) {
                          return Field(
                            key: sliverKeys[filedIndex],
                            brightness: widget.brightness,
                            title: Text('${item["key"]}'),
                            margin: EdgeInsets.only(bottom: 20),
                            children: [
                              ...mapWithIndex<ListItem, Map>(item['data'],
                                  (item, index) {
                                IndexesItemBuilderCallback callback =
                                    IndexesItemBuilderCallback(
                                        item, filedIndex, index);
                                if (widget.itemBuilder != null) {
                                  return widget.itemBuilder!(callback);
                                }
                                return FieldItem(
                                    onTap: widget.onItemTap != null
                                        ? (ctx) {
                                            widget.onItemTap!(callback);
                                          }
                                        : null,
                                    brightness: widget.brightness,
                                    title: Text(item[widget.itemLabel]));
                              })
                            ],
                          );
                        })
                      ],
                    )),
              )),
          Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onVerticalDragUpdate: _handleVerticalDragUpdate,
                  onVerticalDragEnd: _handleVerticalDragEnd,
                  onTapUp: _handleTapUp,
                  onTapDown: _handleTapDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...indexKeyList.map((e) {
                        bool active = activeKey == e;
                        return SizedBox(
                          height: indexKeyExtend,
                          width: indexKeyExtend,
                          child: Center(
                            child: Container(
                              height: theme.size!().tertiary * 1.5,
                              width: theme.size!().tertiary * 1.5,
                              decoration: BoxDecoration(
                                  color: active ? theme.userAccentColor : null,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: theme.size!().tertiary,
                                      color: active
                                          ? Colors.white
                                          : theme.labelSecondaryColor),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              )),
        ],
      );
    });
  }
}
