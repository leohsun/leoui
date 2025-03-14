import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leoui/utils/extensions.dart';

class LeouiLocalization {
  final String languageName;

  factory LeouiLocalization(Locale locale) {
    return LeouiLocalization.raw(languageName: locale.languageName());
  }

  const LeouiLocalization.raw({required this.languageName});

  static LeouiLocalization of(BuildContext context) {
    assert(Localizations.of<LeouiLocalization>(context, LeouiLocalization) !=
        null);
    return Localizations.of<LeouiLocalization>(context, LeouiLocalization)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'confirm': 'confirm',
      'cancel': 'cancel',
      'demo': 'demo',
      'emptyHint': ' is required',
      'notMathHint': ' is not matched',
      'warning': 'warning',
      'toastDefaultSuccessMessage': 'Operation succeeded',
      'toastDefaultFailMessage': 'Operation failed',
      'tabPickerSelectHintText': 'select',
      'search': 'search',
    },
    'zh': {
      'confirm': '确认',
      'cancel': '取消',
      'demo': '示例',
      'emptyHint': '不能为空',
      'notMathHint': '格式不匹配',
      'warning': '警告',
      'toastDefaultSuccessMessage': '操作成功',
      'toastDefaultFailMessage': '操作失败',
      'tabPickerSelectHintText': '请选择',
      'search': '搜索',
    },
    'zh_Hans': {
      'confirm': '确认',
      'cancel': '取消',
      'demo': '示例',
      'emptyHint': '不能为空',
      'notMathHint': '格式不匹配',
      'warning': '警告',
      'toastDefaultSuccessMessage': '操作成功',
      'toastDefaultFailMessage': '操作失败',
      'tabPickerSelectHintText': '请选择',
      'search': '搜索',
    },
    'zh_Hant': {
      'confirm': '確認',
      'cancel': '取消',
      'demo': '演示',
      'emptyHint': '不能為空',
      'notMathHint': '格式不匹配',
      'warning': '警告',
      'toastDefaultSuccessMessage': '操作成功',
      'toastDefaultFailMessage': '操作失敗',
      'tabPickerSelectHintText': '請選擇',
      'search': '搜尋',
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

  String get tabPickerSelectHintText {
    return _localizedValues[languageName]!['tabPickerSelectHintText']!;
  }

  String get search {
    return _localizedValues[languageName]!['search']!;
  }

  static get delegate => LeouiLocalizationDelegate();

  static List<String> languages = _localizedValues.keys.toList(growable: false);
}

class LeouiLocalizationDelegate
    extends LocalizationsDelegate<LeouiLocalization> {
  @override
  bool isSupported(Locale locale) {
    bool support = LeouiLocalization.languages.contains(locale.languageName());
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
