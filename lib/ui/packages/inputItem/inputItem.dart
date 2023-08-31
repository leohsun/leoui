import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';

typedef InputItemOnTapCallBack = void Function(
    {required String label, required String value});

class InputItem extends StatefulWidget implements ListItem {
  final Widget? title; //标题
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
  final double? horizontalPadding; //內容水平间距
  final bool solid; //是否固定标题宽度，超出会自动换行
  final bool clearable; //表单是否使用清除控件
  final Widget? clearIconPlaceHolder; // clearable == true时，表单未输入是，占位
  final bool readonly; // 只读
  final TextAlign textAlign; // 文字对齐方式
  final bool obscureText; // 加密文字
  final ValueChanged<String>? onChanged; // 输入框change时回调
  final ValueChanged<String>? onFocus; //输入框聚焦时回调
  final ValueChanged<String>? onBlur; //输入框聚失焦时回调
  final ValueChanged<String>? onSubmit; //输入框聚失焦时回调
  final void Function(InputItemOnTapCallBack, TextEditingController)?
      onTap; //read-only
  final Color? splashColor;
  final RegExp? validatePattern; // 表单校验码规则 --> RegExp(r'^[a-z][a-z\d]{3,}$')
  final String? patternDescript; // 表单正确格式描述 --> 小写字母开头，包含数字，不小于3位
  final String? fieldKey; // 用于Field导出数据的key --> {'username':'kim'}
  final String? fieldLabel; // 用于校验输入提示 -->'(用户名)不能为空'
  final LeouiBrightness? brightness; // 主题 dark 、light
  final double? fontSize;
  final bool focus; //获取焦点
  final bool? hideCounter;
  final int? maxLines;
  final VoidCallback? onDispose;

  const InputItem(
      {Key? key,
      this.title,
      this.icon,
      this.leading,
      this.content,
      this.defaultValue,
      this.addon,
      this.placeholder,
      this.disabled = false,
      this.verticalPadding,
      this.horizontalPadding,
      this.solid = true,
      this.hideCounter,
      this.inputType = TextInputType.text,
      this.inputAction,
      this.clearable = true,
      this.clearIconPlaceHolder,
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
      this.maxLines = 1,
      this.focus = false,
      this.onTap,
      this.splashColor,
      this.onDispose})
      : assert(
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

  TextEditingController _controller = TextEditingController();

  String get value {
    if (widget.onTap == null) {
      return _controller.value.text;
    }
    return _label;
  }

  set value(String input) {
    _controller.value = TextEditingValue(text: input);
  }

  String _label = "";

  void _setMapValue({required String label, required String value}) {
    _label = value;
    _controller.value = TextEditingValue(text: label);
  }

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
  void didUpdateWidget(covariant InputItem oldWidget) {
    // only change the focus status now;
    if (widget.focus == oldWidget.focus) return;
    if (widget.focus) {
      focus();
    } else {
      blur();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      _controller.value = TextEditingValue(text: widget.defaultValue!);
      showCloseButton = value.isNotEmpty;
    }

    if (widget.focus) {
      focusNode.requestFocus();
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
      if (widget.title != null) children.add(Flexible(child: widget.title!));

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
        size: widget.fontSize ?? theme.size!().title,
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

    InputDecoration inputStyle = InputDecoration(
        counterText: widget.hideCounter == true ? '' : null,
        border: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: TextStyle(
            color: theme.labelSecondaryColor,
            fontSize: widget.fontSize != null
                ? widget.fontSize!
                : theme.size!().title),
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 0));

    TextField textField = TextField(
      enabled: !widget.disabled,
      controller: _controller,
      readOnly: widget.readonly || widget.onTap != null,
      maxLength: widget.maxLength,
      focusNode: focusNode,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      onSubmitted: widget.onSubmit,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      onChanged: (String input) {
        // value = input;
        if (showCloseButton != input.isNotEmpty) {
          setState(() {
            showCloseButton = input.isNotEmpty;
          });
        }
        if (widget.onChanged != null) {
          widget.onChanged!(input);
        }
      },
      decoration: inputStyle,
      style: TextStyle(
        color: widget.disabled == true
            ? theme.labelSecondaryColor
            : theme.labelPrimaryColor,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize != null
            ? widget.fontSize!
            : sz(theme.size!().title),
      ),
    );

    rowChildren.add(Expanded(child: textField));

    if (widget.clearable) {
      if (showCloseButton) {
        double b = (widget.maxLength != null && widget.hideCounter != true)
            ? inputStyle.hintStyle?.fontSize ?? 0
            : 0;
        rowChildren.add(Padding(
          padding: EdgeInsets.only(left: 0, bottom: b * 1.3),
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.only(
                  left: widget.fontSize != null
                      ? widget.fontSize! / 4
                      : sz(theme.size!().title / 4)),
              height: widget.fontSize != null
                  ? sz(widget.fontSize! * 2.588)
                  : sz(theme.size!().title * 2.588),
              child: Icon(
                Icons.cancel,
                size: widget.fontSize != null
                    ? widget.fontSize! * 1.5
                    : sz(theme.size!().title * 1.5),
                color: theme.userAccentColor,
              ),
            ),
            onTap: clear,
          ),
        ));
      } else if (widget.clearIconPlaceHolder != null) {
        rowChildren.add(widget.clearIconPlaceHolder!);
      }
    }

    if (widget.addon != null) {
      rowChildren.add(Padding(
        padding: EdgeInsets.only(left: sz(5)),
        child: DefaultTextIconStyle(
          color: theme.labelSecondaryColor,
          child: widget.addon,
          size: widget.fontSize != null
              ? widget.fontSize! - 2
              : sz(theme.size!().title),
        ),
      ));
    }

    Field.of(context)?.add(this);

    final child = Container(
      constraints: BoxConstraints(
          minHeight: widget.fontSize != null
              ? sz(widget.fontSize! * 2.588)
              : sz(theme.size!().title * 2.588)),
      padding: widget.horizontalPadding != null
          ? EdgeInsets.symmetric(horizontal: widget.horizontalPadding!)
          : null,
      child: Row(
        children: rowChildren,
      ),
    );

    if (widget.onTap != null) {
      return buildButtonWidget(
          splashColor: widget.splashColor,
          onPress: () {
            widget.onTap!(_setMapValue, _controller);
          },
          child: Stack(
            children: [
              child,
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              )
            ],
          ));
    }

    return child;
  }

  @override
  void deactivate() {
    focusNode.unfocus();
    Field.of(context)?.remove(this);

    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    super.dispose();
  }

  @override
  String validate() {
    String hint = '';
    if (widget.validatePattern != null) {
      if (value.isEmpty) {
        hint = widget.itemLabel! +
            LeouiLocalization.of(LeoFeedback.currentContext!).emptyHint;
      } else if (!widget.validatePattern!.hasMatch(value)) {
        hint = widget.itemLabel! +
            LeouiLocalization.of(LeoFeedback.currentContext!).notMathHint;
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

  @override
  void reset() {
    clear();
  }
}
