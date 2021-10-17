import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';
import 'package:leoui/utils/index.dart';

enum FieldValidateErrorMessageType { message, toast }

class Field extends StatefulWidget {
  final Widget? title; //标题
  final Widget? brief; //描述内容
  final Widget? footer; //页脚内容
  final bool? disabled; //是否禁用区域
  final bool? plain; //镂空样式
  final Widget? trailing; //标题尾部内容
  final Color? color; //背景颜色
  final Color? dividerColor; //分割线颜色
  final FieldValidateErrorMessageType? messageType; // 表单校验失败后提示类型

  final List<ListItem>? children; //  FieldItem
  const Field(
      {Key? key,
      this.title,
      this.brief,
      this.disabled,
      this.plain,
      this.children,
      this.trailing,
      this.footer,
      this.color,
      this.dividerColor,
      this.messageType = FieldValidateErrorMessageType.message})
      : super(key: key);

  @override
  FieldState createState() => FieldState();

  static FieldState? of(BuildContext context) {
    final _FieldScope? scope =
        context.dependOnInheritedWidgetOfExactType<_FieldScope>();
    return scope?.fieldState;
  }
}

class FieldState extends State<Field> {
  Set<ListItemState> listItemSet = Set();

  void add(ListItemState item) {
    listItemSet.add(item);
  }

  void remove(ListItemState item) {
    listItemSet.remove(item);
  }

  bool validate() {
    if (listItemSet.length == 0) return true;
    bool valid = true;

    for (var itemState in listItemSet) {
      String validateCallBack = itemState.validate();
      if (validateCallBack.isNotEmpty) {
        if (widget.messageType == FieldValidateErrorMessageType.message) {
          showMessage(validateCallBack, type: MessageType.warning);
        } else {
          showToast(validateCallBack, type: ToastType.warning);
        }
        valid = false;
        break;
      }
    }

    return valid;
  }

  Map<String, String> obtainDataMap() {
    if (listItemSet.length == 0) return {};
    var param = <String, String>{};

    for (var item in listItemSet) {
      param.addAll(item.obtainData()!);
    }

    return param;
  }

  Widget _buildHeader(LeouiThemeData theme) {
    List<Widget> children = [];

    List<Widget> preffix = [];
    if (widget.title != null) {
      preffix.add(DefaultTextIconStyle(
        color: theme.labelPrimaryColor,
        child: widget.title!,
        size: sz(LeoSize.fontSize.title),
      ));
    }

    if (widget.brief != null) {
      preffix.add(DefaultTextIconStyle(
        color: theme.labelSecondaryColor,
        child: widget.brief!,
        size: sz(LeoSize.fontSize.secondary),
      ));
    }

    if (preffix.length > 0) {
      children.add(Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: preffix,
        ),
      ));
    }

    if (widget.trailing != null) {
      children.add(widget.trailing!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildChildren(LeouiThemeData theme) {
    List<Widget> _children = [];

    if (widget.children!.length <= 1) {
      return Column(
        children: widget.children!,
      );
    }

    for (int i = 0; i < widget.children!.length; i++) {
      _children.add(widget.children![i]);
      if (i < widget.children!.length - 1 &&
          widget.children![i].child == null) {
        _children.add(Container(
          height: 1,
          color: widget.dividerColor ?? theme.nonOpaqueSeparatorColor,
        ));
      }
    }
    return Column(
      children: _children,
    );
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);

    List<Widget> _children = [];
    if (widget.title != null ||
        widget.brief != null ||
        widget.trailing != null) {
      _children.add(_buildHeader(theme));
    }

    if (widget.children != null) {
      _children.add(_buildChildren(theme));
    }

    if (widget.footer != null) {
      _children.add(Container(
          height: 1, color: widget.color ?? theme.nonOpaqueSeparatorColor));
      _children.add(Padding(
        padding: EdgeInsets.only(top: sz(10)),
        child: DefaultTextIconStyle(
          color: theme.labelTertiaryColor,
          child: widget.footer,
          size: sz(LeoSize.fontSize.tertiary),
        ),
      ));
    }

    Widget child = Container(
      padding: widget.plain == true ? EdgeInsets.zero : EdgeInsets.all(sz(18)),
      decoration: BoxDecoration(
          color: widget.plain == true
              ? null
              : widget.color ?? theme.backgroundTertiaryColor,
          borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      ),
    );

    return _FieldScope(
      fieldState: this,
      child: child,
    );
  }
}

class _FieldScope extends InheritedWidget {
  final FieldState fieldState;
  final Widget child;

  _FieldScope({required this.fieldState, required this.child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant _FieldScope oldWidget) =>
      false; // no needs to notifying child, becase FieldState.listItemSet`s add or remove actions only trigger by listItem
}

abstract class ListItem extends Widget {
  final Widget? child; // 子组件
  final String? itemLabel;
  final String? itemKey;

  ListItem(this.child, this.itemLabel, this.itemKey);
}

abstract class ListItemState {
  String validate();
  Map<String, String>? obtainData();
}

class FieldItem extends StatelessWidget implements ListItem {
  final Widget? title; //标题
  final Widget? content; //描述内容
  final Widget? addon; //附加文案
  final Widget? placeholder; //提示文本
  final bool? disabled; // 是否禁用项目
  final bool? arrow; //动作箭头标识
  final double? verticalPadding; // 内容竖直间距
  final bool solid; //是否固定标题宽度，超出会自动换行
  final VoidCallback? onTap; // 点击回调
  final Widget? child; // 子组件

  const FieldItem(
      {Key? key,
      this.title,
      this.content,
      this.addon,
      this.disabled,
      this.arrow,
      this.verticalPadding,
      this.solid = true,
      this.onTap,
      this.child,
      this.placeholder})
      : assert(content == null || placeholder == null,
            'can not provice both \'content\' and \'placeholder\''),
        super(key: key);

  Widget _buildTitle(LeouiThemeData theme) {
    return Container(
      margin: EdgeInsets.only(right: sz(5)),
      width: solid ? sz(80) : null,
      child: DefaultTextIconStyle(
        color: theme.labelPrimaryColor,
        child: title!,
        size: sz(LeoSize.fontSize.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);

    List<Widget> _children = [];
    if (title != null) {
      _children.add(_buildTitle(theme));
    }

    if (content != null) {
      _children.add(Expanded(
          child: DefaultTextIconStyle(
        color: disabled == true
            ? theme.labelSecondaryColor
            : theme.labelPrimaryColor,
        child: content,
        fontWeight: FontWeight.w500,
        size: sz(LeoSize.fontSize.content),
      )));
    }

    if (placeholder != null) {
      _children.add(Expanded(
          flex: 2,
          child: DefaultTextIconStyle(
            color: theme.labelSecondaryColor,
            child: placeholder,
            size: sz(LeoSize.fontSize.content),
          )));
    }

    if (addon != null) {
      _children.add(Padding(
        padding: EdgeInsets.only(left: sz(5)),
        child: DefaultTextIconStyle(
          color: theme.labelSecondaryColor,
          child: addon,
          size: sz(LeoSize.fontSize.secondary),
        ),
      ));
    }

    if (arrow == true) {
      _children.add(Padding(
        padding: EdgeInsets.only(left: sz(5)),
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: theme.labelSecondaryColor,
        ),
      ));
    }

    if (child != null) {
      List<Widget> _colChildren = [];

      _colChildren.add(
        buildButtonWidget(
          splashColor: theme.fillPrimaryColor,
          onPress: disabled == true ? null : onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: sz(verticalPadding ?? 15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: _children,
            ),
          ),
        ),
      );

      _colChildren.add(Container(
        margin: EdgeInsets.only(bottom: sz(10)),
        height: 1,
        color: theme.nonOpaqueSeparatorColor,
      ));

      _colChildren.add(child!);

      return Container(
        padding: EdgeInsets.symmetric(vertical: sz(verticalPadding ?? 0)),
        constraints: BoxConstraints(minHeight: sz(LeoSize.itemExtent)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _colChildren,
        ),
      );
    } else {
      return buildButtonWidget(
        splashColor: theme.fillPrimaryColor,
        onPress: disabled == true ? null : onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: sz(verticalPadding ?? 0)),
          constraints: BoxConstraints(minHeight: sz(LeoSize.itemExtent)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: _children,
          ),
        ),
      );
    }
  }

  @override
  String? get itemKey => null;

  @override
  String? get itemLabel => null;
}
