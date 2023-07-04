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

extension ListTools<E> on List<E> {
  firstWhereOrNull<T extends Object>(fn(E element)) {
    for (int i = 0; i < this.length; i++) {
      if (fn(this[i])) {
        return this[i];
      }
    }

    return null;
  }

  mapWithIndex<T extends Object>(fn(E eletemt, int index)) {
    List<T> result = [];
    for (int i = 0; i < this.length; i++) {
      result.add(fn(this[i], i));
    }
    return result;
  }
}
