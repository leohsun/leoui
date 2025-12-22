import 'package:flutter/material.dart';

class LeoModalRoute extends OverlayRoute {
  final OverlayEntry overlayEntry;
  final String? routeName;
  final bool? popViaSystemBackButton;

  LeoModalRoute(this.overlayEntry,
      {this.routeName = 'LeoModalRoute', this.popViaSystemBackButton = false})
      : super(settings: RouteSettings(name: routeName));

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [overlayEntry];
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    // disable android physical device back button, the modal must close or open by use gesture
    return this.popViaSystemBackButton == true
        ? RoutePopDisposition.pop
        : RoutePopDisposition.doNotPop;
  }
}
