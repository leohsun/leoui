import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/packages/common/common.dart';
import 'package:leoui/widget/friendly_tap_container.dart';
import 'package:leoui/widget/global_tap_detector.dart';

class MapValue {
  final String label;
  final String value;

  const MapValue({required this.label, required this.value});

  factory MapValue.fromJson(Map json) {
    return MapValue(label: json['label'], value: json['value']);
  }

  factory MapValue.empty() {
    return MapValue(label: "", value: "");
  }

  static MapValue? mybeNull({String? label, String? value}) {
    if (label != null &&
        label.isNotEmpty &&
        value != null &&
        value.isNotEmpty) {
      return MapValue(label: label, value: value);
    } else
      return null;
  }

  @override
  String toString() {
    return "{label: $label, value: $value}";
  }
}

typedef InputItemOnTapCallBack = void Function(MapValue data);

enum InputCustomLabelPlacement { original, newLine }

class InputItem extends StatefulWidget implements ListItem {
  ///标题
  final Widget? title;

  ///leading icon
  final Icon? icon;

  ///leading 与tile和icon互斥
  final Widget? leading;

  ///默认值
  final String? defaultValue;

  /// 默认值，read-only时
  final MapValue? defaultMapValue;

  /// 双向绑定
  final bool? bindValue;

  ///最大输入字数长度
  final int? maxLength;

  /// 输入类型
  final TextInputType? inputType;

  ///键盘类型
  final TextInputAction? inputAction;

  ///附加文案
  final Widget? addon;

  ///附加文案构造函数，可通过函数回参来控制[InputItemState]
  final Widget Function(InputItemState)? addonBuilder;

  ///提示文本
  final String? placeholder;

  ///提示文本颜色
  final Color? placeholderColor;
  final bool disabled; // 是否禁用项目
  ///内边距
  final EdgeInsets? padding;

  ///是否固定标题宽度，超出会自动换行
  final bool solid;

  ///表单是否使用清除控件
  final bool clearable;

  /// clearable == true时，表单未输入时，占位
  final Widget? clearIconPlaceHolder;

  /// 只读
  final bool readonly;

  /// 文字对齐方式
  final TextAlign textAlign;
  final bool obscureText; // 加密文字
  final ValueChanged<String>? onChanged; // 输入框change时回调
  final ValueChanged<String>? onFocus; //输入框聚焦时回调
  final ValueChanged<String>? onBlur; //输入框聚失焦时回调
  final ValueChanged<String>? onSubmit; //输入框聚失焦时回调
  ///只读时，点击回调事件，可用通过函数回参[InputItemOnTapCallBack], [TextEditingController], [MapValue]来做相应的逻辑操作
  final void Function(
      InputItemOnTapCallBack inputItemOnTapCallBack,
      TextEditingController textEditingController,
      MapValue mapValue)? onTap; //read-only
  final Color? splashColor;

  /// 表单校验码规则 --> RegExp(r'^[a-z][a-z\d]{3,}$')
  final RegExp? validatePattern;

  /// 表单正确格式描述 --> 小写字母开头，包含数字，不小于3位
  final String? patternDescript;

  /// 用于Field导出数据的key --> {'username':'kim'}
  final String? fieldKey;

  /// 用于校验输入提示 -->'(用户名)不能为空'
  final String? fieldLabel;

  /// 用于Field导出数据时合并的key
  ///
  ///  InputItem(fieldKey: 'color',parentKey: "apple",),
  ///
  /// InputItem(fieldKey: 'size',parentKey: "apple",)
  ///
  /// ---> {'apple':{'color','red','size':'middle'}}
  final String? parentKey;

  /// 主题 dark 、light
  final LeouiBrightness? brightness;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool focus; //获取焦点
  final bool? hideCounter;
  final int? maxLines;
  final VoidCallback? onDispose;
  final bool? arrow;
  final bool? hideTextField;

  /// 客制化Value的显示 [readonly] = true
  final Widget Function(String value, String? label)? labelBuilder;

  /// 客制化Value显示位置
  final InputCustomLabelPlacement? customLabelPlacement;

  const InputItem(
      {Key? key,
      this.title,
      this.icon,
      this.leading,
      this.defaultValue,
      this.bindValue,
      this.addon,
      this.addonBuilder,
      this.placeholder,
      this.placeholderColor,
      this.disabled = false,
      this.padding,
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
      this.parentKey,
      this.fieldLabel,
      this.patternDescript,
      this.brightness,
      this.fontSize,
      this.fontWeight,
      this.maxLines = 1,
      this.focus = false,
      this.onTap,
      this.splashColor,
      this.onDispose,
      this.arrow,
      this.defaultMapValue,
      this.labelBuilder,
      this.customLabelPlacement = InputCustomLabelPlacement.original,
      this.hideTextField = false})
      : assert(
            validatePattern == null || (fieldKey != null && fieldLabel != null),
            'when [validatePattern] is not null then [fieldKey] and [fieldLable] must be provided'),
        assert(leading == null || (title == null && icon == null),
            'can not provide both [leading] and (title or icon)'),
        assert(defaultValue == null || defaultMapValue == null,
            'can not provide both [defaultValue] and [defaultMapValue]'),
        assert(addon == null || addonBuilder == null,
            'can not provide both [addon] and [addonBuilder]'),
        assert(labelBuilder == null || readonly == true,
            "[labelBuilder] only work when [readonly] is [true]"),
        assert(parentKey == null || fieldKey != null,
            "when [parentKey] is not null, the [fieldKey] must be provided"),
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

  Size leadingSize = Size.zero;

  TextEditingController _controller = TextEditingController();

  String get value {
    return _label.isNotEmpty ? _label : _controller.value.text;
  }

  set value(String input) {
    _controller.value = TextEditingValue(text: input);
  }

  String _label = "";

  void _setMapValue(MapValue data) {
    _label = data.value;
    _controller.value = TextEditingValue(text: data.label);
  }

  MapValue get _mapValue {
    return MapValue(label: value, value: _label);
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

  Widget? customLabel;

  @override
  void didUpdateWidget(covariant InputItem oldWidget) {
    if (widget.focus != oldWidget.focus) {
      if (widget.focus) {
        focus();
      } else {
        blur();
      }
    }

    if (widget.bindValue != true) return;

    if (widget.defaultMapValue != null &&
        '$_mapValue' != '${widget.defaultMapValue}') {
      _setMapValue(widget.defaultMapValue != null
          ? widget.defaultMapValue!
          : MapValue.empty());
    }

    if (widget.defaultValue != null && value != widget.defaultValue) {
      value = widget.defaultValue ?? "";
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    if (widget.labelBuilder != null) {
      _controller.addListener(() {
        setState(() {
          customLabel = widget.labelBuilder!(
              value, _label.isNotEmpty ? _controller.text : null);
        });
      });
    }

    if (widget.defaultValue != null) {
      _controller.value = TextEditingValue(text: widget.defaultValue!);
      showCloseButton = value.isNotEmpty;
    } else if (widget.defaultMapValue != null) {
      _setMapValue(widget.defaultMapValue!);
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

    Future.microtask(() {
      Field.of(context)?.add(this);
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
              width: 5,
            ));
      }

      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    final leading = Container(
      margin: EdgeInsets.only(right: 5),
      width: widget.solid ? (widget.fontSize ?? theme.size!().title) * 5 : null,
      child: DefaultTextIconStyle(
        color: valid ? theme.labelPrimaryColor : theme.baseRedColor,
        child: child,
        size: widget.fontSize ?? theme.size!().title,
      ),
    );

    leadingSize = measureWidget(leading);

    return leading;
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme =
        LeouiTheme.of(context)!.theme(brightness: widget.brightness);

    List<Widget> rowChildren = [];

    if (widget.title != null || widget.icon != null || widget.leading != null) {
      rowChildren.add(_buildLeading(theme));
    }

    InputDecoration inputStyle = InputDecoration(
        counterText: widget.hideCounter == true ? '' : null,
        border: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: TextStyle(
            color: widget.placeholderColor ?? theme.labelSecondaryColor,
            height: 1,
            fontSize: widget.fontSize != null
                ? widget.fontSize!
                : theme.size!().title),
        isDense: true);

    Widget textField = TextField(
      enabled: !widget.disabled,
      onTapOutside: (event) {
        blur();
      },
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
      strutStyle: StrutStyle(leading: 0, height: 1),
      decoration: inputStyle,
      cursorColor: theme.userAccentColor,
      cursorHeight: theme.size!().content,
      style: TextStyle(
          color: theme.labelPrimaryColor,
          fontSize: widget.fontSize ?? theme.size!().content,
          height: 1),
    );

    if (widget.labelBuilder != null &&
        customLabel != null &&
        widget.customLabelPlacement == InputCustomLabelPlacement.original) {
      textField = Column(children: [
        customLabel!,
        Offstage(
          child: textField,
        )
      ]);
    } else if (widget.hideTextField == true) {
      textField = Offstage(child: textField);
    }

    rowChildren.add(Expanded(child: textField));

    if (widget.clearable) {
      if (showCloseButton && widget.hideTextField != true) {
        rowChildren.add(FriendlyTapContainer(
            onTap: clear,
            child: Icon(
              Icons.cancel,
              size: widget.fontSize != null
                  ? widget.fontSize! * 1.2
                  : theme.size!().title * 1.2,
              color: theme.userAccentColor,
            )));
      } else if (widget.clearIconPlaceHolder != null) {
        rowChildren.add(widget.clearIconPlaceHolder!);
      }
    }

    if (widget.addon != null || widget.addonBuilder != null) {
      rowChildren.add(Padding(
        padding: EdgeInsets.only(left: 5),
        child: DefaultTextIconStyle(
          color: theme.labelSecondaryColor,
          child:
              widget.addon != null ? widget.addon : widget.addonBuilder!(this),
          size: widget.fontSize != null
              ? widget.fontSize! - 2
              : theme.size!().title,
        ),
      ));
    }

    if (widget.arrow == true) {
      rowChildren.add(Padding(
        padding: EdgeInsets.only(left: widget.addon != null ? 0 : 5),
        child: Icon(Icons.keyboard_arrow_right_rounded,
            color: theme.labelSecondaryColor, size: theme.size!().title * 1.5),
      ));
    }

    final itemPadding = widget.padding ?? theme.size!().listItemPadding;

    Widget child = Row(
      children: rowChildren,
    );

    if (widget.labelBuilder != null &&
        customLabel != null &&
        widget.customLabelPlacement == InputCustomLabelPlacement.newLine) {
      child = Column(
        children: [child, customLabel!],
      );
    }

    child = GlobalTapDetector(
      child: Padding(
        padding: itemPadding,
        child: child,
      ),
    );

    if (widget.onTap != null) {
      return Stack(
        children: [
          child,
          Positioned(
            left: leadingSize.width + itemPadding.left,
            top: 0,
            right: 0,
            bottom: 0,
            child: buildButtonWidget(
              splashColor: widget.splashColor,
              onTap: () {
                widget.onTap!(
                    _setMapValue,
                    _controller,
                    MapValue.fromJson(
                        {"label": _controller.text, "value": _label}));
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          )
        ],
      );
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

  @override
  String? get parentKey => widget.parentKey;
}
