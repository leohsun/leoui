import 'package:flutter/material.dart';
import 'package:leoui/ui/packages/scalableText/scalableText.dart';
import 'package:leoui/widget/leoui_state.dart';

class ActionSheetAction {
  final String text;
  final bool? checked;
  final bool? disable;

  /// 多选时的回调数据不传时返回[text]
  final dynamic payload;

  /// 单选时回调函数，多选时可不传，以免冲突
  final void Function(BuildContext context)? onTap;

  ActionSheetAction(this.text,
      {this.onTap, this.checked, this.disable, this.payload});
}

class ActionSheet extends StatefulWidget {
  final LeouiBrightness? brightness;
  final String? title; //窗口标题
  final List<ActionSheetAction> actions;
  final VoidCallback? onCancel;
  final String? cancelText;
  final String? confirmText;
  final Color? cancelTextColor;
  final Color? confirmTextColor;
  final VoidCallback? onConfirm;
  final double? height;

  /// 支持多选
  final bool? multi;
  const ActionSheet(
      {Key? key,
      required this.actions,
      this.brightness,
      this.title,
      this.multi,
      this.cancelText,
      this.cancelTextColor,
      this.onCancel,
      this.onConfirm,
      this.confirmText,
      this.confirmTextColor,
      this.height})
      : super(key: key);

  @override
  State<ActionSheet> createState() => _ActionSheetState();
}

class _ActionSheetState extends State<ActionSheet> {
  static _ActionSheetState? of(BuildContext context) {
    final _ActionsheetScope? scope =
        context.dependOnInheritedWidgetOfExactType<_ActionsheetScope>();
    return scope?.state;
  }

  Set<_ActionSheetItemState> actionSheetItemSet = Set();

  void add(_ActionSheetItemState item) {
    actionSheetItemSet.add(item);
  }

  void remove(_ActionSheetItemState item) {
    actionSheetItemSet.remove(item);
  }

  void _handleMultiComfirm() {
    List<dynamic> checkedPayloads = [];
    actionSheetItemSet.forEach((ac) {
      if (ac.toggle) {
        checkedPayloads.add(ac.widget.payload ?? ac.widget.text);
      }
    });

    ModalScope.of(context)?.closeModal(data: checkedPayloads);
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(LeoFeedback.currentContext!)!
        .theme(brightness: widget.brightness);

    List<Widget> _children = [];

    double dividerHeight = 0.6;

    Divider divider = Divider(
      height: dividerHeight,
      color: theme.opaqueSeparatorColor,
    );

    if (widget.title != null) {
      _children.add(Container(
        height: theme.size!().itemExtend * 1.2,
        alignment: Alignment.center,
        child: Text(
          widget.title!,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: theme.size!().title, color: theme.labelPrimaryColor),
        ),
      ));

      _children.add(divider);
    }

    Column actionWidget = Column(
        children:
            mapWithIndex<Widget, ActionSheetAction>(widget.actions, (d, i) {
      return ActionSheetItem(
          text: d.text,
          checked: d.checked,
          onTap: d.onTap,
          checkable: widget.multi,
          disable: d.disable,
          payload: d.payload,
          border: i != widget.actions.length - 1,
          brightness: widget.brightness);
    }));

    _children.add(ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: theme.size!().buttonNormalHeight * 5 + dividerHeight * 4),
      child: SingleChildScrollView(
        child: _ActionsheetScope(
          state: this,
          child: actionWidget,
        ),
      ),
    ));

    _children.add(Container(
      height: dividerHeight * 6,
      color: theme.opaqueSeparatorColor,
    ));

    _children.add(Row(
      children: [
        Expanded(
            child: buildButtonWidget(
                splashColor: theme.opaqueSeparatorColor,
                onTap: widget.onCancel,
                child: Container(
                  height: theme.size!().buttonNormalHeight +
                      SizeTool.devicePadding.bottom,
                  padding:
                      EdgeInsets.only(bottom: SizeTool.devicePadding.bottom),
                  alignment: Alignment.center,
                  child: Text(
                    LeouiLocalization.of(LeoFeedback.currentContext!).cancel,
                    style: TextStyle(
                        fontSize: theme.size!().title,
                        color: widget.cancelTextColor ??
                            theme.labelSecondaryColor),
                  ),
                ))),
        if (widget.multi == true)
          Expanded(
              child: buildButtonWidget(
                  splashColor: theme.opaqueSeparatorColor,
                  onTap: _handleMultiComfirm,
                  child: Container(
                    height: theme.size!().buttonNormalHeight +
                        SizeTool.devicePadding.bottom,
                    padding:
                        EdgeInsets.only(bottom: SizeTool.devicePadding.bottom),
                    alignment: Alignment.center,
                    child: Text(
                      LeouiLocalization.of(LeoFeedback.currentContext!).confirm,
                      style: TextStyle(
                          fontSize: theme.size!().title,
                          color:
                              widget.confirmTextColor ?? theme.userAccentColor),
                    ),
                  ))),
      ],
    ));

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.size!().cardBorderRadius),
          topRight: Radius.circular(theme.size!().cardBorderRadius)),
      child: Container(
          width: double.infinity,
          color: theme.dialogBackgroundColor,
          constraints: BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _children,
          )),
    );
  }
}

class _ActionsheetScope extends InheritedWidget {
  final _ActionSheetState state;

  const _ActionsheetScope({required super.child, required this.state});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class ActionSheetItem extends StatefulWidget {
  final String text;
  final bool? checked;
  final bool? checkable;
  final void Function(BuildContext context)? onTap;
  final LeouiBrightness? brightness;
  final bool? border;
  final bool? disable;
  final dynamic payload;

  const ActionSheetItem(
      {super.key,
      required this.text,
      this.checked,
      this.onTap,
      this.brightness = LeouiBrightness.light,
      this.checkable = false,
      this.border = true,
      this.disable = false,
      this.payload});

  @override
  State<ActionSheetItem> createState() => _ActionSheetItemState();
}

class _ActionSheetItemState extends State<ActionSheetItem> {
  late bool toggle;

  @override
  initState() {
    toggle = widget.checked ?? false;
    Future.microtask(() {
      _ActionSheetState.of(context)?.add(this);
    });
    super.initState();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap?.call(context);
    }
    if (widget.checkable == true) {
      setState(() {
        toggle = !toggle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(LeoFeedback.currentContext!)!
        .theme(brightness: widget.brightness);

    double dividerHeight = 0.6;

    return buildButtonWidget(
        splashColor: theme.opaqueSeparatorColor,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: theme.size!().itemExtend / 2),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: theme.size!().itemExtend / 2),
                          height: theme.size!().buttonNormalHeight,
                          child: ScalableText(
                            widget.text,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            style: TextStyle(
                                color: widget.disable == true
                                    ? theme.labelSecondaryColor
                                    : theme.labelPrimaryColor,
                                fontSize: theme.size!().content),
                          ))),
                  if (widget.checked != null || widget.checkable == true)
                    Icon(
                      toggle
                          ? Icons.check_circle_outlined
                          : Icons.circle_outlined,
                      color: widget.disable == true
                          ? theme.labelSecondaryColor
                          : theme.userAccentColor,
                      size: theme.size!().content * 1.2,
                    ),
                ],
              ),
              Container(
                  height: dividerHeight,
                  color: widget.border == true
                      ? theme.opaqueSeparatorColor
                      : Colors.transparent),
            ],
          ),
        ),
        onTap: widget.disable != true &&
                (widget.checkable == true || widget.onTap != null)
            ? _handleTap
            : null);
  }

  @override
  void deactivate() {
    _ActionSheetState.of(context)?.remove(this);
    super.deactivate();
  }
}
