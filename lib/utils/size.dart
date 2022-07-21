import 'package:flutter/widgets.dart';

enum RatioType { width, height }

class SizeTool {
  final double widthRatio;
  final double heightRatio;

  factory SizeTool(
      {required double designWidth, required double designHeight}) {
    double widthRatio = deviceWidth / designWidth;
    double heightRatio = deviceWidth / designHeight;
    return SizeTool.raw(
        widthRatio: double.parse(widthRatio.toStringAsFixed(6)),
        heightRatio: double.parse(heightRatio.toStringAsFixed(6)));
  }

  const SizeTool.raw({required this.widthRatio, required this.heightRatio});

  static MediaQueryData _mediaQueryData =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  static Size get deviceSize => _mediaQueryData.size;
  static double get deviceWidth => _mediaQueryData.size.width;
  static double get deviceHeight => _mediaQueryData.size.height;
  static EdgeInsets get devicePadding => _mediaQueryData.padding;

  double sizeWidth(double size) {
    return size * widthRatio;
  }

  double sizeHeight(double size) => size * heightRatio;
}

// only for leoui inner packages
double sz(double design) =>
    SizeTool(designWidth: 375, designHeight: 800).sizeWidth(design);
