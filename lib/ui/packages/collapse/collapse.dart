import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';

class Collapse extends StatefulWidget {
  final String title;
  final List<Widget> childern;
  final Color leadingColor;
  final Widget? header;

  const Collapse(
      {Key? key,
      required this.title,
      required this.childern,
      this.header,
      this.leadingColor = LeoColors.primary})
      : super(key: key);

  @override
  _CollapseState createState() => _CollapseState();
}

class _CollapseState extends State<Collapse> with TickerProviderStateMixin {
  bool expanded = false;
  double expandValue = 0;
  void onExpanding(value) {
    setState(() {
      expandValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhysicalModel(
          color: Colors.white,
          elevation: theme.size!().itemElevation,
          child: GestureDetector(
            onTap: () {
              this.setState(() {
                expanded = !expanded;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.backgroundPrimaryColor,
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
                      style: TextStyle(fontSize: theme.size!().title),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(expandValue / 2 * 3.1415926),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: theme.size!().content,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        // ClipRRect(
        //   child: Align(
        //       heightFactor: _tween.value,
        //       child: Container(
        //         color: theme.backgroundSecondaryColor,
        //         width: double.infinity,
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: widget.childern,
        //         ),
        //       )),
        // ),
        CollaspeContainer(
          child: Column(children: widget.childern),
          expanded: expanded,
          onExpanding: onExpanding,
        )
      ],
    );
  }
}

enum CollaspeDirection { horizontal, vertical }

class CollaspeContainer extends StatefulWidget {
  final Widget child;
  final CollaspeDirection? direction;
  final bool expanded;
  final ValueChanged<double>? onExpanding;

  const CollaspeContainer(
      {Key? key,
      required this.child,
      required this.expanded,
      this.onExpanding,
      this.direction = CollaspeDirection.vertical})
      : super(key: key);

  @override
  State<CollaspeContainer> createState() => _CollaspeContainerState();
}

class _CollaspeContainerState extends State<CollaspeContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation _tween;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 150));
    _tween = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (widget.onExpanding != null) {
          widget.onExpanding!(_controller.value);
        }
        setState(() {});
      });

    if (widget.expanded) {
      _controller.value = 1;
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CollaspeContainer oldWidget) {
    if (oldWidget.expanded != widget.expanded) {
      hanldeExpaned(widget.expanded);
    }
    super.didUpdateWidget(oldWidget);
  }

  void hanldeExpaned(bool expanded) {
    if (expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Align(
          heightFactor:
              widget.direction == CollaspeDirection.vertical ? _tween.value : 1,
          widthFactor: widget.direction == CollaspeDirection.horizontal
              ? _tween.value
              : 1,
          child: widget.child),
    );
  }
}
