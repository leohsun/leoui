library leoui;

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/utils/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

export './feedback/index.dart';
export './model/index.dart';
export './utils/index.dart';
export './ui/index.dart';
export './config/index.dart';

class LeouiState extends StatefulWidget {
  final MaterialApp child;
  final LeouiConfig config;
  final VoidCallback? initState;
  final VoidCallback? dispose;
  final Future Function()? setup;
  final Widget? setupPlaceholder;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale locale;

  factory LeouiState(
      {Key? key,
      required MaterialApp child,
      LeouiConfig? config,
      VoidCallback? initState,
      VoidCallback? dispose,
      Future Function()? setup,
      Widget? setupPlaceholder}) {
    Locale localeRaw;
    if (child.locale != null) {
      localeRaw = child.locale!;
    } else {
      localeRaw = Platform.localeName.toLocale();
    }

    List<LocalizationsDelegate<dynamic>> localizationsDelegatesRaw =
        getChildlocalizationsDelegates(child);

    localizationsDelegatesRaw.add(LeouiLocalizationDelegate());

    return LeouiState.raw(
        child: child,
        config: config ?? LeouiConfig(),
        localizationsDelegates: localizationsDelegatesRaw,
        initState: initState,
        setup: setup,
        setupPlaceholder: setupPlaceholder,
        dispose: dispose,
        locale: localeRaw);
  }

  const LeouiState.raw(
      {required this.child,
      required this.config,
      required this.localizationsDelegates,
      this.initState,
      this.dispose,
      this.setup,
      this.setupPlaceholder,
      required this.locale});

  static List<LocalizationsDelegate<dynamic>> getChildlocalizationsDelegates(
      child) {
    List<LocalizationsDelegate<dynamic>>? _localizationsDelegates =
        child.localizationsDelegates != null
            ? List.from(child.localizationsDelegates)
            : null;
    if (_localizationsDelegates != null) {
      var tmp = _localizationsDelegates;
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
  State<LeouiState> createState() => _LeouiStateState();
}

class _LeouiStateState extends State<LeouiState> with WidgetsBindingObserver {
  Completer setupComplater = Completer();

  void afterSetup() async {
    if (widget.initState != null) {
      await setupComplater.future;
      widget.initState!();
    }
  }

  @override
  void initState() {
    afterSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = widget.config.theme ?? LeouiThemeData.light();

    // to fix: https://github.com/flutter/flutter/issues/25827#issuecomment-571804641

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth == 0) {
        return widget.setupPlaceholder ??
            Container(
              color: theme.userAccentColor,
            );
      }

      final child = MediaQuery(
        data: MediaQueryData.fromView(View.of(context)),
        child: LeouiTheme(
          theme: theme,
          child: DefaultTextStyle(
              style: TextStyle(
                color: widget.config.theme?.labelPrimaryColor,
              ),
              child: Localizations(
                delegates:
                    widget.localizationsDelegates.toList(growable: false),
                locale: widget.locale,
                child: DefaultTextEditingShortcuts(
                  child: Overlay(
                    initialEntries: [
                      OverlayEntry(builder: (BuildContext context) {
                        // we need a context to show overlay, then we can call feedback functions without context at anywhere
                        setup(widget.config, context);
                        if (!setupComplater.isCompleted) {
                          setupComplater.complete();
                        }
                        return widget.child;
                      }),
                    ],
                  ),
                ),
              )),
        ),
      );

      if (widget.setup == null) return child;
      return FutureBuilder(
          future: widget.setup!(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return child;
            }
            return widget.setupPlaceholder ??
                Container(
                  color: theme.userAccentColor,
                );
          });
    });
  }

  @override
  void dispose() {
    if (!setupComplater.isCompleted) {
      setupComplater.complete();
    }
    if (widget.dispose != null) {
      widget.dispose!();
    }
    super.dispose();
  }
}
