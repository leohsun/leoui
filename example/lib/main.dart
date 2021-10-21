import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui_example/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Leoui(
        child: MaterialApp(
          title: 'leui demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: 'selector',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('zh', ''),
          ],
          locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
          routes: routes,
        ),
        config: LeouiConfig());
  }
}
