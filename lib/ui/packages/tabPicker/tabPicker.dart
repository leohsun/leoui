import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/feedback/index.dart';
import 'package:leoui/ui/packages/scalableText/scalableText.dart';
import 'package:leoui/utils/index.dart';

class TabPicker extends StatefulWidget {
  final List<List> dataList;
  final String? selectHintText;
  final String? columnKey;
  final String? childrenKey;
  final LeouiBrightness? brightness;
  final bool? linkage;
  final double? selectorHeight;
  final ValueChanged? onSubmit;

  TabPicker(
      {Key? key,
      String? columnKey,
      String? childrenKey,
      this.selectHintText,
      LeouiBrightness? brightness,
      bool? linkage,
      this.onSubmit,
      this.selectorHeight,
      required this.dataList})
      : columnKey = columnKey ?? 'label',
        childrenKey = childrenKey ?? 'children',
        brightness = brightness ?? LeouiBrightness.light,
        linkage = linkage ?? false,
        super(key: key);

  @override
  _TabPickerState createState() => _TabPickerState();
}

class _TabPickerState extends State<TabPicker>
    with SingleTickerProviderStateMixin {
  List selectedDataList = [{}];

  late List<List> columnDataList;

  late BuildContext tabContext;

  void _handleSelectChange(int columnIdx, int cellIdx) {
    setState(() {
      selectedDataList[columnIdx] = columnDataList[columnIdx][cellIdx];
    });
    _initNextTabData(columnIdx, cellIdx);
  }

  void _initNextTabData(int columnIdx, int cellIdx) {
    if (widget.linkage == true) {
      List? children = columnDataList[columnIdx][cellIdx][widget.childrenKey];
      if (children != null && children.length > 1) {
        if (columnIdx < columnDataList.length - 1) {
          columnDataList
              .replaceRange(columnIdx + 1, columnDataList.length, [children]);
          selectedDataList
              .replaceRange(columnIdx + 1, selectedDataList.length, [{}]);
        } else {
          columnDataList.add(children);
          selectedDataList.add({});
        }
      } else {
        columnDataList.removeRange(columnIdx + 1, columnDataList.length);
        selectedDataList.removeRange(columnIdx + 1, selectedDataList.length);

        handleSelectSubmit();
      }
      animateTabIndex();
    } else {
      if (columnIdx == columnDataList.length - 1) {
        if (columnDataList.length < widget.dataList.length) {
          columnDataList.add(widget.dataList[columnIdx + 1]);
          selectedDataList.add({});
          animateTabIndex();
        }
      }

      if (selectedDataList.length == widget.dataList.length &&
          selectedDataList.last.length != 0) handleSelectSubmit();
    }
  }

  void animateTabIndex() {
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DefaultTabController.of(tabContext)
          .animateTo(selectedDataList.length - 1);
    });
  }

  void handleSelectSubmit() {
    List submitList = selectedDataList.map((e) {
      Map data = Map.from(e);
      data.remove(widget.childrenKey);
      return data;
    }).toList(growable: false);

    bool isInModal = ModalScope.of(context) != null;

    if (widget.onSubmit != null) {
      widget.onSubmit!(submitList);
    }

    if (isInModal) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ModalScope.of(context)?.closeModal(submitList);
      });
    }
  }

  @override
  void initState() {
    columnDataList = [widget.dataList.first];
    super.initState();
  }

  Widget _buildTabViewChild(
      List columnData, int columnIndex, LeouiThemeData theme) {
    return CustomScrollView(
      slivers: [
        ...mapWithIndex<Widget, Map>(
          columnData,
          ((data, idx) {
            bool isSelected = selectedDataList[columnIndex][widget.columnKey] ==
                data[widget.columnKey];
            return SliverToBoxAdapter(
              child: buildButtonWidget(
                onTap: () {
                  _handleSelectChange(columnIndex, idx);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: theme.fillPrimaryColor))),
                  height: theme.size!().itemExtent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ScalableText(
                        data[widget.columnKey] ?? 'unknown',
                        minFontSize: 10,
                        style: TextStyle(
                            fontSize: theme.size!().content,
                            color: isSelected
                                ? theme.userAccentColor
                                : theme.labelPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme =
        LeouiTheme.of(context)!.theme(brightness: widget.brightness);
    return Material(
      child: Padding(
        padding: EdgeInsets.only(bottom: SizeTool.devicePadding.bottom),
        child: Container(
            decoration: BoxDecoration(
              color: theme.backgroundPrimaryColor,
              borderRadius:
                  BorderRadius.circular(theme.size!().cardBorderRadius),
            ),
            child: DefaultTabController(
                length: selectedDataList.length,
                child: Builder(builder: (BuildContext ctx) {
                  tabContext = ctx;
                  final hintText = widget.selectHintText ??
                      LeouiLocalization.of(LeoFeedback.currentContext!)
                          .tabPickerSelectHintText;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: SizeTool.deviceWidth,
                        child: TabBar(
                            labelColor: theme.userAccentColor,
                            indicatorColor: theme.userAccentColor,
                            isScrollable: true,
                            tabs: [
                              ...mapWithIndex<Widget, Map>(selectedDataList,
                                  (data, idx) {
                                return Container(
                                  height: theme.size!().itemExtent,
                                  child: Center(
                                    child: Text(
                                      data[widget.columnKey] ?? hintText,
                                      style: TextStyle(
                                          fontSize: theme.size!().title),
                                    ),
                                  ),
                                );
                              })
                            ]),
                      ),
                      Container(
                        height: widget.selectorHeight ??
                            theme.size!().itemExtent * 4,
                        child: TabBarView(
                          children: [
                            ...mapWithIndex<Widget, dynamic>(columnDataList,
                                (e, idx) {
                              return _buildTabViewChild(e, idx, theme);
                            })
                          ],
                        ),
                      ),
                    ],
                  );
                }))),
      ),
    );
  }
}
