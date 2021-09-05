part of leoui.feedback;

class FadeZoomBox extends StatefulWidget {
  final Widget child;

  const FadeZoomBox({Key? key, required this.child}) : super(key: key);
  @override
  _FadeZoomBoxState createState() => _FadeZoomBoxState();
}

class _FadeZoomBoxState extends State<FadeZoomBox>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  Future reverseAnimation() async {
    await controller!.reverse();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.easeIn))
          ..addListener(() {
            setState(() {});
          });
    controller!.forward();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (Feedback.uniqueGlobalStateKey == Feedback.loadingGlobalKey) {
        Feedback.loadingWidgetCreated = true;

        print('fadeZoombox created');
      }
      if (Feedback.shouldCallAfterFadeZoomBoxWidgetCreatedFunctions.length >
          0) {
        Feedback.shouldCallAfterFadeZoomBoxWidgetCreatedFunctions.forEach((cb) {
          cb();
        });
        Feedback.shouldCallAfterFadeZoomBoxWidgetCreatedFunctions.clear();
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: animation!.value,
      child: Opacity(
        opacity: animation!.value,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
