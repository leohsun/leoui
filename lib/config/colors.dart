import 'package:flutter/material.dart';

class LeoColorSwatch<String> extends Color {
  final Map<String, int> swatch;
  const LeoColorSwatch(int primary, this.swatch) : super(primary);

  int? operator [](String key) => swatch[key];
}

class LeoMaterialColor extends LeoColorSwatch {
  const LeoMaterialColor(int primary, Map<String, int> swatch)
      : super(primary, swatch);

  Color get light => Color(this['light']!);
  Color get dark => Color(this['dark']!);
}

class LeoColors {
  static const LeoMaterialColor primary =
      LeoMaterialColor(0XFF0A7AFF, {'light': 0XFF0A7AFF, 'dark': 0XFF0084FF});

  static const LeoMaterialColor success =
      LeoMaterialColor(0xff34C759, {'light': 0xff34C759, 'dark': 0xff32D74B});

  static const LeoMaterialColor danger =
      LeoMaterialColor(0xffFF3B30, {'light': 0xffFF3B30, 'dark': 0xffFF453A});

  static const LeoMaterialColor warn =
      LeoMaterialColor(0xffFF9500, {'light': 0xffFF9500, 'dark': 0xffFF9F0A});

  static const LeoMaterialColor dark =
      LeoMaterialColor(0xff000000, {'light': 0xffffffff, 'dark': 0xff000000});
}
