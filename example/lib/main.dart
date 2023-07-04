import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui_example/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final app = Leoui(
    child: MaterialApp(
      title: 'leoui demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'TW'),
        Locale('zh', ''),
      ],
      // locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      routes: routes,
    ),
    config: LeouiConfig());

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(app);
}
