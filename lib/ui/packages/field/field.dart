import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';

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
  final double? dividerHorizontalMargin; // 分割线左右边距
  final LeouiBrightness? brightness; // 主题色
  final FieldValidateErrorMessageType? messageType; // 表单校验失败后提示类型
  final EdgeInsets? margin;

  final List<Widget>? children; //  FieldItem
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
      this.dividerHorizontalMargin,
      this.brightness,
      this.margin,
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
        size: sz(theme.size!().title),
      ));
    }

    if (widget.brief != null) {
      preffix.add(DefaultTextIconStyle(
        color: theme.labelSecondaryColor,
        child: widget.brief!,
        size: sz(theme.size!().secondary),
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
          (widget.children![i] is ListItem) &&
          (widget.children![i] as ListItem).child == null) {
        _children.add(Container(
          height: 0.6,
          margin: EdgeInsets.symmetric(
              horizontal: widget.dividerHorizontalMargin ?? 0),
          color: widget.dividerColor ?? theme.nonOpaqueSeparatorColor,
        ));
      }
    }
    return Column(
      children: _children,
    );
  }

  void blurAll() {
    if (listItemSet.length == 0) return;

    for (var itemState in listItemSet) {
      itemState.blur();
    }
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = widget.brightness == null
        ? LeouiTheme.of(context)
        : LeouiThemeData(brightness: widget.brightness);

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
          height: 0.6, color: widget.color ?? theme.nonOpaqueSeparatorColor));
      _children.add(Padding(
        padding: EdgeInsets.only(top: sz(10)),
        child: DefaultTextIconStyle(
          color: theme.labelTertiaryColor,
          child: widget.footer,
          size: sz(theme.size!().tertiary),
        ),
      ));
    }

    Widget child = Container(
      margin: widget.margin,
      padding: widget.plain == true ? EdgeInsets.zero : EdgeInsets.all(sz(18)),
      decoration: BoxDecoration(
          color: widget.plain == true
              ? null
              : widget.color ?? theme.backgroundTertiaryColor,
          borderRadius: BorderRadius.circular(theme.size!().cardBorderRadius)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
  void blur();
  void focus();
}

class FieldItem extends StatefulWidget implements ListItem {
  final Widget? title; //标题
  final Widget? content; //描述内容
  final Widget? addon; //附加文案
  final Widget? placeholder; //提示文本
  final bool? disabled; // 是否禁用项目
  final bool? arrow; //动作箭头标识
  final double? verticalPadding; // 内容竖直间距
  final double? horizontalPadding; //内容横向间距
  final bool solid; //是否固定标题宽度，超出会自动换行
  final ValueChanged<BuildContext>? onTap; // 点击回调
  final Widget? child; // 子组件
  final LeouiBrightness? brightness;
  final VoidCallback? onDispose;
  final bool? border;
  final Color? borderColor;

  const FieldItem(
      {Key? key,
      this.title,
      this.content,
      this.addon,
      this.disabled,
      this.arrow,
      this.verticalPadding,
      this.horizontalPadding,
      this.solid = true,
      this.onTap,
      this.child,
      this.brightness,
      this.placeholder,
      this.onDispose,
      this.border,
      this.borderColor})
      : assert(content == null || placeholder == null,
            'can not provice both \'content\' and \'placeholder\''),
        super(key: key);

  @override
  State<FieldItem> createState() => _FieldItemState();

  @override
  String? get itemKey => null;

  @override
  String? get itemLabel => null;
}

class _FieldItemState extends State<FieldItem> {
  Widget _buildTitle(LeouiThemeData theme) {
    return Container(
      margin: EdgeInsets.only(right: sz(5)),
      width: widget.solid ? sz(80) : null,
      child: DefaultTextIconStyle(
        color: theme.labelPrimaryColor,
        child: widget.title!,
        size: sz(theme.size!().title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = widget.brightness != null
        ? LeouiThemeData(brightness: widget.brightness)
        : LeouiTheme.of(context);

    List<Widget> _children = [];
    if (widget.title != null) {
      _children.add(_buildTitle(theme));
    }

    if (widget.content != null) {
      _children.add(Expanded(
          child: DefaultTextIconStyle(
        color: widget.disabled == true
            ? theme.labelSecondaryColor
            : theme.labelPrimaryColor,
        child: widget.content,
        fontWeight: FontWeight.w500,
        size: sz(theme.size!().content),
      )));
    }

    if (widget.placeholder != null) {
      _children.add(Expanded(
          flex: 2,
          child: DefaultTextIconStyle(
            color: theme.labelSecondaryColor,
            child: widget.placeholder,
            size: sz(theme.size!().content),
          )));
    }

    if (widget.addon != null) {
      _children.add(Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: sz(5)),
          child: DefaultTextIconStyle(
            color: theme.labelSecondaryColor,
            child: widget.addon,
            size: sz(theme.size!().secondary),
          ),
        ),
      ));
    }

    if (widget.arrow == true) {
      _children.add(Padding(
        padding: EdgeInsets.only(left: sz(5)),
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: theme.labelSecondaryColor,
        ),
      ));
    }

    if (widget.child != null) {
      List<Widget> _colChildren = [];

      _colChildren.add(
        buildButtonWidget(
          splashColor: theme.fillPrimaryColor,
          onPress: (widget.disabled == true || widget.onTap == null)
              ? null
              : () {
                  widget.onTap!(context);
                },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? sz(15),
                horizontal: widget.horizontalPadding ?? 0),
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
        color: Field.of(context)?.widget.dividerColor ??
            theme.nonOpaqueSeparatorColor,
      ));

      _colChildren.add(widget.child!);

      return Container(
        padding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding ?? 0,
            horizontal: widget.horizontalPadding ?? 0),
        constraints: BoxConstraints(minHeight: theme.size!().itemExtent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _colChildren,
        ),
      );
    } else {
      return buildButtonWidget(
        splashColor: theme.fillPrimaryColor,
        onPress: (widget.disabled == true || widget.onTap == null)
            ? null
            : () {
                widget.onTap?.call(context);
              },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding ?? 0,
              horizontal: widget.horizontalPadding ?? 0),
          decoration: widget.border == true
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: widget.borderColor ??
                              theme.nonOpaqueSeparatorColor)))
              : null,
          constraints: BoxConstraints(minHeight: theme.size!().itemExtent),
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
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    super.dispose();
  }
}
