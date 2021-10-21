import 'dart:ui';
import 'dart:math' show sin, pi;
import 'package:flutter/material.dart';

Color hex(String color) {
  String _color = color.trim();
  if (_color.startsWith('#')) {
    if (_color.length == 7) {
      return Color(int.parse('0xff${_color.replaceFirst(RegExp(r'#'), '')}'));
    }

    if (_color.length == 9) {
      String opacity = _color.substring(7);
      String rgb = _color.substring(1, 7);
      return Color(int.parse('0x$opacity$rgb'));
    }
  }

  return Color(0xffffff);
}

class DelayTween extends Tween<double> {
  DelayTween({required double begin, required double end, this.delay = 0.0})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);
}

Widget buildButtonWidget(
    {required Widget child,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    VoidCallback? onTapCancel,
    ValueChanged<bool>? onFocusChange,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? color}) {
  Color _color = color ?? Colors.transparent;
  return Material(
    color: _color,
    child: InkWell(
      splashColor: splashColor,
      highlightColor: Colors.transparent,
      borderRadius: borderRadius,
      child: child,
      onTap: onPress,
      onLongPress: onLongPress,
      onTapCancel: onTapCancel,
      onFocusChange: onFocusChange,
    ),
  );
}

Widget buildBlurWidget({required Widget child, BorderRadius? borderRadius}) {
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(12),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 0.001,
        sigmaY: 0.001,
      ),
      child: child,
    ),
  );
}

typedef MapWithIndexCallBack(element, int index);

List<T> mapWithIndex<T>(List data, MapWithIndexCallBack cb) {
  List<T> result = [];
  for (int i = 0; i < data.length; i++) {
    result.add(cb(data[i], i));
  }
  return result;
}
