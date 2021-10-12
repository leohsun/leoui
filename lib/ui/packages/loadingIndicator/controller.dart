import 'package:flutter/material.dart';

enum IndicatorState {
  refresh_idle,
  refresh_dragging,
  refresh_armed,
  refreshing,
  loadmore_idle,
  loadmore_dragging,
  loadmore_armed,
  loadingmore,
}

class LoadingIndicatorController extends ChangeNotifier {
  double _value = 0;
  double _draggingPercent = 0;
  IndicatorState _state = IndicatorState.refresh_idle;

  final double dragExtent;
  double get value => _value;
  double get draggingPercent => _draggingPercent;
  IndicatorState get state => _state;
  bool get isLoadingmore => state == IndicatorState.loadingmore;
  bool get isRefreshing => state == IndicatorState.refreshing;
  bool get isRefreshArmed => state == IndicatorState.refresh_armed;

  LoadingIndicatorController({required this.dragExtent});

  void setValue(double val) {
    _value = val;
    _draggingPercent = (val.abs() / dragExtent).clamp(0, 1);

    if (_draggingPercent == 0) {
      _state =
          val <= 0 ? IndicatorState.refresh_idle : IndicatorState.loadmore_idle;
    } else if (_draggingPercent == 1) {
      _state = val <= 0
          ? IndicatorState.refresh_armed
          : IndicatorState.loadmore_armed;
    } else {
      _state = val < 0
          ? IndicatorState.refresh_dragging
          : IndicatorState.loadmore_dragging;
    }

    notifyListeners();
  }

  void setRefreshing() {
    _value = -dragExtent;
    _state = IndicatorState.refreshing;
    _draggingPercent = 1;
    notifyListeners();
  }

  void setState(IndicatorState state) {
    if (state == IndicatorState.refreshing) {
      _value = -dragExtent;
      _state = state;
      _draggingPercent = 1;
    } else if (state == IndicatorState.refresh_idle) {
      _value = 0;
      _state = state;
      _draggingPercent = 0;
    }

    notifyListeners();
  }
}
