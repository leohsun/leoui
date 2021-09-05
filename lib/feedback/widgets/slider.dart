part of leoui.feedback;

class Slider extends StatefulWidget {
  final SliderDirection? direction;
  final Widget child;
  final Duration? duration;
  final bool closeOnClickMask;
  final bool noMask;
  final Curve curve;

  const Slider(
      {Key? key,
      this.direction,
      required this.child,
      this.duration,
      this.curve = Curves.linearToEaseOut,
      this.closeOnClickMask = false,
      this.noMask = false})
      : super(key: key);
  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<Slider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: widget.duration ?? Duration(milliseconds: 300));

    _slide = Tween<double>(begin: -1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve)
          ..addListener(() {
            setState(() {});
          }));

    _controller.forward();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (Feedback.shouldCallAfterSliderWidgetCreatedFunctions.length > 0) {
        Feedback.shouldCallAfterSliderWidgetCreatedFunctions.forEach((cb) {
          cb();
        });
        Feedback.shouldCallAfterSliderWidgetCreatedFunctions.clear();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future reverseAnimation() => _controller.reverse();

  void _handleMaskTap() {
    if (widget.closeOnClickMask) {
      hideSlider();
    }
  }

  @override
  Widget build(BuildContext context) {
    SliderDirection _direction = widget.direction ?? SliderDirection.center;
    Offset _offset;
    switch (_direction) {
      case SliderDirection.left:
        _offset = Offset(_slide.value, 0);
        break;
      case SliderDirection.top:
        _offset = Offset(0, _slide.value);
        break;
      case SliderDirection.right:
        _offset = Offset((_slide.value.abs()), 0);
        break;
      case SliderDirection.bottom:
        _offset = Offset(0, _slide.value.abs());
        break;
      case SliderDirection.center:
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
            color: Colors.black.withOpacity(0.15),
          ),
        )),
      );
    }

    if (widget.direction == SliderDirection.center) {
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
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: FractionalTranslation(
              translation: _offset, child: widget.child)));
    }

    return Stack(
      fit: StackFit.expand,
      children: _children,
    );
  }
}
