import 'package:flutter/material.dart';

class LeoModalRoute extends OverlayRoute {
  final OverlayEntry overlayEntry;

  LeoModalRoute(this.overlayEntry)
      : super(settings: RouteSettings(name: 'LeoModalRoute'));

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [overlayEntry];
  }
}
