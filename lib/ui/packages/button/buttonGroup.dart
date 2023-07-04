import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/feedback/index.dart';
import 'package:leoui/ui/packages/button/configs.dart';
import 'package:leoui/utils/size.dart';
import 'package:leoui/utils/extensions.dart';

import 'button.dart';

class ButtonGroup extends StatefulWidget {
  final bool circle;
  final bool square;
  final bool full;
  final bool? disabled;
  final ButtonType type;
  final ButtonSize size;
  final Color? color;
  final Color? textColor;
  final List<Button> children;

  const ButtonGroup(
      {Key? key,
      this.circle = false,
      this.square = false,
      this.full = false,
      this.disabled,
      Color? color,
      this.textColor,
      required this.children,
      this.type = ButtonType.primary,
      this.size = ButtonSize.nomarl})
      : assert(
          circle == false || square == false,
          'Cannot provide both a circle and a square are \'true\' value',
        ),
        assert(
          children.length > 1,
          'chidren length must be greater than 1',
        ),
        color = type == ButtonType.secondary && color == null
            ? LeoColors.primary
            : color,
        super(key: key);

  @override
  ButtonGroupState createState() => ButtonGroupState();
}

class ButtonGroupState extends State<ButtonGroup> {
  late List<Widget> _children;

  Color? _textColor;

  late bool onlyTwo = widget.children.length == 2;

  BorderRadius? groupBorderRadius;

  late double maxWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width /
          widget.children.length;

  void _assembleChildrenList() {
    List<Widget> tmp = [];

    for (int i = 0; i < widget.children.length; i++) {
      ButtonProperties _buttonProperties = widget.children[i].getProperties();

      BorderRadius? _borderRadius;
      Border? _border;

      if (widget.type == ButtonType.secondary && widget.children.length > 2) {
        _border =
            Border.all(width: 1, color: widget.color ?? LeoColors.primary);
      }

      if (i == 0) {
        _borderRadius = widget.circle
            ? BorderRadius.only(
                topLeft: Radius.circular(100), bottomLeft: Radius.circular(100))
            : widget.square
                ? BorderRadius.zero
                : BorderRadius.only(
                    topLeft: Radius.circular(sz(8)),
                    bottomLeft: Radius.circular(sz(8)));
        _border = widget.type == ButtonType.secondary
            ? Border.all(
                width: 1,
                color: onlyTwo
                    ? Colors.white
                    : widget.color ??
                        _buttonProperties.color ??
                        LeoColors.primary)
            : null;
        groupBorderRadius = BorderRadius.all(_borderRadius.topLeft);
      } else if (i == widget.children.length - 1) {
        _borderRadius = widget.circle
            ? BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100))
            : widget.square
                ? BorderRadius.zero
                : BorderRadius.only(
                    topRight: Radius.circular(sz(8)),
                    bottomRight: Radius.circular(sz(8)));
        _border = widget.type == ButtonType.secondary
            ? Border.all(
                width: 1,
                color: onlyTwo
                    ? Colors.white
                    : widget.color ??
                        _buttonProperties.color ??
                        LeoColors.primary)
            : null;
      } else if (i > 0 && i < widget.children.length - 2) {
        _borderRadius = null;
        _border = widget.type == ButtonType.secondary
            ? Border(
                top: BorderSide(
                    width: 1, color: widget.color ?? LeoColors.primary),
                right: BorderSide(
                    width: 1, color: widget.color ?? LeoColors.primary),
                bottom: BorderSide(
                    width: 1, color: widget.color ?? LeoColors.primary))
            : null;
      } else {
        // the last third one
        _borderRadius = null;
        _border = widget.type == ButtonType.secondary
            ? Border(
                top: BorderSide(
                    width: 1, color: widget.color ?? LeoColors.primary),
                bottom: BorderSide(
                    width: 1, color: widget.color ?? LeoColors.primary))
            : null;
      }

      Widget btn = Button(_buttonProperties.data,
          onTap: _buttonProperties.onTap,
          loading: _buttonProperties.loading,
          disabled: widget.disabled ?? _buttonProperties.disabled,
          color: widget.type == ButtonType.primary
              ? _buttonProperties.color ?? widget.color
              : widget.color,
          textColor: _textColor,
          type: widget.type,
          full: widget.full,
          size: widget.size,
          maxWidth: maxWidth,
          inGroup: true,
          border: _border,
          square: _borderRadius == null,
          borderRadius: _borderRadius);
      if (widget.full) {
        btn = Flexible(
            child: Button(_buttonProperties.data,
                onTap: _buttonProperties.onTap,
                loading: _buttonProperties.loading,
                disabled: widget.disabled ?? _buttonProperties.disabled,
                color: widget.type == ButtonType.primary
                    ? _buttonProperties.color ?? widget.color
                    : widget.color,
                textColor: _textColor,
                type: widget.type,
                full: widget.full,
                size: widget.size,
                maxWidth: maxWidth,
                inGroup: true,
                border: _border,
                square: _borderRadius == null,
                borderRadius: _borderRadius));
      }
      tmp.add(btn);
      if (widget.type == ButtonType.primary &&
          i != widget.children.length - 1) {
        tmp.add(Container(
          height: widget.size == ButtonSize.nomarl
              ? LeouiTheme.of(LeoFeedback.currentContext!)
                  .size!()
                  .buttonNormalHeight
              : LeouiTheme.of(LeoFeedback.currentContext!)
                  .size!()
                  .buttonSmallHeight,
          width: 0.3,
          color: LeouiTheme.of(LeoFeedback.currentContext!)
              .nonOpaqueSeparatorColor,
        ));
      }
    }

    if (onlyTwo && widget.type == ButtonType.secondary) {
      Map size = sizeList[widget.size.index];
      Widget divider = Container(
        width: 1,
        height: size['height'],
        color: widget.color,
      );
      tmp.insert(1, divider);
    }

    _children = tmp;
  }

  @override
  void initState() {
    Color? computedColor = widget.color != null
        ? (widget.color!.isDark()
            ? widget.color!.lighten(50)
            : widget.color!.darken(50))
        : null;
    _textColor = widget.textColor ?? computedColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _assembleChildrenList();
    if (onlyTwo && widget.type == ButtonType.secondary) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border:
              Border.all(width: 1, color: widget.color ?? LeoColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Row(
            mainAxisSize: widget.full ? MainAxisSize.max : MainAxisSize.min,
            children: _children,
          ),
        ),
      );
    }
    LeouiThemeData theme = LeouiTheme.of(context);
    return PhysicalModel(
      elevation: theme.size!().itemElevation,
      borderRadius: groupBorderRadius,
      color: Colors.transparent,
      child: Row(
        mainAxisSize: widget.full ? MainAxisSize.max : MainAxisSize.min,
        children: _children,
      ),
    );
  }
}
