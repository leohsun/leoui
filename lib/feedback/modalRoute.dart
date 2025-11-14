import 'package:flutter/material.dart';

class LeoModalRoute extends OverlayRoute {
  final OverlayEntry overlayEntry;
  final String? routeName;

  LeoModalRoute(this.overlayEntry, {this.routeName = 'LeoModalRoute'})
      : super(settings: RouteSettings(name: routeName));

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [overlayEntry];
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    // disable android physical device back button, the modal must close or open by use gesture
    return RoutePopDisposition.doNotPop;
  }
}
