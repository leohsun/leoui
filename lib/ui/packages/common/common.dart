import 'package:flutter/material.dart';
import 'package:leoui/config/theme.dart';

class DefaultTextIconStyle extends StatelessWidget {
  final Color? color;
  final double? size;
  final Widget? child;
  final FontWeight? fontWeight;
  const DefaultTextIconStyle(
      {Key? key, this.color, this.size, this.child, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);
    return IconTheme(
      data: IconThemeData(
          color: color ?? theme.labelPrimaryColor,
          size: size ?? theme.size!().title),
      child: DefaultTextStyle(
        child: child!,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
