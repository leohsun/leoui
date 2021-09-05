import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui_example/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Leoui(
          child: MaterialApp(
            title: 'leui demo',
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
              Locale('en', ''),
              Locale('zh', ''),
              Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
            ],
            // locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
            routes: routes,
          ),
          config: LeouiConfig()),
    );
  }
}
