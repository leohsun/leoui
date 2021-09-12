import 'package:leoui/config/theme.dart';

class LeouiConfig {
  final LeoThemeData? theme;
  final LeouiBrightness? brightness;

  const LeouiConfig({this.brightness, this.theme});

  Map toJson() {
    Map json = {};
    return json;
  }
}
