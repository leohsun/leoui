import 'package:flutter/widgets.dart';

enum ratioType { width, height }

class SizeTool {
  static double? designWidth;

  static double? designHeight;

  static init({required double designWidth, required double designHeight}) {
    SizeTool.designWidth = designWidth;
    SizeTool.designHeight = designHeight;
  }

  static MediaQueryData _mediaQueryData =
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window);

  static double? _widthRatio;
  static double? _heightRatio;

  static Size get deviceSize => _mediaQueryData.size;
  static double get deviceWidth => _mediaQueryData.size.width;
  static double get deviceHeight => _mediaQueryData.size.height;
  static EdgeInsets get devicePadding => _mediaQueryData.padding;

  static double get widthRatio => SizeTool._calcScaleRatio(ratioType.width);
  static double get heightRatio => SizeTool._calcScaleRatio(ratioType.height);

  static _calcScaleRatio(ratioType type) {
    assert(designWidth != null && designHeight != null,
        'please init SizeTool first before use ; \n \'SizeTool.init(designWidth:375,designHeight:800)\'');
    if (SizeTool._widthRatio != null && type == ratioType.width) {
      return SizeTool._widthRatio;
    } else if (SizeTool._heightRatio != null && type == ratioType.height) {
      return SizeTool._heightRatio;
    }

    Size screenSize = SizeTool._mediaQueryData.size;

    double ratio = type == ratioType.width
        ? screenSize.width / designWidth!
        : screenSize.height / designHeight!;
    double parseRatio = double.parse(ratio.toStringAsFixed(6));
    if (type == ratioType.width) {
      SizeTool._widthRatio = parseRatio;
    } else
      SizeTool._heightRatio = parseRatio;

    return parseRatio;
  }

  static double sizeWidth(double size) {
    return size * widthRatio;
  }

  static double sizeHeight(double size) => size * heightRatio;

  static double size(double size) => sizeWidth(size);
}

double sz(double design) => SizeTool.size(design);
