part of leoui.feedback;

enum ModalDirection { left, top, right, bottom, center }

class Modal {
  final Widget child;
  final OverlayEntry entry;
  final bool gestureResponds;

  final Completer dismissCompleter;

  get dissmissed => dismissCompleter.future;

  void completedWithPayload(payload) {
    if (dismissCompleter.isCompleted) return;
    dismissCompleter.complete(payload);
  }

  void close([payload]) {
    if (!dismissCompleter.isCompleted) {
      dismissCompleter.complete(payload);
    }
    entry.remove();
  }

  factory Modal(
      {required Widget child,
      ModalDirection? direction,
      Duration? duration,
      bool? closeOnClickMask,
      bool? noMask,
      bool? autoClose,
      bool? gestureResponds,
      bool? reverseAnimationWhenClose,
      Curve? curve}) {
    assert(autoClose != true || closeOnClickMask != true,
        'can not provide both autoColse and closeOnClickMask are \'ture\' value');

    reverseAnimationWhenClose ??= false;
    closeOnClickMask ??= false;
    gestureResponds ??= false;
    Completer dismissedCompleter = Completer();
    OverlayEntry? entry;
    GlobalKey<_ModalWidgetState> childKey =
        GlobalKey<_ModalWidgetState>(debugLabel: "Leoui_modal");

    _ModalWidget modalWidget = _ModalWidget(
        key: childKey,
        child: child,
        direction: direction ?? ModalDirection.center,
        duration: duration ?? Duration(milliseconds: 3000),
        closeOnClickMask: closeOnClickMask,
        noMask: noMask ?? false,
        curve: curve ?? Curves.easeInOut,
        autoClose: autoClose ?? false,
        gestureResponds: gestureResponds,
        reverseAnimationWhenClose: reverseAnimationWhenClose);

    entry = OverlayEntry(
        builder: (ctx) => ModalScope(
              child: modalWidget,
              entry: entry,
              dismissCompleter: dismissedCompleter,
              childKey: childKey,
              reverseAnimationWhenClose: reverseAnimationWhenClose,
            ));

    return Modal.raw(
        child: modalWidget,
        entry: entry,
        dismissCompleter: dismissedCompleter,
        gestureResponds: gestureResponds);
  }

  Modal.raw(
      {required this.child,
      required this.entry,
      required this.dismissCompleter,
      required this.gestureResponds});
}

class ModalScope extends InheritedWidget {
  final _ModalWidget child;
  final GlobalKey<_ModalWidgetState> childKey;
  final OverlayEntry? entry;
  final bool? reverseAnimationWhenClose;
  final Completer? dismissCompleter;
  void closeModal([data]) async {
    if (reverseAnimationWhenClose == true) {
      await childKey.currentState!.reverseAnimation();
    }
    entry?.remove();
    if (!dismissCompleter!.isCompleted) {
      dismissCompleter!.complete(data);
    }
  }

  ModalScope(
      {required this.child,
      required this.childKey,
      this.entry,
      this.dismissCompleter,
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
  final bool closeOnClickMask;
  final bool gestureResponds;
  final bool noMask;
  final Curve curve;

  _ModalWidget(
      {Key? key,
      required this.direction,
      required this.child,
      required this.duration,
      required this.autoClose,
      required this.reverseAnimationWhenClose,
      required this.curve,
      required this.gestureResponds,
      required this.closeOnClickMask,
      required this.noMask})
      : super(key: key);
  @override
  _ModalWidgetState createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<_ModalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _slide = Tween<double>(begin: -1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve)
          ..addListener(() {
            setState(() {});
          }));

    _controller.forward();

    if (widget.autoClose) {
      startCounter();
    }
  }

  @override
  void deactivate() {
    if (!ModalScope.of(context)!.dismissCompleter!.isCompleted) {
      ModalScope.of(context)?.dismissCompleter?.complete();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future reverseAnimation() => _controller.reverse();

  void startCounter() async {
    await Future.delayed(widget.duration)
        .then((value) => ModalScope.of(context)?.closeModal());
  }

  void _handleMaskTap() {
    if (widget.closeOnClickMask) {
      ModalScope.of(context)?.entry!.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    Offset _offset;
    double? _left;
    double? _top;
    double? _right;
    double? _bottom;

    switch (widget.direction) {
      case ModalDirection.left:
        _offset = Offset(_slide.value, 0);
        _left = 0;
        _top = 0;
        _bottom = 0;

        break;
      case ModalDirection.top:
        _offset = Offset(0, _slide.value);
        _left = 0;
        _top = 0;
        _right = 0;
        break;
      case ModalDirection.right:
        _offset = Offset((_slide.value.abs()), 0);
        _top = 0;
        _right = 0;
        _bottom = 0;
        break;
      case ModalDirection.bottom:
        _offset = Offset(0, _slide.value.abs());
        _left = 0;
        _right = 0;
        _bottom = 0;
        break;
      case ModalDirection.center:
        _offset = Offset.zero;
        _left = 0;
        _top = 0;
        _right = 0;
        _bottom = 0;
        break;
    }

    List<Widget> _children = [];

    if (!widget.noMask) {
      _children.add(
        Positioned.fill(
            child: GestureDetector(
          onTap: _handleMaskTap,
          child: Container(
            color: Colors.black.withOpacity(0.15),
          ),
        )),
      );
    }

    if (widget.direction == ModalDirection.center) {
      _children.add(Transform.scale(
        scale: 1.0 + _slide.value,
        child: Opacity(
            opacity: 1.0 + _slide.value,
            child: Center(
              child: widget.child,
            )),
      ));
    } else {
      _children.add(Positioned(
          left: _left,
          top: _top,
          right: _right,
          bottom: _bottom,
          child: FractionalTranslation(
              translation: _offset, child: widget.child)));
    }

    return Stack(
      fit: StackFit.expand,
      children: _children,
    );
  }
}
