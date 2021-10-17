library leoui.feedback;

import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Slider, Dialog;
import 'package:flutter/services.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/config/size.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/index.dart';
import 'package:leoui/utils/index.dart';

part './model.dart';
part './actions.dart';
part './modal.dart';

class LeoFeedback {
  static init(
    BuildContext context,
  ) {
    if (currentContext != null) return;
    currentContext = context;
  }

  static BuildContext? currentContext;

  static Modal? loadingModal;
}
