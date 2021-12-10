import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/ui/index.dart';
import 'package:leoui/ui/packages/common/common.dart';
import 'package:leoui/utils/index.dart';

class InputItem extends StatefulWidget implements ListItem {
  final String? title; //标题
  final Icon? icon; //leading icon
  final Widget? leading; //leading 与tile和icon互斥
  final String? defaultValue; //默认值
  final int? maxLength; //最大输入字数长度
  final Widget? content; //描述内容
  final TextInputType? inputType; // 输入类型
  final TextInputAction? inputAction; //键盘类型
  final Widget? addon; //附加文案
  final String? placeholder; //提示文本
  final bool disabled; // 是否禁用项目
  final double? verticalPadding; // 内容竖直间距
  final bool solid; //是否固定标题宽度，超出会自动换行
  final bool clearable; //表单是否使用清除控件
  final bool readonly; // 只读
  final TextAlign textAlign; // 文字对齐方式
  final bool obscureText; // 加密文字
  final ValueChanged<String>? onChanged; // 输入框change时回调
  final ValueChanged<String>? onFocus; //输入框聚焦时回调
  final ValueChanged<String>? onBlur; //输入框聚失焦时回调
  final ValueChanged<String>? onSubmit; //输入框聚失焦时回调
  final RegExp? validatePattern; // 表单校验码规则 --> RegExp(r'^[a-z][a-z\d]{3,}$')
  final String? patternDescript; // 表单正确格式描述 --> 小写字母开头，包含数字，不小于3位
  final String? fieldKey; // 用于Field导出数据的key --> {'username':'kim'}
  final String? fieldLabel; // 用于校验输入提示 -->'(用户名)不能为空'
  final LeouiBrightness? brightness; // 主题 dark 、light
  final double? fontSize;

  const InputItem({
    Key? key,
    this.title,
    this.icon,
    this.leading,
    this.content,
    this.defaultValue,
    this.addon,
    this.placeholder,
    this.disabled = false,
    this.verticalPadding,
    this.solid = true,
    this.inputType = TextInputType.text,
    this.inputAction,
    this.clearable = true,
    this.readonly = false,
    this.textAlign = TextAlign.left,
    this.obscureText = false,
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.onSubmit,
    this.validatePattern,
    this.maxLength,
    this.fieldKey,
    this.fieldLabel,
    this.patternDescript,
    this.brightness,
    this.fontSize,
  })  : assert(
            validatePattern == null || (fieldKey != null && fieldLabel != null),
            'when validatePattern is not null then fieldKey and fieldLable must be provided'),
        assert(leading == null || (title == null && icon == null),
            'can not provide both leading and (title or icon)'),
        super(key: key);

  @override
  InputItemState createState() => InputItemState();

  @override
  Widget? get child => null;

  @override
  String? get itemKey => fieldKey;

  @override
  String? get itemLabel => fieldLabel;
}

class InputItemState extends State<InputItem> implements ListItemState {
  FocusNode focusNode = FocusNode();

  bool showCloseButton = false;

  String value = '';

  TextEditingController _controller = TextEditingController();

  bool valid = true;

  String blur() {
    focusNode.unfocus();
    return value;
  }

  String focus() {
    focusNode.requestFocus();
    return value;
  }

  void clear() {
    _controller.value = TextEditingValue.empty;
    value = '';
    setState(() {
      showCloseButton = false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      _controller.value = TextEditingValue(text: widget.defaultValue!);
      value = widget.defaultValue!;
      showCloseButton = value.isNotEmpty;
    }

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (widget.onFocus != null) {
          widget.onFocus!(value);
        }
      } else {
        if (widget.onBlur != null) {
          widget.onBlur!(value);
        }
      }
    });
  }

  Widget _buildLeading(LeouiThemeData theme) {
    Widget? child;
    if (widget.leading != null) {
      child = widget.leading;
    } else {
      List<Widget> children = [];
      if (widget.icon != null) children.add(widget.icon!);
      if (widget.title != null)
        children.add(Flexible(child: Text(widget.title!)));

      if (children.length == 2) {
        children.insert(
            1,
            SizedBox(
              width: sz(5),
            ));
      }

      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
    return Container(
      margin: EdgeInsets.only(right: sz(5)),
      width: widget.solid ? sz(80) : null,
      child: DefaultTextIconStyle(
        color: valid ? theme.labelPrimaryColor : theme.baseRedColor,
        child: child,
        size: widget.fontSize ?? sz(theme.size.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = widget.brightness == null
        ? LeouiTheme.of(context)
        : LeouiThemeData(brightness: widget.brightness);

    List<Widget> rowChildren = [];

    if (widget.title != null || widget.icon != null || widget.leading != null) {
      rowChildren.add(_buildLeading(theme));
    }

    rowChildren.add(Expanded(
        child: TextField(
      enabled: !widget.disabled,
      controller: _controller,
      readOnly: widget.readonly,
      maxLength: widget.maxLength,
      focusNode: focusNode,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      onSubmitted: widget.onSubmit,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      onChanged: (String input) {
        value = input;
        if (showCloseButton != input.isNotEmpty) {
          setState(() {
            showCloseButton = input.isNotEmpty;
          });
        }
        if (widget.onChanged != null) {
          widget.onChanged!(input);
        }
      },
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.placeholder,
          hintStyle: TextStyle(
              color: theme.labelSecondaryColor,
              fontSize: widget.fontSize != null
                  ? widget.fontSize!
                  : sz(theme.size.title)),
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 0)),
      style: TextStyle(
        color: widget.disabled == true
            ? theme.labelSecondaryColor
            : theme.labelPrimaryColor,
        fontWeight: FontWeight.w500,
        fontSize:
            widget.fontSize != null ? widget.fontSize! : sz(theme.size.content),
      ),
    )));

    if (widget.clearable && showCloseButton) {
      rowChildren.add(Padding(
        padding: EdgeInsets.only(left: sz(5)),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: widget.fontSize != null
                    ? widget.fontSize! / 2
                    : sz(theme.size.title / 2)),
            height: sz(theme.size.itemExtent),
            child: Icon(
              Icons.cancel,
              size: widget.fontSize != null
                  ? widget.fontSize! * 1.5
                  : sz(theme.size.title * 1.5),
              color: theme.userAccentColor,
            ),
          ),
          onTap: clear,
        ),
      ));
    }

    if (widget.addon != null) {
      rowChildren.add(Padding(
        padding: EdgeInsets.only(left: sz(5)),
        child: DefaultTextIconStyle(
          color: theme.labelSecondaryColor,
          child: widget.addon,
          size: widget.fontSize != null
              ? widget.fontSize! - 2
              : sz(theme.size.secondary),
        ),
      ));
    }

    Field.of(context)?.add(this);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: sz(theme.size.itemExtent)),
      child: Row(
        children: rowChildren,
      ),
    );
  }

  @override
  void deactivate() {
    Field.of(context)?.remove(this);
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  String validate() {
    String hint = '';
    if (widget.validatePattern != null) {
      if (value.isEmpty) {
        hint = widget.itemLabel! + LeouiLocalization.of(context).emptyHint;
      } else if (!widget.validatePattern!.hasMatch(value)) {
        hint = widget.itemLabel! + LeouiLocalization.of(context).notMathHint;
      }

      if (widget.patternDescript != null && hint.isNotEmpty) {
        hint += '(' + widget.patternDescript! + ')';
      }

      setState(() {
        valid = hint.isEmpty;
      });
    }

    return hint;
  }

  @override
  Map<String, String>? obtainData() {
    String key = 'unknownFieldKey';
    if (widget.itemKey != null) key = widget.itemKey!;
    return {key: value};
  }
}
