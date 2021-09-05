part of leoui.feedback;

class Indicator extends StatefulWidget {
  final LeouiBrightness? brightness;

  const Indicator({Key? key, this.brightness}) : super(key: key);

  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  final List<double> delays = [.0, -0.8, -0.7, -0.6, -0.4, -0.3, -0.2, -0.1];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    _animationController!.repeat();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      child: Stack(
        children: List.generate(8, (i) {
          double _left = 38 * .5;
          return Positioned(
            left: _left,
            top: 0,
            child: Transform(
              origin: Offset(3, 44 / 2),
              transform: Matrix4.rotationZ(45 * i * 0.017453293),
              child: Align(
                alignment: Alignment.center,
                child: FadeTransition(
                  opacity: DelayTween(begin: 0.1, end: 1.0, delay: delays[i])
                      .animate(_animationController!),
                  child: Container(
                    width: 6,
                    height: 14,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
