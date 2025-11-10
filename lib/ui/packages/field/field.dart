import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';

enum FieldValidateErrorMessageType { warningMessage, warningToast, toast, none }

class Field extends StatefulWidget {
  ///标题
  final Widget? title;

  ///描述内容
  final Widget? brief;

  ///页脚内容
  final Widget? footer;

  ///是否禁用区域
  final bool? disabled;

  ///镂空样式
  final bool? plain;

  ///标题尾部内容
  final Widget? trailing;

  ///背景颜色 [plain:true]
  final Color? color;

  ///分割线颜色
  final Color? dividerColor;

  /// 分割线左右边距
  final double? dividerHorizontalMargin;

  /// 主题色
  final LeouiBrightness? brightness;

  /// 表单校验失败后提示类型
  final FieldValidateErrorMessageType? messageType;
  final EdgeInsets? margin;

  ///  FieldItem
  final List<Widget>? children;
  const Field({
    Key? key,
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
    this.messageType = FieldValidateErrorMessageType.warningMessage,
  }) : super(key: key);

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

  /// return error message, empty --> [true]
  String validate() {
    if (listItemSet.length == 0) return "";

    String validateCallBack = '';
    for (var itemState in listItemSet) {
      validateCallBack = itemState.validate();
      if (validateCallBack.isNotEmpty) {
        if (widget.messageType != FieldValidateErrorMessageType.none) {
          switch (widget.messageType) {
            case FieldValidateErrorMessageType.warningMessage:
              showMessage(validateCallBack, type: MessageType.warning);
              break;
            case FieldValidateErrorMessageType.toast:
              showToast(validateCallBack);
              break;
            case FieldValidateErrorMessageType.warningToast:
              showToast(validateCallBack, type: ToastType.warning);
              break;
            case FieldValidateErrorMessageType.none:
            case null:
          }
        }
        break;
      }
    }

    return validateCallBack;
  }

  Map<String, dynamic> obtainDataMap() {
    if (listItemSet.length == 0) return {};
    var param = <String, dynamic>{};

    for (var item in listItemSet) {
      String? parentKey = item.parentKey;
      Map<String, String> itemData = item.obtainData()!;
      if (parentKey != null) {
        if (param.containsKey(parentKey)) {
          (param[parentKey] as Map).addAll(itemData);
        } else {
          param[parentKey] = itemData;
        }
      } else {
        param.addAll(itemData);
      }
    }

    return param;
  }

  void reset() {
    if (listItemSet.length == 0) return;

    for (var item in listItemSet) {
      item.reset();
    }
  }

  Widget _buildHeader(LeouiThemeData theme) {
    List<Widget> children = [];

    List<Widget> preffix = [];
    if (widget.title != null) {
      preffix.add(Flexible(
        child: DefaultTextIconStyle(
          color: theme.labelPrimaryColor,
          child: widget.title!,
          size: theme.size!().title,
        ),
      ));
    }

    if (widget.brief != null) {
      preffix.add(DefaultTextIconStyle(
        color: theme.labelSecondaryColor,
        child: widget.brief!,
        size: theme.size!().secondary,
      ));
    }

    if (preffix.length > 0) {
      children.add(
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: preffix,
        )),
      );
    }

    if (widget.trailing != null) {
      children.add(DefaultTextIconStyle(
          color: theme.labelTertiaryColor,
          child: widget.trailing!,
          size: theme.size!().tertiary));
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
          (widget.children![i] as ListItem).child == null &&
          (widget.children![i + 1] is ListItem)) {
        _children.add(Container(
          height: 0.6,
          margin: EdgeInsets.symmetric(
              horizontal: widget.dividerHorizontalMargin ?? 0),
          color: widget.dividerColor ?? theme.nonOpaqueSeparatorColor,
        ));
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
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
    LeouiThemeData theme =
        LeouiTheme.of(context)!.theme(brightness: widget.brightness);

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
        padding: EdgeInsets.only(top: 10),
        child: DefaultTextIconStyle(
          color: theme.labelTertiaryColor,
          child: widget.footer,
          size: theme.size!().tertiary,
        ),
      ));
    }

    Widget child = Container(
      margin: widget.margin,
      padding: widget.plain == true ? EdgeInsets.zero : EdgeInsets.all(18),
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
  void reset();
  String? get parentKey;
}

class FieldItem extends StatefulWidget implements ListItem {
  //标题
  final Widget? title;

  //描述内容
  final Widget? content;

  ///附加文案
  final Widget? addon;

  ///提示文本
  final Widget? placeholder;

  /// 是否禁用项目
  final bool? disabled;

  ///动作箭头标识
  final bool? arrow;

  final double? arrowSize;

  ///内容内边距
  final EdgeInsets? padding;

  ///是否固定标题宽度，超出会自动换行
  final bool solid;
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
      this.arrowSize,
      this.padding,
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
      margin: EdgeInsets.only(right: 5),
      width: widget.solid ? theme.size!().title * 5 : null,
      child: DefaultTextIconStyle(
        color: theme.labelPrimaryColor,
        child: widget.title!,
        size: theme.size!().title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme =
        LeouiTheme.of(context)!.theme(brightness: widget.brightness);

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
        size: theme.size!().content,
      )));
    }

    if (widget.placeholder != null) {
      _children.add(Expanded(
          child: DefaultTextIconStyle(
        color: theme.labelSecondaryColor,
        child: widget.placeholder,
        size: theme.size!().content,
      )));
    }

    if (widget.addon != null) {
      _children.add(Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: DefaultTextIconStyle(
            color: theme.labelSecondaryColor,
            child: widget.addon,
            size: theme.size!().secondary,
          ),
        ),
      ));
    }

    if (widget.arrow == true) {
      _children.add(Padding(
        padding: EdgeInsets.only(left: widget.addon != null ? 0 : 5),
        child: Icon(Icons.keyboard_arrow_right_rounded,
            color: theme.labelSecondaryColor,
            size: widget.arrowSize ?? theme.size!().title * 1.5),
      ));
    }

    if (widget.child != null) {
      List<Widget> _colChildren = [];

      _colChildren.add(
        buildButtonWidget(
          splashColor: theme.fillPrimaryColor,
          onTap: (widget.disabled == true || widget.onTap == null)
              ? null
              : () {
                  widget.onTap!(context);
                },
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.padding?.left ?? theme.size!().listItemPadding.left,
              right:
                  widget.padding?.right ?? theme.size!().listItemPadding.right,
              top: widget.padding?.top ?? theme.size!().listItemPadding.top,
              bottom: widget.padding?.bottom ??
                  theme.size!().listItemPadding.bottom,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: _children,
            ),
          ),
        ),
      );

      _colChildren.add(Container(
        margin: EdgeInsets.only(bottom: theme.size!().title / 2),
        height: 1,
        color: Field.of(context)?.widget.dividerColor ??
            theme.nonOpaqueSeparatorColor,
      ));

      _colChildren.add(widget.child!);

      return Container(
        // padding: EdgeInsets.only(
        //   left: widget.padding?.left ?? theme.size!().listItemPadding.left,
        //   right: widget.padding?.right ?? theme.size!().listItemPadding.right,
        //   top: widget.padding?.top ?? theme.size!().listItemPadding.top,
        //   bottom:
        //       widget.padding?.bottom ?? theme.size!().listItemPadding.bottom,
        // ),
        constraints: BoxConstraints(minHeight: theme.size!().itemExtend),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _colChildren,
        ),
      );
    } else {
      return buildButtonWidget(
        splashColor: theme.fillPrimaryColor,
        onTap: (widget.disabled == true || widget.onTap == null)
            ? null
            : () {
                widget.onTap?.call(context);
              },
        child: Container(
          padding: EdgeInsets.only(
            left: widget.padding?.left ?? theme.size!().listItemPadding.left,
            right: widget.padding?.right ?? theme.size!().listItemPadding.right,
            top: widget.padding?.top ?? theme.size!().listItemPadding.top,
            bottom:
                widget.padding?.bottom ?? theme.size!().listItemPadding.bottom,
          ),
          decoration: widget.border == true
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: widget.borderColor ??
                              theme.nonOpaqueSeparatorColor)))
              : null,
          constraints: BoxConstraints(minHeight: theme.size!().itemExtend),
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
