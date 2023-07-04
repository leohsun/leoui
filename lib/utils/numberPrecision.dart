import 'package:rational/rational.dart';

typedef NumberOperator = void Function({List T});

class NumberPrecision {
  static double times(List array) {
    assert(array.isNotEmpty);
    Rational result = array.reduce((value, element) =>
        Rational.parse('$value') * Rational.parse('$element'));
    return result.toDouble();
  }

  static double plus(List array) {
    assert(array.isNotEmpty);
    Rational result = array.reduce((value, element) =>
        Rational.parse('$value') + Rational.parse('$element'));
    return result.toDouble();
  }

  static double divide(List array) {
    assert(array.isNotEmpty);
    Rational result = array.reduce((value, element) =>
        Rational.parse('$value') / Rational.parse('$element'));
    return result.toDouble();
  }

  static double minus(List array) {
    assert(array.isNotEmpty);
    Rational result = array.reduce((value, element) =>
        Rational.parse('$value') - Rational.parse('$element'));
    return result.toDouble();
  }
}
