import 'package:flutter/widgets.dart';
import 'dart:math';

enum RatioType { width, height }

class SizeTool {
  final double widthRatio;
  final double heightRatio;

  factory SizeTool(
      {required double designWidth, required double designHeight}) {
    double widthRatio = deviceWidth / designWidth;
    double heightRatio = deviceHeight / designHeight;
    return SizeTool.raw(
        widthRatio: double.parse(widthRatio.toStringAsFixed(6)),
        heightRatio: double.parse(heightRatio.toStringAsFixed(6)));
  }

  factory SizeTool.portrait(
      {required double designWidth, required double designHeight}) {
    double widthRatio = min(deviceWidth, deviceHeight) / designWidth;
    double heightRatio = max(deviceWidth, deviceHeight) / designHeight;
    return SizeTool.raw(
        widthRatio: double.parse(widthRatio.toStringAsFixed(6)),
        heightRatio: double.parse(heightRatio.toStringAsFixed(6)));
  }

  const SizeTool.raw({required this.widthRatio, required this.heightRatio});

  static MediaQueryData _mediaQueryData() => MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single);

  static Size get deviceSize => _mediaQueryData().size;
  static double get deviceWidth => _mediaQueryData().size.width;
  static double get deviceHeight => _mediaQueryData().size.height;
  static EdgeInsets get devicePadding => _mediaQueryData().padding;
  static double get deviceRatio => _mediaQueryData().devicePixelRatio;
  static double get portraitDeviceWidth => min(deviceWidth, deviceHeight);
  static double get portraitDeviceHeight => max(deviceWidth, deviceHeight);

  double sizeWidth(double size) {
    double expceptWidth = (size * widthRatio).floorToDouble();
    return expceptWidth > deviceWidth ? deviceWidth : expceptWidth;
  }

  double sizeHeight(double size) {
    double expceptHeight = (size * heightRatio).floorToDouble();
    return expceptHeight > deviceHeight ? deviceHeight : expceptHeight;
  }
}

// only for leoui inner packages
double sz(double design) =>
    SizeTool(designWidth: 375, designHeight: 800).sizeWidth(design);
