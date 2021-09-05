import 'package:leoui/config/theme.dart';

class LeouiConfig {
  final double designWidth;
  final double designHeight;
  final LeoThemeData? theme;

  const LeouiConfig(
      {this.theme, this.designWidth = 375, this.designHeight = 800});

  Map toJson() {
    Map json = {};
    json['designWidth'] = this.designWidth;
    json['designHeight'] = this.designHeight;
    return json;
  }
}
