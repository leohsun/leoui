library leo_ui.picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';

// ignore: todo
// TODO locate default value

// DEMO 1 LINKAGE PICKER
// LeoButton(
//   'show linkage picker',
//   onTap: () {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (ctx) {
//           return LeoPicker(
//             columnKey: 'label',
//             linkage: true,
//             count: 3,
//             dataList: [
//               [
//                 {
//                   "label": "动物",
//                   'children': [
//                     {
//                       "label": "狗",
//                       'children': [
//                         {'label': '拉布拉多'},
//                         {'label': '哈士奇'},
//                         {'label': '藏獒'},
//                       ]
//                     },
//                     {"label": "猫"},
//                     {"label": "兔"}
//                   ]
//                 },
//                 {
//                   "label": "植物",
//                   'children': [
//                     {
//                       "label": "树",
//                       'children': [
//                         {'label': '苹果树'}
//                       ]
//                     },
//                     {"label": "草"},
//                   ]
//                 },
//                 {"label": '没有下级'}
//               ],
//             ],
//           );
//         });
//   },
// ),

// DEMO2 NORMAL PICKER
// LeoButton(
//   'show picker',
//   onTap: () {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (ctx) {
//           return LeoPicker(
//             columnKey: 'label',
//             onComfrim: (data) {
//               print(data);
//             },
//             dataList: [
//               [
//                 {'label': '中国'},
//                 {'label': '美国'},
//                 {'label': '英国'},
//               ],
//               [
//                 {'label': '男'},
//                 {'label': '女'},
//               ],
//               [
//                 {'label': '学生'},
//                 {'label': '工人'},
//                 {'label': '教师'},
//               ],
//             ],
//           );
//         });
//   },
// ),

class LeoPicker extends StatefulWidget {
  final bool linkage;
  final List<List> dataList;
  final int count;
  final String title;
  final String cancleText;
  final String confirmText;
  final Color cancleTextColor;
  final Color confirmTextTextColor;
  final VoidCallback? onCancel;
  final ValueChanged? onComfrim;
  final String columnKey;
  final String childrenKey;
  final double pickerHeight;
  final bool hideHeader;

  const LeoPicker(
      {Key? key,
      this.linkage = false,
      required this.dataList,
      count,
      this.title = '',
      this.cancleText = "取消",
      this.confirmText = '确定',
      this.cancleTextColor = LeoColors.dark,
      this.confirmTextTextColor = LeoColors.primary,
      this.onCancel,
      this.columnKey = 'label',
      this.childrenKey = 'children',
      this.pickerHeight = LeoSize.itemExtent * 5,
      this.hideHeader = false,
      this.onComfrim})
      : assert(linkage != true || count != null,
            "when 'linkage' is ture then 'count' must be provided"),
        count = count ?? dataList.length,
        super(key: key);

  @override
  _LeoPickerState createState() => _LeoPickerState();
}

class _LeoPickerState extends State<LeoPicker> {
  List<List> _dataList = [];

  List<FixedExtentScrollController> _scrollControllerList = [];

  List<int> activeIndexList = [];

  @override
  void initState() {
    _dataList = widget.dataList;

    int length = widget.linkage ? widget.count : widget.dataList.length;

    for (int i = 0; i < length; i++) {
      activeIndexList.add(0);
      _scrollControllerList.add(FixedExtentScrollController());
    }

    if (widget.linkage) {
      initNextColumnListData(0, 0);
    }

    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerList.forEach((scrollController) {
      scrollController.dispose();
    });
    super.dispose();
  }

  void _handleCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleCofirm() {
    if (widget.onComfrim != null) {
      List checkedData = [];

      for (int i = 0; i < activeIndexList.length; i++) {
        Map item = activeIndexList[i] > -1
            ? _dataList[i].length > 0
                ? Map.from(_dataList[i][activeIndexList[i]])
                : {}
            : {};
        item.remove(widget.childrenKey);
        checkedData.add(item);
      }

      widget.onComfrim!(checkedData);
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildHeader() {
    if (widget.hideHeader)
      return SizedBox(
        height: 0,
      );
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      child: Container(
        // height: LeoSize.itemExtent * 1.5,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 1, color: Colors.grey.shade100),
                bottom: BorderSide(width: 1, color: Colors.grey.shade100)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade100, spreadRadius: 0, blurRadius: 10),
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
                onPressed: _handleCancel,
                child: Text(
                  widget.cancleText,
                  style: TextStyle(
                      color: widget.cancleTextColor,
                      fontSize: LeoSize.fontSize.title),
                )),
            Expanded(
                child: Center(
                    child: Text(widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: widget.cancleTextColor,
                            fontSize: LeoSize.fontSize.title)))),
            TextButton(
                onPressed: _handleCofirm,
                child: Text(
                  widget.confirmText,
                  style: TextStyle(
                      color: widget.confirmTextTextColor,
                      fontSize: LeoSize.fontSize.tab),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String label) {
    return Container(
      height: LeoSize.itemExtent,
      child: Center(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buldColumn(List data, int columnIndex) {
    List _data = List.from(data);
    if (_data.length == 0) {
      // must provide less one child to CupertinoPicker children, otherwise ,it will cause a rebuilding bug;
      _data.add({widget.columnKey: ' '});
    }
    List<Widget> children = _data
        .map((data) => _buildCell(data[widget.columnKey] ?? 'unknown'))
        .toList();

    FixedExtentScrollController _controller =
        _scrollControllerList[columnIndex];

    if (_controller.hasClients) {
      int currentSelectItem = _controller.selectedItem;
      int expectSelectItem = activeIndexList[columnIndex] == -1
          ? 0
          : currentSelectItem > _data.length - 1
              ? _data.length - 1
              : currentSelectItem;
      if (currentSelectItem != expectSelectItem) {
        _controller.jumpToItem(expectSelectItem);

        if (activeIndexList[columnIndex] != -1) {
          activeIndexList[columnIndex] = expectSelectItem;
        }
      }
    }

    return Expanded(
      child: CupertinoPicker(
          scrollController: _scrollControllerList[columnIndex],
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            capLeftEdge: columnIndex == 0,
            capRightEdge: columnIndex == _dataList.length - 1,
          ),
          itemExtent: LeoSize.itemExtent,
          onSelectedItemChanged: (int cellIndex) {
            _handleSelectChange(columnIndex, cellIndex);
          },
          children: children),
    );
  }

  Widget _buldColumns() {
    List<Widget> widgetList = [];
    for (int i = 0; i < _dataList.length; i++) {
      widgetList.add(_buldColumn(_dataList[i], i));
    }

    return Container(
      height: widget.pickerHeight,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widgetList,
      ),
    );
  }

  void _handleSelectChange(int columnIndex, int cellIndex) {
    activeIndexList[columnIndex] = cellIndex;
    if (widget.linkage != true) return;
    if (columnIndex == _dataList.length - 1) return;
    initNextColumnListData(columnIndex, cellIndex);
  }

  void initNextColumnListData(int changedColumnIndex, int changedCellIndex) {
    List<List> nochangeDataList = _dataList.sublist(0, changedColumnIndex + 1);

    List parent = _dataList[changedColumnIndex]; // this is changed col;
    List<List> tmp = [];

    while (changedColumnIndex < widget.count - 1) {
      changedCellIndex = changedCellIndex > parent.length - 1
          ? parent.length - 1
          : changedCellIndex;

      parent = parent.length > 0
          ? parent[changedCellIndex][widget.childrenKey] ?? []
          : [];
      changedColumnIndex++;

      bool hasClients = _scrollControllerList[changedColumnIndex].hasClients;

      changedCellIndex = hasClients
          ? _scrollControllerList[changedColumnIndex].selectedItem
          : 0;

      // activeIndexList[changedColumnIndex] = parent.length == 0 ? -1 : 0;

      if (parent.length == 0) activeIndexList[changedColumnIndex] = -1;
      tmp.add(parent);
    }
    setState(() {
      _dataList = nochangeDataList + tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).padding.bottom;
    return Material(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildHeader(), _buldColumns()],
        ),
      ),
    );
  }
}
