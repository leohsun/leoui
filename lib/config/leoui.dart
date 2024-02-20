import 'package:leoui/config/theme.dart';

class LeouiConfig {
  final LeouiThemeData? lightTheme;
  final LeouiThemeData? darkTheme;

  const LeouiConfig({this.lightTheme, this.darkTheme});

  Map toJson() {
    Map json = {};
    return json;
  }
}
