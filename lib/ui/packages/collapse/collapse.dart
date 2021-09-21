import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';

class Collapse extends StatefulWidget {
  final String title;
  final List<Widget> childern;
  final Color leadingColor;

  const Collapse(
      {Key? key,
      required this.title,
      required this.childern,
      this.leadingColor = LeoColors.primary})
      : super(key: key);

  @override
  _CollapseState createState() => _CollapseState();
}

class _CollapseState extends State<Collapse> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tween;
  bool expanded = false;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _tween = Tween<double>(begin: 0, end: 0.5).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhysicalModel(
          color: Colors.white,
          elevation: LeoSize.itemElevation,
          child: GestureDetector(
            onTap: () {
              if (expanded) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
              this.setState(() {
                expanded = !expanded;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff9fafb),
                border: Border(
                    left: BorderSide(width: 2, color: widget.leadingColor)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: LeoSize.fontSize.title),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(_tween.value * 3.1415926),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: LeoSize.fontSize.content,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: expanded ? widget.childern : [],
              ),
            ))
      ],
    );
  }
}
