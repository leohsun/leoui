library leoui;

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/utils/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

export '../feedback/index.dart';
export '../ui/index.dart';
export '../model/index.dart';

class Leoui extends StatelessWidget {
  final MaterialApp child;
  final LeouiConfig config;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale locale;

  factory Leoui(
      {Key? key, required MaterialApp child, required LeouiConfig config}) {
    Locale localeRaw;
    if (child.locale != null) {
      localeRaw = child.locale!;
    } else {
      LocaleSubTag localeSubTag =
          LeouiLocalization.getLocaleSubTag(Platform.localeName);
      localeRaw = Locale.fromSubtags(
          languageCode: localeSubTag.languageCode,
          scriptCode: localeSubTag.scriptCode,
          countryCode: localeSubTag.countryCode);
    }

    List<LocalizationsDelegate<dynamic>> localizationsDelegatesRaw =
        getChildlocalizationsDelegates(child);

    localizationsDelegatesRaw.add(LeouiLocalizationDelegate());

    return Leoui.raw(
        child: child,
        config: config,
        localizationsDelegates: localizationsDelegatesRaw,
        locale: localeRaw);
  }

  const Leoui.raw(
      {required this.child,
      required this.config,
      required this.localizationsDelegates,
      required this.locale});

  static List<LocalizationsDelegate<dynamic>> getChildlocalizationsDelegates(
      child) {
    if (child.localizationsDelegates != null) {
      var tmp = child.localizationsDelegates;
      if (!tmp.contains(GlobalMaterialLocalizations.delegate)) {
        tmp.add(GlobalMaterialLocalizations.delegate);
      }

      if (!tmp.contains(GlobalWidgetsLocalizations.delegate)) {
        tmp.add(GlobalWidgetsLocalizations.delegate);
      }

      if (!tmp.contains(GlobalCupertinoLocalizations.delegate)) {
        tmp.add(GlobalCupertinoLocalizations.delegate);
      }

      return tmp;
    } else {
      return [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
      child: LeoTheme(
        theme: config.theme,
        child: DefaultTextStyle(
            style: TextStyle(
              color: LeoTheme.of(context).labelPrimaryColor,
            ),
            child: Localizations(
              delegates: localizationsDelegates.toList(),
              locale: locale,
              child: Overlay(
                initialEntries: [
                  OverlayEntry(builder: (BuildContext context) {
                    setup(config, context);
                    // we need a context to show overlay, then we can call feedback functions without context at anywhere
                    return child;
                  }),
                ],
              ),
            )),
      ),
    );
  }
}
