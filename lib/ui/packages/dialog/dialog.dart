import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/ui/index.dart';
import 'package:leoui/utils/index.dart';

enum DialogLayout { row, column }

class Dialog extends StatefulWidget {
  final LeouiBrightness? brightness;
  final String? title; //窗口标题
  final String? content; //正文内容
  final IconData? icon; //Icon组件图标名称
  final DialogLayout layout; //底部按钮组布局方式, row, column
  final List<DialogButton>? buttons; //底部操作按钮组
  final Widget? slot; // 插槽内容
  final double? width;
  final bool promopt; // 輸入框
  final String? placeholder; // 輸入框提示
  final RegExp? validatePattern;
  final String? patternDescript;
  final String? fieldKey; // 用于Field导出数据的key --> {'username':'kim'}
  final String? fieldLabel; // 用于校验输入提示 -->'(用户名)不能为空'
  final TextInputType? fieldInputType;
  final String? fieldInputDefaultValue;
  final GlobalKey<InputItemState>? promoptItemKey;
  const Dialog(
      {Key? key,
      this.brightness,
      this.title,
      this.icon,
      this.slot,
      this.layout = DialogLayout.row,
      this.buttons,
      this.content,
      this.width,
      this.promopt = false,
      this.validatePattern,
      this.patternDescript,
      this.placeholder,
      this.promoptItemKey,
      this.fieldKey,
      this.fieldLabel,
      this.fieldInputType,
      this.fieldInputDefaultValue})
      : super(key: key);

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  late Color labelPrimaryColor;
  late LeouiThemeData theme;

  Widget _buildBody(LeouiThemeData theme) {
    List<Widget> _children = [];

    if (widget.title != null) {
      _children.add(Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Text(
          widget.title!,
          style: TextStyle(
              height: 1.2,
              fontSize: theme.size!().title,
              color: theme.labelPrimaryColor),
        ),
      ));
    }

    if (widget.icon != null) {
      _children.add(
        Padding(
          padding:
              EdgeInsets.only(top: widget.title != null ? 0 : 10, bottom: 14),
          child: Icon(
            widget.icon,
            size: 50,
            color: theme.labelSecondaryColor,
          ),
        ),
      );
    }

    if (widget.content != null) {
      _children.add(Text(
        widget.content!,
        style: TextStyle(
            height: 1.2,
            fontSize: theme.size!().tertiary,
            color: theme.labelPrimaryColor),
      ));
    }

    if (widget.promopt) {
      _children.add(Material(
        borderRadius: BorderRadius.circular(theme.size!().fieldBorderRadius),
        color: theme.backgroundSecondaryColor,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: theme.nonOpaqueSeparatorColor),
            borderRadius:
                BorderRadius.circular(theme.size!().fieldBorderRadius),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(theme.size!().fieldBorderRadius),
            child: InputItem(
              key: widget.promoptItemKey,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              maxLines: 1,
              brightness: widget.brightness,
              validatePattern: widget.validatePattern,
              patternDescript: widget.patternDescript,
              placeholder: widget.placeholder,
              fieldKey: widget.fieldKey,
              fieldLabel: widget.fieldLabel,
              inputType: widget.fieldInputType,
              defaultValue: widget.fieldInputDefaultValue,
              focus: true,
              fontSize: theme.size!().tertiary,
            ),
          ),
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.all(23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _children,
      ),
    );
  }

  Widget _buildButtons(LeouiThemeData theme) {
    List<Widget> _children = widget.buttons!.map((DialogButton config) {
      return _buildButton(config, theme);
    }).toList(growable: false);

    List<Widget> _chilrenWithinDivider = [];
    int count = _children.length - 1;
    bool isRow = widget.layout == DialogLayout.row;
    for (int i = 0; i <= count; i++) {
      _chilrenWithinDivider.add(_children[i]);
      if (i < count) {
        _chilrenWithinDivider.add(Container(
          height: isRow ? theme.size!().buttonNormalHeight : 0.5,
          width: isRow ? 0.5 : null,
          color: theme.nonOpaqueSeparatorColor,
        ));
      }
    }

    if (widget.layout == DialogLayout.row) {
      return Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: theme.nonOpaqueSeparatorColor))),
        child: Row(
          children: _chilrenWithinDivider,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: theme.nonOpaqueSeparatorColor))),
        height: _children.length * theme.size!().buttonNormalHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _chilrenWithinDivider,
        ),
      );
    }
  }

  Widget _buildButton(DialogButton button, LeouiThemeData theme) {
    Color color = button.color ?? theme.userAccentColor;
    List<Widget> _children = [
      Flexible(
        child: Text(
          button.text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: theme.size!().title,
              color: color,
              fontWeight:
                  button.bold == true ? FontWeight.bold : FontWeight.normal),
        ),
      )
    ];

    if (button.icon != null) {
      _children.insert(
          0,
          Padding(
            padding: EdgeInsets.only(right: theme.size!().title) / 3,
            child: Icon(
              button.icon,
              size: theme.size!().title,
              color: color,
            ),
          ));
    }

    if (button.loading == true) {
      _children.insert(
        0,
        Padding(
          padding: EdgeInsets.only(right: theme.size!().title) / 3,
          child: SizedBox(
              width: theme.size!().title,
              height: theme.size!().title,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              )),
        ),
      );
    }

    return Expanded(
      child: buildButtonWidget(
        onTap: () {
          button.handler(context);
        },
        splashColor: theme.fillPrimaryColor,
        color: theme.dialogBackgroundColor,
        child: Container(
          height: theme.size!().buttonNormalHeight,
          padding: EdgeInsets.symmetric(horizontal: theme.size!().title / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: widget.layout == DialogLayout.row
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: _children,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    theme = LeouiTheme.of(context)!.theme(brightness: widget.brightness);

    double _width = widget.width ?? theme.size!().dialogWidth;
    List<Widget> _children = [];
    if (widget.slot != null) _children.add(widget.slot!);
    if (widget.title != null ||
        widget.icon != null ||
        widget.content != null ||
        widget.promopt) _children.add(_buildBody(theme));
    if (widget.buttons != null) {
      _children.add(_buildButtons(theme));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.size!().cardBorderRadius),
      child: Container(
        width: _width,
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          boxShadow: theme.boxShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _children,
        ),
      ),
    );
  }
}

class DialogButton {
  final String text; // 按钮文案
  final ValueChanged<BuildContext> handler; //点击回调
  final Color? color; //字体颜色
  final bool? disabled; //禁用按钮
  final bool? loading; //加载中按钮
  final IconData? icon; //按钮图标
  final bool? bold; // 文字加粗

  DialogButton(
      {required this.text,
      required this.handler,
      this.color,
      this.disabled,
      this.bold,
      this.loading,
      this.icon})
      : assert(loading != true || icon == null,
            'can not provide both \'loading\' and \'icon\'');
}
