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
        (this.a * 255.0).round() & 0xff,
        (((this.r * 255.0).round() & 0xff) * factor).round().clamp(0, 255),
        (((this.g * 255.0).round() & 0xff) * factor).round().clamp(0, 255),
        (((this.b * 255.0).round() & 0xff) * factor).round().clamp(0, 255));
  }

  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 100);
    double factor = 1 + amount / 100;
    return Color.fromARGB(
        (this.a * 255.0).round() & 0xff,
        (((this.r * 255.0).round() & 0xff) * factor).round().clamp(0, 255),
        (((this.g * 255.0).round() & 0xff) * factor).round().clamp(0, 255),
        (((this.b * 255.0).round() & 0xff) * factor).round().clamp(0, 255));
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
  firstWhereOrNull(fn(E element)) {
    for (int i = 0; i < this.length; i++) {
      if (fn(this[i])) {
        return this[i];
      }
    }

    return null;
  }

  lastWhereOrNull(fn(E element)) {
    for (int i = this.length - 1; i > -1; i--) {
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
      endIndex = this.length - 1;
    } else {
      if (end >= 0) {
        endIndex = end > this.length - 1 ? this.length - 1 : end;
      } else {
        endIndex = this.length - 1 + end;
      }
    }

    for (int i = startIndex; i <= endIndex; i++) {
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

  List<T> filter<T>(bool fn(E element)) {
    List<T> result = [];
    for (int i = 0; i < this.length; i++) {
      final shoudAdd = fn(this[i]);
      if (shoudAdd) {
        result.add(this[i] as T);
      }
    }

    return result;
  }

  /// reference: https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
  ///
  /// [不会]改变原数据！！！！！！！！！！！
  List<T> splice<T>(int start, int deleteCount, List Function()? addFunction) {
    List<T> left = start > 0 ? this.slice(0, start - 1) : [];
    List<T> right = this.slice(start + deleteCount);

    List added = [];

    if (addFunction != null) {
      added = addFunction();
    }

    return [...left, ...added, ...right];
  }

  /// reference: https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/flat
  ///
  /// reference: https://github.com/lodash/lodash/blob/main/lodash.js
  List<T> flat<T>({int? depth = 1}) {
    assert(depth! >= 1);
    List<T> result = [];

    List<T> baseFlat(List array, int depth, List<T> result) {
      for (int i = 0; i < array.length; i++) {
        var item = array[i];

        if (item is List && depth > 0) {
          baseFlat(item, depth - 1, result);
        } else {
          result.add(item as T);
        }
      }

      return result;
    }

    return baseFlat(this, depth!, result);
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
