// ignore_for_file: deprecated_member_use

import 'dart:ui';

extension LocaleTools on Locale {
  String languageName() {
    String _languageName = this.languageCode;
    if (this.scriptCode != null) {
      _languageName += '_${this.scriptCode}';
    }
    return _languageName;
  }
}

extension ColorTools on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 100);
    double factor = 1 - amount / 100;

    return Color.fromARGB(
        this.alpha,
        (this.red * factor).round().clamp(0, 255),
        (this.green * factor).round().clamp(0, 255),
        (this.blue * factor).round().clamp(0, 255));
  }

  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 100);
    double factor = 1 + amount / 100;
    return Color.fromARGB(
        this.alpha,
        (this.red * factor).round().clamp(0, 255),
        (this.green * factor).round().clamp(0, 255),
        (this.blue * factor).round().clamp(0, 255));
  }

  bool isDark() {
    double _colorBrightness = this.computeLuminance();

    return (_colorBrightness + 0.05) * (_colorBrightness + 0.05) < 0.15;
  }

  bool isLight() {
    double _colorBrightness = this.computeLuminance();

    return (_colorBrightness + 0.05) * (_colorBrightness + 0.05) > 0.15;
  }
}

extension StringTools on String {
  Color toHexColor() {
    assert(this.startsWith("#"));
    String _color = this.trim();
    if (_color.startsWith('#')) {
      _color = _color.replaceFirst('#', '');
      if (_color.length == 3) {
        // #ff0 3-digit
        String sixDigit =
            _color.splitMapJoin(RegExp(r'.'), onMatch: (m) => '${m[0]}${m[0]}');
        return Color(int.parse('0xff$sixDigit'));
      }

      if (_color.length == 6) {
        return Color(int.parse('0xff$_color'));
      }

      if (_color.length == 8) {
        String opacity = _color.substring(7);
        String rgb = _color.substring(1, 7);
        return Color(int.parse('0x$opacity$rgb'));
      }
    }
    return Color(0xffffff);
  }

  Locale toLocale() {
    List<String> raw = this.split('_');
    String? scriptCode;
    String? countryCode;
    if (raw.length == 2) {
      countryCode = raw.last;
    }

    if (raw.length == 3) {
      scriptCode = raw[1];
      countryCode = raw.last;
    }

    return Locale.fromSubtags(
        languageCode: raw.first,
        scriptCode: scriptCode,
        countryCode: countryCode);
  }

  String? substringOrNull(int start, [int? end]) {
    try {
      return this.substring(start, end);
    } catch (err) {
      return null;
    }
  }
}

typedef MapWithIndexCallbak<T, E> = T Function(
    E element, int index, bool isLast);

extension ListTools<E> on List<E> {
  firstWhereOrNull<T>(fn(E element)) {
    for (int i = 0; i < this.length; i++) {
      if (fn(this[i])) {
        return this[i];
      }
    }

    return null;
  }

  List<T> mapWithIndex<T>(MapWithIndexCallbak<T, E> fn) {
    List<T> result = [];
    for (int i = 0; i < this.length; i++) {
      bool isLast = i == this.length - 1;
      result.add(fn(this[i], i, isLast));
    }
    return result;
  }

  List<T> slice<T>(int start, [int? end]) {
    List<T> result = [];

    int startIndex = start;
    late int endIndex;
    if (end == null) {
      endIndex = this.length;
    } else {
      if (end >= 0) {
        endIndex = end > this.length ? this.length : end;
      } else {
        endIndex = this.length + end;
      }
    }

    int targetsLength = endIndex - startIndex;

    for (int i = 0; i < targetsLength; i++) {
      result.add(this[i] as T);
    }
    return result;
  }

  T reduceWithDefault<T>(T fn(value, E element), [T? defaultValue]) {
    Iterator<E> iterator = this.iterator;
    late T value;
    if (defaultValue != null) {
      value = defaultValue;
    } else if (iterator.moveNext()) {
      value = iterator.current as T;
    }

    while (iterator.moveNext()) {
      value = fn(value, iterator.current);
    }
    return value;
  }

  E? index(int index) {
    if (this.length > index) {
      return this[index];
    }

    return null;
  }

  int findIndex(bool fn(E element, int index)) {
    for (int i = 0; i < this.length; i++) {
      bool amid = fn(this[i], i);
      if (amid) return i;
    }

    return -1;
  }

  void forEachWithIndex(void fn(E element, int index)) {
    for (int i = 0; i < this.length; i++) {
      fn(this[i], i);
    }
  }

  List<E> filter(bool fn(E element)) {
    List<E> result = [];
    for (int i = 0; i < this.length; i++) {
      final shoudAdd = fn(this[i]);
      if (shoudAdd) {
        result.add(this[i]);
      }
    }

    return result;
  }
}

extension MapTools on Map {
  List<T> mapWithIndex<T, K, V>(Function(K key, V value, bool isLast) fn) {
    List<T> result = [];
    int current = 0;
    this.forEach((key, value) {
      bool isLast = ++current == this.length - 1;
      result.add(fn(key, value, isLast));
    });
    return result;
  }
}
