import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leoui/leoui_state.dart';

class LeoBadge extends StatefulWidget {
  final Offset? offset;
  final num? count;
  final bool? hideWhenZero;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Widget child;
  final Future<num> Function()? service;
  const LeoBadge(
      {super.key,
      required this.child,
      this.offset = Offset.zero,
      this.count = 0,
      this.textColor,
      this.backgroundColor,
      this.indicatorColor,
      this.hideWhenZero = true,
      this.service});

  @override
  State<LeoBadge> createState() => LeoBadgeState();
}

class LeoBadgeState extends State<LeoBadge> {
  late num count;

  bool loading = false;

  @override
  void initState() {
    count = widget.count ?? 0;
    Future.microtask(refresh);
    super.initState();
  }

  void refresh() async {
    if (widget.service == null) return;
    this.setState(() {
      loading = true;
    });
    final count_ = await widget.service!();
    this.setState(() {
      count = count_;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(context);
    String countText = count > 99 ? "99+" : '$count';
    double textPandding = theme.size!().tertiary / 3;
    Color backgroudColor = widget.backgroundColor ?? theme.userAccentColor;
    bool textHidden = countText == "0" && widget.hideWhenZero == true;

    double textWidth = 0;
    double textHeight = 0;

    if (!textHidden) {
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: countText,
              style: TextStyle(
                  color: widget.textColor ?? Colors.white,
                  height: 1,
                  fontSize: theme.size!().tertiary)),
          textDirection: TextDirection.ltr);
      textPainter.layout();
      textWidth = textPainter.width + textPandding;
      textHeight = textPainter.height + textPandding;
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topEnd,
      children: [
        widget.child,
        Positioned(
          right: -widget.offset!.dx - max(textWidth, textHeight),
          top: 0 + widget.offset!.dy,
          child: Container(
            alignment: Alignment.center,
            constraints:
                BoxConstraints(minWidth: textHeight, minHeight: textHeight),
            padding: EdgeInsets.symmetric(horizontal: textPandding / 2),
            decoration: BoxDecoration(
                color: (loading || textHidden)
                    ? Colors.transparent
                    : backgroudColor,
                borderRadius: BorderRadius.circular(theme.size!().tertiary)),
            child: loading
                ? SizedBox(
                    width: textHeight,
                    height: textHeight,
                    child: CircularProgressIndicator(
                      color: widget.indicatorColor ?? Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : textHidden
                    ? SizedBox.shrink()
                    : Text(
                        countText,
                        style: TextStyle(
                            color: widget.textColor ?? Colors.white,
                            height: 1,
                            fontSize: theme.size!().tertiary),
                      ),
          ),
        )
      ],
    );
  }
}
