import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocaleSubTag {
  final String languageCode;
  final String? scriptCode;
  final String countryCode;

  LocaleSubTag(
      {required this.languageCode,
      required this.scriptCode,
      required this.countryCode});

  @override
  String toString() {
    return "languageCode:$languageCode,scriptCode:$scriptCode,countryCode:$countryCode;";
  }
}

class LeouiLocalization {
  final LocaleSubTag localeSubTag;
  final String languageName;

  factory LeouiLocalization(Locale locale) {
    LocaleSubTag localSubTag =
        LeouiLocalization.getLocaleSubTag(locale.toString());
    String languageName = localSubTag.languageCode;
    if (localSubTag.scriptCode != null) {
      languageName += '_${localSubTag.scriptCode}';
    }
    return LeouiLocalization.raw(
        localeSubTag: localSubTag, languageName: languageName);
  }

  const LeouiLocalization.raw(
      {required this.languageName, required this.localeSubTag});

  static LeouiLocalization of(BuildContext context) {
    return Localizations.of<LeouiLocalization>(context, LeouiLocalization)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'confirm': 'confirm',
      'cancel': 'cancel',
      'demo': 'demo',
      'emptyHint': 'is required',
      'notMathHint': 'is not matched',
      'warning': 'warning',
      'toastDefaultSuccessMessage': 'Operation succeeded',
      'toastDefaultWarningMessage': 'Operation failed'
    },
    'zh': {
      'confirm': '确定',
      'cancel': '取消',
      'demo': '示例',
      'emptyHint': '不能为空',
      'notMathHint': '格式不匹配',
      'warning': '警告',
      'toastDefaultSuccessMessage': '操作成功',
      'toastDefaultFailMessage': '操作失败'
    },
    'zh_Hans': {
      'confirm': '确定',
      'cancel': '取消',
      'demo': '示例',
      'emptyHint': '不能为空',
      'notMathHint': '格式不匹配',
      'warning': '警告',
      'toastDefaultSuccessMessage': '操作成功',
      'toastDefaultFailMessage': '操作失败'
    },
    'zh_Hant': {
      'confirm': '確定',
      'cancel': '取消',
      'demo': '舉例',
      'emptyHint': '不能為空',
      'notMathHint': '格式不匹配',
      'warning': '警告',
      'toastDefaultSuccessMessage': '操作成功',
      'toastDefaultFailMessage': '操作失敗'
    },
  };

  String get confirm {
    return _localizedValues[languageName]!['confirm']!;
  }

  String get cancel {
    return _localizedValues[languageName]!['cancel']!;
  }

  String get demo {
    return _localizedValues[languageName]!['demo']!;
  }

  String get emptyHint {
    return _localizedValues[languageName]!['emptyHint']!;
  }

  String get notMathHint {
    return _localizedValues[languageName]!['notMathHint']!;
  }

  String get warning {
    return _localizedValues[languageName]!['warning']!;
  }

  String get toastDefaultSuccessMessage {
    return _localizedValues[languageName]!['toastDefaultSuccessMessage']!;
  }

  String get toastDefaultFailMessage {
    return _localizedValues[languageName]!['toastDefaultFailMessage']!;
  }

  static get delegate => LeouiLocalizationDelegate();

  static List<String> languages = _localizedValues.keys.toList();

  static LocaleSubTag getLocaleSubTag(String localName) {
    List<String> raw = localName.split('_');
    String? scriptCode;
    String countryCode = '';

    if (raw.length == 2) {
      countryCode = raw.last;
    }

    if (raw.length == 3) {
      scriptCode = raw[1];
      countryCode = raw.last;
    }

    return LocaleSubTag(
        languageCode: raw.first,
        scriptCode: scriptCode,
        countryCode: countryCode);
  }
}

class LeouiLocalizationDelegate
    extends LocalizationsDelegate<LeouiLocalization> {
  @override
  bool isSupported(Locale locale) {
    LocaleSubTag localSubTag =
        LeouiLocalization.getLocaleSubTag(locale.toString());
    String languageName = localSubTag.languageCode;
    if (localSubTag.scriptCode != null) {
      languageName += '_${localSubTag.scriptCode}';
    }

    bool support = LeouiLocalization.languages.contains(languageName);

    if (!support) {
      print(
          "****************************** \n ${this.runtimeType} supports languages are ${LeouiLocalization.languages.toString()} \n******************************");
    }
    return support;
  }

  @override
  Future<LeouiLocalization> load(Locale locale) {
    return SynchronousFuture<LeouiLocalization>(LeouiLocalization(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<LeouiLocalization> old) =>
      false;
}
