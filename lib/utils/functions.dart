import 'dart:ui';
import 'dart:math' show sin, pi;
import 'package:flutter/material.dart';

Color hex(String color) {
  String _color = color.trim();
  if (_color.startsWith('#')) {
    _color = _color.replaceFirst('#', '');
    print(_color);
    if (_color.length == 3) {
      // #ff0 3-digit
      String sixDigit =
          _color.splitMapJoin(RegExp(r'.'), onMatch: (m) => '${m[0]}${m[0]}');
      return Color(int.parse('0xff$sixDigit'));
    }

    if (_color.length == 6) {
      return Color(int.parse('0xff$_color'));
    }

    if (_color.length == 8) {
      String opacity = _color.substring(7);
      String rgb = _color.substring(1, 7);
      return Color(int.parse('0x$opacity$rgb'));
    }
  }

  print('the [color] property should starts with "#"');

  return Color(0xffffff);
}

Color darken(Color color, double amount) {
  assert(amount >= 0 && amount <= 100);
  double factor = 1 - amount / 100;

  return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255));
}

Color lighten(Color color, double amount) {
  assert(amount >= 0 && amount <= 100);
  double factor = 1 + amount / 100;
  return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255));
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
  Color _splashColor = splashColor ?? lighten(_color, 80);
  return Material(
    color: _color,
    child: InkWell(
      splashColor: _splashColor,
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

List<T> mapWithIndex<T>(List data, cb(element, int index)) {
  List<T> result = [];
  for (int i = 0; i < data.length; i++) {
    result.add(cb(data[i], i));
  }
  return result;
}

void forEachWithIndex<T>(List data, cb(element, int index)) {
  for (int i = 0; i < data.length; i++) {
    cb(data[i], i);
  }
}
