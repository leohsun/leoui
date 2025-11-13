part of leoui.feedback;

class Modal {
  final OverlayEntry entry;
  final WidgetBuilder childBuilder;

  final Completer dismissCompleter;
  final ValueChanged<bool>? onClose;
  final GlobalKey<_ModalWidgetState> modalWidgetKey;

  /// avoid view height change when keyboard visible or hidden
  final bool fixed;

  /// we need this to remove specific route, because the modalRoute is not aways at top,can not use [Navigator.pop]
  final LeoModalRoute route;

  get dissmissed => dismissCompleter.future;

  Future<void> close([payload]) async {
    if (!dismissCompleter.isCompleted) {
      if (modalWidgetKey.currentState != null &&
          modalWidgetKey.currentState!.autoCloseCounter != null) {
        modalWidgetKey.currentState!.autoCloseCounter!.cancel();
      }
      dismissCompleter.complete(payload);
      entry.remove();

      if (onClose != null) {
        onClose!(false);
      }
    }
  }

  factory Modal(
      {required WidgetBuilder childBuilder,
      ModalDirection? direction,
      Duration? duration,
      bool? closeOnClickMask,
      bool? noMask,
      bool? autoClose,
      bool? dragToClose,
      double? dragToCloseGap,
      double? dragToCloseVelocity,
      bool? reverseAnimationWhenClose,
      bool? animateWhenOpen,
      double? maskAlpha = 0.7,
      ValueChanged<bool>? onClose,

      /// 位置不响应键盘的开启或关闭
      bool? fixed,
      Curve? curve}) {
    // assert(autoClose != true || closeOnClickMask != true,
    //     'can not provide both autoColse and closeOnClickMask are \'ture\' value');
    assert(dragToClose != true || direction != ModalDirection.center,
        'can not procide both [dragToClose = true] and [direction = ModalDirection.center]');

    reverseAnimationWhenClose ??= false;
    closeOnClickMask ??= false;
    dragToClose ??= false;
    Completer dismissedCompleter = Completer();
    late OverlayEntry entry;
    LeoModalRoute? route;
    GlobalKey<_ModalWidgetState> childKey =
        GlobalKey<_ModalWidgetState>(debugLabel: "Leoui_modal");

    _ModalWidget modalWidget = _ModalWidget(
        key: childKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return childBuilder.call(context);
          },
        ),
        direction: direction ?? ModalDirection.center,
        duration: duration ?? Duration(milliseconds: 3000),
        closeOnClickMask: closeOnClickMask,
        noMask: noMask ?? false,
        maskAlpha: maskAlpha ?? 0.7,
        curve: curve ?? Curves.easeIn,
        autoClose: autoClose ?? false,
        dragToClose: dragToClose,
        dragToCloseGap: dragToCloseGap ?? 30,
        dragToCloseVelocity: dragToCloseVelocity ?? 0.1,
        animateWhenOpen: animateWhenOpen ?? true,
        fixed: fixed ?? false,
        reverseAnimationWhenClose: reverseAnimationWhenClose);

    entry = OverlayEntry(
        builder: (ctx) {
          bool _modalRoute =
              ctx.findRootAncestorStateOfType<NavigatorState>() != null;
          return ModalScope(
            child: modalWidget,
            entry: entry,
            dismissCompleter: dismissedCompleter,
            childKey: childKey,
            onClose: onClose,
            routeContext: _modalRoute ? ctx : null,
            route: route,
            reverseAnimationWhenClose: reverseAnimationWhenClose,
          );
        },
        maintainState: true);

    route = LeoModalRoute(entry);

    return Modal.raw(
        childBuilder: childBuilder,
        entry: entry,
        dismissCompleter: dismissedCompleter,
        modalWidgetKey: childKey,
        onClose: onClose,
        route: route);
  }

  Modal.raw(
      {required this.entry,
      required this.dismissCompleter,
      required this.modalWidgetKey,
      required this.route,
      required this.childBuilder,
      this.onClose,
      this.fixed = false});
}

class ModalScope extends InheritedWidget {
  final _ModalWidget child;
  final GlobalKey<_ModalWidgetState> childKey;
  final OverlayEntry? entry;
  final bool? reverseAnimationWhenClose;
  final Completer? dismissCompleter;
  final ValueChanged<bool>? onClose;
  final BuildContext? routeContext;
  final LeoModalRoute? route;
  void closeModal(
      {dynamic data, bool autoColse = false, bool animation = true}) async {
    if (reverseAnimationWhenClose == true && animation) {
      await childKey.currentState!.reverseAnimation();
    }

    if (routeContext != null) {
      // Todo how to pass data back???????
      // Navigator.of(routeContext!).removeRoute(route!);
      Navigator.of(routeContext!).pop(data);
    } else {
      entry?.remove();
    }
    if (onClose != null) {
      onClose!(autoColse);
    }
    if (!dismissCompleter!.isCompleted) {
      dismissCompleter!.complete(data);
    }
  }

  ModalScope(
      {required this.child,
      required this.childKey,
      this.routeContext,
      this.route,
      this.entry,
      this.dismissCompleter,
      this.onClose,
      this.reverseAnimationWhenClose})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant ModalScope oldWidget) => false;

  static ModalScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModalScope>();
  }
}

class _ModalWidget extends StatefulWidget {
  final ModalDirection direction;
  final Widget child;
  final Duration duration;
  final bool autoClose;
  final bool reverseAnimationWhenClose;
  final bool animateWhenOpen;
  final bool closeOnClickMask;
  final bool dragToClose;
  final double dragToCloseGap;
  final double dragToCloseVelocity;
  final bool noMask;
  final double maskAlpha;
  final Curve curve;
  final bool fixed;

  _ModalWidget(
      {Key? key,
      required this.direction,
      required this.child,
      required this.duration,
      required this.autoClose,
      required this.reverseAnimationWhenClose,
      required this.animateWhenOpen,
      required this.curve,
      required this.dragToClose,
      required this.dragToCloseGap,
      required this.dragToCloseVelocity,
      required this.closeOnClickMask,
      required this.noMask,
      required this.maskAlpha,
      this.fixed = false})
      : super(key: key);
  @override
  _ModalWidgetState createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<_ModalWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _slide;

  Timer? autoCloseCounter;

  double? _left;
  double? _top;
  double? _right;
  double? _bottom;

  int tragStartTime = 0;
  double tragVelocity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _slide = Tween<double>(begin: -1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve)
          ..addListener(() {
            setState(() {});
          }));

    if (widget.animateWhenOpen) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }

    if (widget.autoClose) {
      autoCloseCounter = Timer(widget.duration, () {
        ModalScope.of(context)?.closeModal(animation: true);
      });
    }

    switch (widget.direction) {
      case ModalDirection.left:
        _left = 0;
        _top = 0;
        _bottom = 0;
        break;

      case ModalDirection.top:
        _left = 0;
        _right = 0;
        _top = 0;
        break;

      case ModalDirection.right:
        _right = 0;
        _top = 0;
        _bottom = 0;
        break;

      case ModalDirection.bottom:
        _top = null;
        _bottom = 0;
        break;

      case ModalDirection.center:
        _left = 0;
        _right = 0;
        _top = 0;
        _bottom = 0;

        break;
    }
  }

  @override
  void deactivate() {
    if (!ModalScope.of(context)!.dismissCompleter!.isCompleted) {
      ModalScope.of(context)?.dismissCompleter?.complete();
      if (ModalScope.of(context)?.onClose != null) {
        ModalScope.of(context)?.onClose!(false);
      }
    }

    super.deactivate();
  }

  @override
  void didChangeMetrics() {
    if (widget.direction != ModalDirection.top && !widget.fixed) {
      setState(() {});
    }

    super.didChangeMetrics();
  }

  void changePostionBottom() {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future reverseAnimation() => _controller.reverse();

  void _handleMaskTap() {
    if (widget.closeOnClickMask) {
      ModalScope.of(context)?.closeModal();
      autoCloseCounter?.cancel();
    }
  }

  void resetCounter() {
    if (autoCloseCounter != null && !autoCloseCounter!.isActive) {
      autoCloseCounter = Timer(widget.duration, () {
        ModalScope.of(context)?.closeModal();
      });
    }
  }

  void handleClose() async {
    await reverseAnimation();
    ModalScope.of(context)?.closeModal();
  }

  @override
  Widget build(BuildContext context) {
    Offset _offset;

    bool isTop = widget.direction == ModalDirection.top;
    bool isBottom = widget.direction == ModalDirection.bottom;

    bool isLeft = widget.direction == ModalDirection.left;
    bool isRight = widget.direction == ModalDirection.right;

    MediaQueryData windowData = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    double windowPadddingBottom = windowData.viewInsets.bottom;

    switch (widget.direction) {
      case ModalDirection.left:
        _offset = Offset(_slide.value, 0);
        break;

      case ModalDirection.top:
        _offset = Offset(0, _slide.value);
        break;

      case ModalDirection.right:
        _offset = Offset((_slide.value.abs()), 0);
        break;

      case ModalDirection.bottom:
        _offset = Offset(0, _slide.value.abs());
        break;

      case ModalDirection.center:
        _offset = Offset.zero;
        break;
    }

    List<Widget> _children = [];

    if (!widget.noMask) {
      _children.add(
        Positioned.fill(
            child: GestureDetector(
          onTap: _handleMaskTap,
          child: Container(
            color: Colors.black.withValues(alpha: widget.maskAlpha),
          ),
        )),
      );
    }

    late Widget child;

    if (widget.direction == ModalDirection.center) {
      child = Center(
        child: Transform.scale(
          scale: 1.0 + _slide.value,
          child: Opacity(
              opacity: (1.0 + _slide.value).clamp(0, 1), child: widget.child),
        ),
      );
    } else {
      child = FractionalTranslation(
          translation: _offset,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: SizeTool.deviceHeight - (_bottom ?? 0),
                maxWidth: SizeTool.deviceWidth),
            child: widget.dragToClose
                ? GestureDetector(
                    child: widget.child,
                    onTapDown: (_) {
                      autoCloseCounter?.cancel();
                    },
                    onTapCancel: () {
                      this.resetCounter();
                    },
                    onVerticalDragStart: (_) {
                      if (!isTop && !isBottom) return;
                      autoCloseCounter?.cancel();
                      tragStartTime = DateTime.now().millisecondsSinceEpoch;
                    },
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      if (!isTop && !isBottom) return;

                      if (isTop) {
                        double dragTop = _top! + details.delta.dy;
                        if (dragTop < 0) {
                          setState(() {
                            _top = dragTop;
                          });
                        }
                      }

                      if (isBottom) {
                        double dragBottom = _bottom! - details.delta.dy;

                        if (dragBottom < windowPadddingBottom) {
                          setState(() {
                            _bottom = dragBottom;
                          });
                        }
                      }
                    },
                    onVerticalDragEnd: (_) {
                      if (!isTop && !isBottom) return;
                      int tragEndTime = DateTime.now().millisecondsSinceEpoch;

                      bool achieveLimit = false;
                      if (isTop) {
                        tragVelocity =
                            _top!.abs() / (tragEndTime - tragStartTime);
                        achieveLimit =
                            tragVelocity > widget.dragToCloseVelocity ||
                                _top!.abs() > widget.dragToCloseGap;

                        if (_top! < 0 && achieveLimit) {
                          handleClose();
                        } else {
                          setState(() {
                            _top = 0;
                          });
                          resetCounter();
                        }
                      } else if (isBottom) {
                        tragVelocity =
                            _bottom!.abs() / (tragEndTime - tragStartTime);
                        achieveLimit =
                            tragVelocity > widget.dragToCloseVelocity ||
                                _bottom!.abs() > widget.dragToCloseGap;

                        if (_bottom! < windowPadddingBottom && achieveLimit) {
                          handleClose();
                        } else {
                          setState(() {
                            _bottom = 0;
                          });
                          resetCounter();
                        }
                      }
                    },
                    onHorizontalDragStart: (_) {
                      if (!isLeft && !isRight) return;
                      autoCloseCounter?.cancel();
                      tragStartTime = DateTime.now().millisecondsSinceEpoch;
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      if (!isLeft && !isRight) return;
                      if (isLeft) {
                        double dragLeft = _left! + details.delta.dx;
                        if (dragLeft < 0) {
                          setState(() {
                            _left = dragLeft;
                          });
                        }
                      }

                      if (isRight) {
                        double dragRight = _right! - details.delta.dx;
                        if (dragRight < 0) {
                          setState(() {
                            _right = dragRight;
                          });
                        }
                      }
                    },
                    onHorizontalDragEnd: (_) {
                      if (!isLeft && !isRight) return;
                      int tragEndTime = DateTime.now().millisecondsSinceEpoch;
                      tragVelocity =
                          _top!.abs() / (tragEndTime - tragStartTime);

                      bool achieveLimit = false;
                      if (isLeft) {
                        achieveLimit =
                            tragVelocity > widget.dragToCloseVelocity ||
                                _left!.abs() > widget.dragToCloseGap;

                        if (_left! < 0 && achieveLimit) {
                          handleClose();
                        } else {
                          setState(() {
                            _left = 0;
                          });
                          resetCounter();
                        }
                      } else if (isRight) {
                        achieveLimit =
                            tragVelocity > widget.dragToCloseVelocity ||
                                _right!.abs() > widget.dragToCloseGap;

                        if (_right! < 0 && achieveLimit) {
                          handleClose();
                        } else {
                          setState(() {
                            _right = 0;
                          });
                          resetCounter();
                        }
                      }
                    },
                  )
                : widget.child,
          ));
    }

    MediaQueryData mqData = MediaQueryData.fromView(View.of(context));

    double? calcBottom = (_bottom != null && widget.fixed != true)
        ? mqData.viewInsets.bottom + (_bottom ?? 0)
        : null;

    double? calcTop = _top;

    if (widget.dragToClose && isBottom && calcBottom != null) {
      calcTop = calcBottom * -1;
    }

    _children.add(Positioned(
        left: _left,
        top: calcTop,
        right: _right,
        bottom: calcBottom,
        child: child));

    return DefaultTextStyle(
      style: TextStyle(),
      child: Stack(
        fit: StackFit.expand,
        children: _children,
      ),
    );
  }
}
