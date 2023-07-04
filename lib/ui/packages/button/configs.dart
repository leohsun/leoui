import 'dart:ui';

import 'package:leoui/config/index.dart';
import 'package:leoui/feedback/index.dart';

enum ButtonType { primary, secondary, plain }

enum ButtonSize { nomarl, small }

List<Map<String, double>> sizeList = [
  {
    'fontSize':
        LeouiTheme.of(LeoFeedback.currentContext!).size!().buttonNormalFontSize,
    'minWidth':
        LeouiTheme.of(LeoFeedback.currentContext!).size!().buttonNormalMinWidth,
    'height':
        LeouiTheme.of(LeoFeedback.currentContext!).size!().buttonNormalHeight,
  },
  {
    'fontSize':
        LeouiTheme.of(LeoFeedback.currentContext!).size!().buttonSmallFontSize,
    'minWidth':
        LeouiTheme.of(LeoFeedback.currentContext!).size!().buttonSmallMinWidth,
    'height':
        LeouiTheme.of(LeoFeedback.currentContext!).size!().buttonSmallHeight
  }
];

class ButtonProperties {
  final ButtonType type;
  final ButtonSize size;
  final bool full;
  final bool circle;
  final bool loading;
  final bool disabled;
  final bool square;
  final Color? color;
  final String data;
  final VoidCallback? onTap;

  ButtonProperties({
    this.full = false,
    this.circle = false,
    this.loading = false,
    this.disabled = false,
    this.square = false,
    this.color,
    this.type = ButtonType.primary,
    required this.data,
    this.size = ButtonSize.nomarl,
    this.onTap,
  });

  Map toJson() {
    Map json = {};
    json['full'] = this.full;
    json['circle'] = this.circle;
    json['loading'] = this.loading;
    json['square'] = this.square;
    json['color'] = this.color;
    json['type'] = this.type;
    json['data'] = this.data;
    return json;
  }
}
