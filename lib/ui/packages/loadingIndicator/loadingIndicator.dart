import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/model/index.dart';
import 'package:leoui/ui/packages/loadingIndicator/controller.dart';
import 'package:leoui/utils/index.dart';

class LoadingIndicator extends StatefulWidget {
  final ScrollView child;
  final LoadingAsyncAction? onRefresh;
  final LoadingAsyncAction? onLoadeMore;
  final bool? enableRefresh;
  final bool? enableLoadeMore;
  final bool? hasMore;
  final double dragExtent;
  const LoadingIndicator(
      {Key? key,
      this.onRefresh,
      this.onLoadeMore,
      this.enableRefresh,
      this.enableLoadeMore,
      this.hasMore,
      this.dragExtent = 150,
      required this.child})
      : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  bool canStart = false;
  double offset = 0;

  late LoadingIndicatorController _controller;
  late AnimationController _positionController;

  @override
  void initState() {
    _controller = LoadingIndicatorController(dragExtent: widget.dragExtent);
    _positionController = AnimationController(vsync: this)
      ..addListener(() {
        _controller.setValue(_positionController.value);
      });
    _positionController.value = 0;
    super.initState();
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  void _startRefresh() async {
    print('refresh....');
    offset = -widget.dragExtent;
    canStart = false;

    _positionController.animateTo(widget.dragExtent,
        duration: Duration(milliseconds: 3000));
    _controller.setState(IndicatorState.refreshing);
    try {
      await widget.onRefresh!();
      _resetRefresh();
    } catch (err) {
      _resetRefresh();
    }
  }

  void _resetRefresh() {
    print('reset refresh');
    _controller.setState(IndicatorState.refresh_idle);
    offset = 0;
    _positionController.animateTo(0, duration: Duration(milliseconds: 300));
  }

  void _handleScrollStartNotification(ScrollStartNotification notification) {
    bool atLeading = notification.metrics.extentBefore == 0;
    bool atTrailing = notification.metrics.extentBefore >=
        notification.metrics.maxScrollExtent;
    canStart = (atLeading || atTrailing) &&
        notification.dragDetails != null &&
        !_controller.isLoadingmore &&
        !_controller.isRefreshing;
  }

  void _handleScrollUpdateNotification(ScrollUpdateNotification notification) {
    if (!canStart) return;
    offset += notification.scrollDelta!;
    _controller.setValue(offset);
    if (_controller.isRefreshArmed) {
      // release drag
      if (notification.dragDetails == null) {
        _startRefresh();
      }
    }
  }

  void _handleScrollEndNotification(ScrollEndNotification notification) {
    print('end -> ${_controller.state} offset-->$offset');
    if (_controller.state == IndicatorState.refresh_armed) {
      _startRefresh();
    }
  }

  void _handleOverScrollNotification(OverscrollNotification notification) {
    print('overscroll-->${notification.overscroll}');
  }

  void _handleUserScrollNotification(UserScrollNotification notification) {
    print('user scroll');
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _handleScrollStartNotification(notification);
    } else if (notification is ScrollUpdateNotification) {
      _handleScrollUpdateNotification(notification);
    } else if (notification is ScrollEndNotification) {
      _handleScrollEndNotification(notification);
    } else if (notification is UserScrollNotification) {
      _handleUserScrollNotification(notification);
    } else if (notification is OverscrollNotification) {
      _handleOverScrollNotification(notification);
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    print('glow');
    if (notification.depth != 0) return false;
    // if (notification.leading) {
    //   if (!widget.leadingGlowVisible) notification.disallowGlow();
    // } else {
    //   if (!widget.trailingGlowVisible) notification.disallowGlow();
    // }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: _handleGlowNotification,
          child: Stack(
            children: [
              AnimatedBuilder(
                  animation: _positionController,
                  child: widget.child,
                  builder: (ctx, child) {
                    return Transform.translate(
                      offset: Offset(
                          0, _positionController.value * widget.dragExtent),
                      child: child,
                    );
                  }),
              AnimatedBuilder(
                  animation: _controller,
                  child: widget.child,
                  builder: (ctx, child) {
                    String refreshTip =
                        _controller.state == IndicatorState.refresh_armed
                            ? "释放刷新"
                            : _controller.state == IndicatorState.refreshing
                                ? "刷新中..."
                                : '下拉刷新';
                    print('_controller.value: ${_controller.value}');
                    return Transform.translate(
                      offset: Offset(0, -_controller.value),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: sz(LeoSize.fontSize.secondary),
                            height: sz(LeoSize.fontSize.secondary),
                            margin: EdgeInsets.only(right: 10),
                            child: CircularProgressIndicator(
                              value:
                                  _controller.state != IndicatorState.refreshing
                                      ? _controller.draggingPercent
                                      : null,
                              color: theme.userAccentColor,
                              strokeWidth: 2,
                            ),
                          ),
                          Text(refreshTip,
                              style: TextStyle(
                                  fontSize: sz(LeoSize.fontSize.secondary),
                                  color: theme.userAccentColor))
                        ],
                      ),
                    );
                  }),
            ],
          )),
    );
  }
}
