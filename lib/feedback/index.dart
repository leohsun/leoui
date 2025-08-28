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

typedef LeouiRootWidgetBuilder = Widget Function(Widget child);

class LeoFeedback {
  static bindContext(BuildContext overlay) {
    LeoFeedback.currentContext = overlay;
  }

  static buildRootWidgetBuilder(
      {required MediaQueryData mediaQueryData,
      required LeouiThemeData lightTheme,
      required LeouiThemeData darkTheme,
      required List<LocalizationsDelegate<dynamic>> delegates,
      required Locale locale}) {
    LeoFeedback._leouiRootWidgetBuilder = (Widget child) {
      return MediaQuery(
          data: mediaQueryData,
          child: LeouiTheme(
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Localizations(
                  delegates: delegates,
                  locale: locale,
                  child: DefaultTextEditingShortcuts(
                      child: LayoutBuilder(builder: (root, constraints) {
                    return DefaultTextStyle(
                        overflow: TextOverflow.ellipsis,
                        style: LeouiTheme.of(root)!.theme().defaultTextStyle,
                        child: Directionality(
                            textDirection: TextDirection.ltr, child: child));
                  })))));
    };
  }

  static BuildContext? currentContext;

  static LeouiRootWidgetBuilder? _leouiRootWidgetBuilder;

  /// create a common widget for reusing in [measureWidget]
  static Widget rootWidget({required Widget child}) {
    assert(LeoFeedback._leouiRootWidgetBuilder != null,
        'the leouiRootWidgetBuilder has not been created');
    return LeoFeedback._leouiRootWidgetBuilder!(child);
  }

  static Modal? loadingModal;
  static Modal? toastModal;
}
