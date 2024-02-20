import 'package:flutter/material.dart';

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
    return IconTheme(
      data: IconThemeData(color: color, size: size),
      child: DefaultTextStyle(
        child: child!,
        style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
      ),
    );
  }
}
