// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' show sin, pi;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leoui/widget/leoui_state.dart';

Color hex(String color) {
  String _color = color.trim();
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

  print('the [color] property should starts with "#"');

  return Color(0xffffff);
}

Color darken(Color color, double amount) {
  assert(amount >= 0 && amount <= 100);
  double factor = 1 - amount / 100;

  return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255));
}

Color lighten(Color color, double amount) {
  assert(amount >= 0 && amount <= 100);
  double factor = 1 + amount / 100;
  return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255));
}

class DelayTween extends Tween<double> {
  DelayTween({required double begin, required double end, this.delay = 0.0})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);
}

Widget buildButtonWidget(
    {required Widget child,
    VoidCallback? onTap,
    void Function(TapDownDetails)? onTapDown,
    void Function(TapUpDetails)? onTapUp,
    VoidCallback? onLongPress,
    VoidCallback? onTapCancel,
    ValueChanged<bool>? onFocusChange,
    BorderRadius? borderRadius,
    bool? disabled,
    Color? splashColor,
    double? elevation,
    Color? shandow,
    Color? color}) {
  Color _color = color ?? Colors.transparent;
  Color _splashColor = splashColor ?? lighten(_color, 80);
  return PhysicalModel(
    borderRadius: borderRadius,
    elevation: elevation ?? 0,
    color: elevation == null
        ? Colors.transparent
        : shandow ??
            LeouiTheme.of(LeoFeedback.currentContext!)!
                .theme()
                .nonOpaqueSeparatorColor,
    child: Material(
      color: color ?? Colors.transparent,
      borderRadius: borderRadius,
      type: MaterialType.button,
      child: InkWell(
        splashColor: _splashColor,
        highlightColor: Colors.transparent,
        borderRadius: borderRadius,
        child: disabled == true
            ? ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(colors: [Color(0xffdfdfdf)], stops: [1])
                      .createShader(bounds);
                },
                blendMode: BlendMode.color,
                child: child)
            : child,
        onTap: disabled == true ? null : onTap,
        onTapDown: disabled == true ? null : onTapDown,
        onTapUp: disabled == true ? null : onTapUp,
        onLongPress: disabled == true ? null : onLongPress,
        onTapCancel: disabled == true ? null : onTapCancel,
        onFocusChange: disabled == true ? null : onFocusChange,
      ),
    ),
  );
}

Widget buildBlurWidget({
  required Widget child,
  BorderRadius? borderRadius,
  double sigmaX = 0.0,
  double sigmaY = 0.0,
}) {
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(12),
    child: BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
      ),
      child: child,
    ),
  );
}

List<T> mapWithIndex<T, E>(List data, cb(E element, int index)) {
  List<E> castList = List<E>.from(data);
  List<T> result = [];
  for (int i = 0; i < castList.length; i++) {
    result.add(cb(castList[i], i));
  }
  return result;
}

void forEachWithIndex<T>(List<T> data, cb(T element, int index)) {
  for (int i = 0; i < data.length; i++) {
    cb(data[i], i);
  }
}

Function debounce(Function() fn, Duration delay) {
  Timer? _timer;

  return () {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(delay, fn);
  };
}

void tracePrint(dynamic log, {packageName = 'leoui', onlyDebugModel = true}) {
  if (onlyDebugModel && !kDebugMode) return;

  if (log.runtimeType != String) {
    log = log.toString();
  }

  var lines = StackTrace.current.toString().split('\n');

  if (lines.length > 2) {
    RegExpMatch? mathedPathDeep1 =
        RegExp('\\(package:$packageName[^\)]+\\)').firstMatch(lines[1]);

    RegExpMatch? mathedPathDeep2 =
        RegExp('\\(package:$packageName[^\)]+\\)').firstMatch(lines[2]);
    if (mathedPathDeep2 != null) {
      print(
          log + lines[2].substring(mathedPathDeep2.start, mathedPathDeep2.end));
    } else if (mathedPathDeep1 != null) {
      print(
          log + lines[1].substring(mathedPathDeep1.start, mathedPathDeep1.end));
    } else {
      print(log);
    }
  } else {
    print(log);
  }
}

class ImagePayload {
  final ui.Image? image;
  final Uint8List? imageData;

  ImagePayload(this.image, this.imageData);
}

Future<ImagePayload> loadImage(String path) async {
  Completer<ui.Image?> loading = Completer();
  ImageStream imageStream;
  late ImageStreamListener imageStreamListener;

  void onImage(ImageInfo imageInfo, bool synchronousCall) {
    loading.complete(imageInfo.image);
  }

  void onError(Object exception, StackTrace? stackTrace) {
    loading.complete(null);
    tracePrint(onError);
  }

  imageStreamListener = ImageStreamListener(onImage, onError: onError);

  bool isRemote = path.startsWith(RegExp(r'https?://'));

  if (isRemote) {
    imageStream = NetworkImage(path).resolve(ImageConfiguration());
  } else {
    imageStream = AssetImage(path).resolve(ImageConfiguration());
  }

  imageStream.addListener(imageStreamListener);

  ui.Image? image = await loading.future;

  Uint8List? imageData;

  if (image != null) {
    ByteData? rawData = await image.toByteData(format: ui.ImageByteFormat.png);
    imageData = rawData?.buffer.asUint8List();
  }

  return ImagePayload(image, imageData);
}
