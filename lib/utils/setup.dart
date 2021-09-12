import 'package:flutter/material.dart' hide Feedback;
import 'package:leoui/config/index.dart';
import 'package:leoui/feedback/index.dart';

void setup(LeouiConfig config, BuildContext context) {
  WidgetsFlutterBinding.ensureInitialized();

  Feedback.init(context);
}
