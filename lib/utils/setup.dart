import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

void setup(LeouiConfig config, BuildContext context) {
  WidgetsFlutterBinding.ensureInitialized();
  LeoFeedback.init(context);
}
