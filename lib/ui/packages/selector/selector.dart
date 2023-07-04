library leo_ui.selector;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/feedback/index.dart';
import 'package:leoui/ui/packages/scalableText/scalableText.dart';
import 'package:leoui/utils/index.dart';

// ignore: todo
// TODO locate default value

// DEMO 1 LINKAGE Selector
// Button(
//   'show linkage selector',
//   onTap: () {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (ctx) {
//           return Selector(
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

// DEMO2 NORMAL Selector
// Button(
//   'show selector',
//   onTap: () {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (ctx) {
//           return Selector(
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

class Selector extends StatefulWidget {
  final bool? linkage;
  final List<List> dataList;
  final int count;
  final String? title;
  final String? cancleText;
  final String? confirmText;
  final Color? cancleTextColor;
  final Color? confirmTextColor;
  final VoidCallback? onCancel;
  final ValueChanged? onComfrim;
  final String columnKey;
  final String childrenKey;
  final double? selectorHeight;
  final bool hideHeader;
  final LeouiBrightness? brightness;

  Selector(
      {Key? key,
      this.linkage = false,
      required this.dataList,
      count,
      this.title,
      this.brightness,
      this.cancleTextColor,
      this.confirmTextColor,
      this.selectorHeight,
      columnKey,
      childrenKey,
      this.onCancel,
      this.hideHeader = false,
      this.cancleText,
      this.confirmText,
      this.onComfrim})
      : assert(linkage != true || count != null,
            "when 'linkage' is true then 'count' must be provided"),
        count = count ?? dataList.length,
        columnKey = columnKey ?? 'label',
        childrenKey = childrenKey ?? 'children',
        super(key: key);

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  List<List> _dataList = [];

  GlobalKey selectorContainer = GlobalKey();

  List<FixedExtentScrollController> _scrollControllerList = [];

  List<int> activeIndexList = [];

  late LeouiThemeData theme;

  @override
  void initState() {
    _dataList = widget.dataList;

    int length = widget.linkage == true ? widget.count : widget.dataList.length;

    for (int i = 0; i < length; i++) {
      activeIndexList.add(0);
      _scrollControllerList.add(FixedExtentScrollController());
    }

    if (widget.linkage == true) {
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

    bool isInModal = ModalScope.of(context) != null;

    if (isInModal) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ModalScope.of(context)?.closeModal();
      });
    }
  }

  void _handleCofirm() {
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

    if (widget.onComfrim != null) {
      widget.onComfrim!(checkedData);
    }
    bool isInModal = ModalScope.of(context) != null;

    if (isInModal) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ModalScope.of(context)?.closeModal(checkedData);
      });
    }
  }

  Widget _buildHeader() {
    if (widget.hideHeader)
      return SizedBox(
        height: 0,
      );
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.size!().cardBorderRadius),
          topRight: Radius.circular(theme.size!().cardBorderRadius)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.backgroundSecondaryColor,
        ),
        child: Row(
          children: [
            TextButton(
                onPressed: _handleCancel,
                child: Text(
                  widget.cancleText ??
                      LeouiLocalization.of(LeoFeedback.currentContext!).cancel,
                  style: TextStyle(
                      color:
                          widget.cancleTextColor ?? theme.labelSecondaryColor,
                      fontSize: theme.size!().title),
                )),
            Expanded(
                child: Center(
                    child: Text(widget.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: widget.cancleTextColor,
                            fontSize: theme.size!().title)))),
            TextButton(
                onPressed: _handleCofirm,
                child: Text(
                  widget.confirmText ??
                      LeouiLocalization.of(LeoFeedback.currentContext!).confirm,
                  style: TextStyle(
                      color: widget.confirmTextColor ?? theme.userAccentColor,
                      fontSize: theme.size!().title),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildCell(
    String label,
  ) {
    return Container(
      height: theme.size!().itemExtent,
      child: Center(
        child: ScalableText(
          label,
          minFontSize: sz(10),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: sz(theme.size!().content),
              color: theme.labelPrimaryColor),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buldColumn(
    List data,
    int columnIndex,
  ) {
    List _data = List.from(data);
    if (_data.length == 0) {
      // must provide less one child to CupertinoSelector children, otherwise ,it will cause a rebuilding bug;
      _data.add({widget.columnKey: ' '});
    }
    List<Widget> children = _data
        .map((data) => _buildCell(data[widget.columnKey] ?? 'unknown'))
        .toList(growable: false);

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
            capStartEdge: columnIndex == 0,
            capEndEdge: columnIndex == _dataList.length - 1,
            background: theme.fillSecondaryColor,
          ),
          itemExtent: theme.size!().itemExtent,
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
      height: widget.selectorHeight ?? sz(theme.size!().itemExtent * 5),
      key: selectorContainer,
      color: theme.backgroundPrimaryColor,
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

      activeIndexList[changedColumnIndex] =
          parent.length == 0 ? -1 : changedCellIndex;

      tmp.add(parent);
    }
    setState(() {
      _dataList = nochangeDataList + tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double bottom = SizeTool.devicePadding.bottom;

    theme = widget.brightness != null
        ? LeouiTheme.of(context).copyWith(brightness: widget.brightness)
        : LeouiTheme.of(context);

    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buldColumns(),
          Container(
            height: bottom,
            color: theme.backgroundPrimaryColor,
          )
        ],
      ),
    );
  }
}
