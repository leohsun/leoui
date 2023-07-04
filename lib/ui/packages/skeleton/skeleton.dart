import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/utils/index.dart';

class Skeleton extends StatefulWidget {
  final Widget? child;
  const Skeleton({Key? key, this.child}) : super(key: key);

  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _tweenAnimation;
  late AnimationController _tween;

  @override
  void initState() {
    _tween = AnimationController(vsync: this, duration: Duration(seconds: 2));

    _tweenAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _tween, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    _tween.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _tween.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.fillPrimaryColor,
                theme.fillPrimaryColor,
                theme.fillQuarternaryColor,
                theme.fillPrimaryColor,
                theme.fillPrimaryColor
              ],
              stops: [
                0,
                _tweenAnimation.value - 0.1,
                _tweenAnimation.value,
                _tweenAnimation.value + 0.1,
                1
              ]).createShader(bounds);
        },
        child: widget.child ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: theme.size!().content,
                    color: Colors.white,
                    width: SizeTool.deviceWidth / 1.5),
                SizedBox(
                  height: theme.size!().secondary,
                ),
                Container(
                  height: theme.size!().content,
                  color: Colors.white,
                ),
                SizedBox(
                  height: theme.size!().secondary,
                ),
                Container(
                  height: theme.size!().content,
                  color: Colors.white,
                ),
                SizedBox(
                  height: theme.size!().secondary,
                ),
                Container(
                    height: theme.size!().content,
                    color: Colors.white,
                    width: SizeTool.deviceWidth / 1.5),
              ],
            ));
  }
}
