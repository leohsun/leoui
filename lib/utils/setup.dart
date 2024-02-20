import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

void setup(LeouiConfig config, BuildContext overlay) {
  WidgetsFlutterBinding.ensureInitialized();
  LeoFeedback.bindContext(overlay);
}
