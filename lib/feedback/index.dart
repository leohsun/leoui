library leoui.feedback;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Slider, Dialog;
import 'package:flutter/services.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/config/size.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/index.dart';
import 'package:leoui/utils/index.dart';
part './widgets/fadeZoomBox.dart';
part './widgets/slider.dart';
part './widgets/indicator.dart';

part './model.dart';
part './actions.dart';

class Feedback {
  static init(
    BuildContext context,
  ) {
    if (currentContext != null) return;
    currentContext = context;
  }

  static BuildContext? currentContext;

  static GlobalKey? uniqueGlobalStateKey;

  static bool loadingWidgetCreated = false;

  static GlobalKey defaultUniqueGlobalKey =
      GlobalKey(debugLabel: '_defaultUniqueGlobalKey');

  static GlobalKey loadingGlobalKey =
      GlobalKey(debugLabel: '_loadingGlobalKey');

  static Set<Function> shouldCallAfterFadeZoomBoxWidgetCreatedFunctions = Set();
  static Set<Function> shouldCallAfterSliderWidgetCreatedFunctions = Set();

  static Set<OverlayEntry> sliderOverlayEntrySet = Set();

  static Set<GlobalKey> sliderKeysSet = Set();

  static OverlayEntry? uniqueOverlayEntry;

  static OverlayEntry show(Widget child,
      {bool? cover, bool? unique, bool? isSlider, BuildContext? context}) {
    assert(currentContext != null,
        'buildContext must be provided,\n Feedback.init(context)');
    bool _cover = cover ?? true;
    unique ??= false;
    isSlider ??= false;
    assert(
        (unique == true && isSlider == false) ||
            (unique == false && isSlider == true) ||
            (isSlider == false && unique == false),
        'either "unique" or "isSlider" only one can be true of boolean');

    OverlayEntry _overlayEntry = OverlayEntry(
      builder: (BuildContext ctx) => Container(
          color: _cover ? Color.fromRGBO(0, 0, 0, 0.3) : null, child: child),
    );
    if (unique) uniqueOverlayEntry = _overlayEntry;
    if (isSlider) sliderOverlayEntrySet.add(_overlayEntry);
    Overlay.of(currentContext!)?.insert(_overlayEntry);
    return _overlayEntry;
  }

  static void dismiss(OverlayEntry _overlayEntry) {
    _overlayEntry.remove();
  }

  static void dismissUnique() {
    if (uniqueOverlayEntry != null) {
      uniqueOverlayEntry!.remove();
      uniqueOverlayEntry = null;
    }
    uniqueGlobalStateKey = defaultUniqueGlobalKey;
  }
}
