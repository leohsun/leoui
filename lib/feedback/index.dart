library leoui.feedback;

import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart' hide Slider, Dialog;
import 'package:flutter/services.dart';
import 'package:leoui/feedback/modalRoute.dart';
import 'package:leoui/leoui.dart';

part './model.dart';
part './actions.dart';
part './modal.dart';

class LeoFeedback {
  static init(
    BuildContext context,
  ) {
    // if (currentContext != null) return;
    currentContext = context;
  }

  static BuildContext? currentContext;

  static Modal? loadingModal;
  static Modal? toastModal;
}
