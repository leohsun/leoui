library leoui;

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:leoui/leoui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

export '../feedback/index.dart';
export '../model/index.dart';
export '../utils/index.dart';
export '../ui/index.dart';
export '../config/index.dart';

class LeouiStateWidget extends StatefulWidget {
  final MaterialApp Function(LeouiState leouiState) childBuilder;
  final LeouiConfig? config;
  final VoidCallback? initState;
  final VoidCallback? dispose;
  final ValueChanged<AppLifecycleState>? didChangeAppLifecycleState;
  final Future Function()? setup;
  final Widget? setupPlaceholder;

  const LeouiStateWidget(
      {super.key,
      required this.childBuilder,
      this.config,
      this.initState,
      this.dispose,
      this.didChangeAppLifecycleState,
      this.setup,
      this.setupPlaceholder});

  @override
  State<LeouiStateWidget> createState() => LeouiState();
}

typedef notificationCallback = void Function(Notification notification);

enum LeouiTickerStatus { running, pause }

class LeouiState extends State<LeouiStateWidget> with WidgetsBindingObserver {
  Completer setupComplater = Completer();

  List<notificationCallback> _notificationCallbackList = [];
  List<ValueChanged<double>> _tickerCallbackList = [];

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

  void afterSetup() async {
    if (widget.initState != null) {
      await setupComplater.future;
      widget.initState!();
    }
  }

  /// ticker
  int? _tickerId;

  int _startTime = 0;

  int _initTiker({bool? rescheduling}) {
    return SchedulerBinding.instance.scheduleFrameCallback(_tikercallback,
        rescheduling: rescheduling ?? false);
  }

  LeouiTickerStatus _status = LeouiTickerStatus.pause;

  LeouiConfig? config;

  GlobalKey overlay = GlobalKey();

  _tikercallback(Duration time) {
    if (_startTime != 0) {
      int disTime = time.inMicroseconds - _startTime;
      final dt = disTime / Duration.microsecondsPerSecond;
      _tickerCallbackList.forEach((fn) => fn.call(dt));
    }
    _startTime = time.inMicroseconds;
    if (_tickerId != null && _status == LeouiTickerStatus.running) {
      _tickerId = _initTiker(rescheduling: true);
    }
  }

  void _pauseTicker() {
    if (_tickerId != null && _status == LeouiTickerStatus.running) {
      SchedulerBinding.instance.cancelFrameCallbackWithId(_tickerId!);
      _status = LeouiTickerStatus.pause;
      _tickerId = null;
      _startTime = 0;
    }
  }

  void _resumeTicker() {
    if (_status == LeouiTickerStatus.running) return;
    _status = LeouiTickerStatus.running;
    _tickerId = _initTiker();
  }

  void changeConfig(LeouiConfig config) {
    this.config = config;

    if (this.mounted) {
      setState(() {});
    }
  }

  void rebuild() {
    if (this.mounted) {
      setState(() {
        overlay = GlobalKey(debugLabel: DateTime.now().toString());
      });
    }
  }

  @override
  void initState() {
    afterSetup();
    WidgetsBinding.instance.addObserver(this);
    _tickerId = _initTiker();
    config = widget.config;

    super.initState();
  }

  void addTickerCallback(ValueChanged<double> callback) {
    if (_tickerCallbackList.contains(callback)) return;
    _tickerCallbackList.add(callback);
    _resumeTicker();
    debugPrint("addTickerCallback");
  }

  void removeTickerCallback(ValueChanged<double> callback) {
    if (!_tickerCallbackList.contains(callback)) return;
    _tickerCallbackList.remove(callback);
    if (_tickerCallbackList.isEmpty) {
      _pauseTicker();
    }
    debugPrint("removeTickerCallback");
  }

  void addNotificationCallback(notificationCallback callback) {
    if (_notificationCallbackList.contains(callback)) return;
    _notificationCallbackList.add(callback);
    debugPrint("addNotificationCallback");
  }

  void removoeNotificationCallback(notificationCallback callback) {
    if (!_notificationCallbackList.contains(callback)) return;
    _notificationCallbackList.remove(callback);
    debugPrint("removoeNotificationCallback");
  }

  bool _onNotification(Notification notification) {
    if (_notificationCallbackList.isEmpty) return false;
    _notificationCallbackList.forEach((fn) => fn(notification));

    return false;
  }

  static LeouiState? of(BuildContext context) {
    if (!context.mounted) return null;
    final _LeouiScope? scope =
        context.dependOnInheritedWidgetOfExactType<_LeouiScope>();
    return scope?.leouiState;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.didChangeAppLifecycleState != null) {
      widget.didChangeAppLifecycleState!(state);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    LeouiConfig _config = config ?? LeouiConfig();
    LeouiThemeData lightTheme = _config.lightTheme ?? LeouiThemeData.light();
    LeouiThemeData darkTheme = _config.darkTheme ??
        LeouiThemeData.dark().copyWith(size: lightTheme.size);

    // to fix: https://github.com/flutter/flutter/issues/25827#issuecomment-571804641

    // return LayoutBuilder(builder: (context, constraints) {
    //   BuildContext _content = context;
    //   if (constraints.maxWidth == 0) {
    //     return widget.setupPlaceholder ??
    //         Container(
    //           color: lightTheme.userAccentColor,
    //         );
    //   }
    BuildContext _content = context;

    return FutureBuilder(
        future: widget.setup != null ? widget.setup!() : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.none) {
            MaterialApp child = widget.childBuilder(this);
            Locale locale;
            if (child.locale != null) {
              locale = child.locale!;
            } else {
              locale = Platform.localeName.toLocale();
            }
            final localizationsDelegates =
                getChildlocalizationsDelegates(child);

            localizationsDelegates.add(LeouiLocalizationDelegate());

            LeoFeedback.buildRootWidgetBuilder(
                mediaQueryData: MediaQueryData.fromView(View.of(_content)),
                lightTheme: lightTheme,
                darkTheme: darkTheme,
                delegates: localizationsDelegates,
                locale: locale);

            return LeoFeedback.rootWidget(child: LayoutBuilder(
              builder: (context, constraints) {
                final _overlay = Overlay(
                  key: overlay, // put a key to rebuild ,not the cache
                  initialEntries: [
                    OverlayEntry(builder: (BuildContext overlay) {
                      // we need a context to show overlay, then we can call feedback functions without context at anywhere
                      setup(_config, overlay);
                      if (!setupComplater.isCompleted) {
                        setupComplater.complete();
                      }
                      return child;
                    }),
                  ],
                );

                return NotificationListener(
                  onNotification: _onNotification,
                  child: _LeouiScope(
                    leouiState: this,
                    child: _overlay,
                  ),
                );
              },
            ));
          } else {
            return widget.setupPlaceholder ??
                Container(
                  color: lightTheme.userAccentColor,
                );
          }
        });
    // });
  }

  @override
  void dispose() {
    if (!setupComplater.isCompleted) {
      setupComplater.complete();
    }
    if (widget.dispose != null) {
      widget.dispose!();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _LeouiScope extends InheritedWidget {
  final LeouiState leouiState;
  final Widget child;

  _LeouiScope({required this.leouiState, required this.child})
      : super(child: child);

  @override
  bool updateShouldNotify(_LeouiScope oldWidget) => child != oldWidget.child;
}
