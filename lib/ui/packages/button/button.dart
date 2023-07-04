library leo_ui.button;

import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

const double ColorChangeLightneessFactor = 40;

class Button extends StatefulWidget {
  final ButtonType type;
  final ButtonSize size;
  final bool full;
  final bool circle;
  final bool loading;
  final bool disabled;
  final bool square;
  final Color? color;
  final Color? textColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final String data;
  final VoidCallback? onTap;
  final bool inGroup;
  final double? maxWidth;

  const Button(this.data,
      {Key? key,
      this.type = ButtonType.primary,
      this.size = ButtonSize.nomarl,
      this.full = false,
      this.disabled = false,
      this.square = false,
      this.circle = false,
      this.inGroup = false,
      this.border,
      this.maxWidth,
      this.borderRadius,
      this.color,
      this.textColor,
      this.loading = false,
      this.onTap})
      : assert(
          !(circle == true && borderRadius != null),
          'Cannot provide both a circle and a borderRadius',
        ),
        assert(
          !(square == true && borderRadius != null),
          'Cannot provide both a square and a borderRadius',
        ),
        super(key: key);

  ButtonProperties getProperties() {
    return ButtonProperties(
        loading: this.loading,
        disabled: this.disabled,
        color: this.color,
        data: this.data,
        onTap: this.onTap);
  }

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(LeoFeedback.currentContext!);

    BorderRadius? borderRadius = widget.circle
        ? BorderRadius.circular(100)
        : widget.square
            ? null
            : widget.borderRadius ??
                BorderRadius.circular(theme.size!().buttonDefaultBorderRadius);

    Map size = sizeList[widget.size.index];

    MainAxisSize mainAxisSize =
        widget.full ? MainAxisSize.max : MainAxisSize.min;
    double padding = size['fontSize'];

    Color _widgetColor = widget.color ?? LeoColors.primary;

    Color backgroundColor =
        widget.type == ButtonType.primary ? _widgetColor : Colors.white;

    Color fontColor = widget.type == ButtonType.primary
        ? widget.textColor ?? Colors.white
        : _widgetColor;

    Border? _border = widget.border != null
        ? widget.border
        : widget.type == ButtonType.secondary && widget.inGroup == false
            ? Border.all(
                width: 1,
                color: widget.disabled
                    ? lighten(fontColor, ColorChangeLightneessFactor)
                    : fontColor)
            : null;
    List<Widget> children = [
      Flexible(
        child: Text(
          widget.data,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.disabled
                ? lighten(fontColor, ColorChangeLightneessFactor)
                : fontColor,
            fontSize: size['fontSize'],
          ),
        ),
      ),
    ];

    if (widget.loading) {
      children.insertAll(0, [
        SizedBox(
          height: size['fontSize'],
          width: size['fontSize'],
          child: CircularProgressIndicator(
            color: widget.disabled
                ? lighten(fontColor, ColorChangeLightneessFactor)
                : fontColor,
            strokeWidth: 1,
          ),
        ),
        SizedBox(
          width: size['fontSize'] / 2,
        ),
      ]);
    }

    double _maxWidth = widget.maxWidth ?? SizeTool.deviceWidth;
    return Material(
      color: widget.type == ButtonType.plain
          ? Colors.transparent
          : widget.disabled
              ? theme.baseGreyColor
              : backgroundColor,
      elevation: (widget.inGroup || widget.type == ButtonType.plain)
          ? 0
          : theme.size!().buttonElevation,
      borderRadius: borderRadius,
      child: InkWell(
          highlightColor: Colors.transparent,
          borderRadius: borderRadius,
          splashColor: darken(backgroundColor, ColorChangeLightneessFactor / 4),
          onTap: widget.disabled ? null : widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: _border,
            ),
            constraints: BoxConstraints(
                minHeight: size['height'], maxWidth: _maxWidth - padding),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Row(
                mainAxisSize: mainAxisSize,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          )),
    );
  }
}
