import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leoui/widget/leoui_state.dart';

class LeoBadge extends StatefulWidget {
  final Offset? offset;
  final num? count;
  final bool? hideWhenZero;
  final Color? textColor;
  final double? textFontSize;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Widget child;
  final bool? dotted;
  final Future<int> Function()? service;
  const LeoBadge(
      {super.key,
      required this.child,
      this.offset = Offset.zero,
      this.count = 0,
      this.textColor,
      this.textFontSize,
      this.backgroundColor,
      this.indicatorColor,
      this.hideWhenZero = true,
      this.dotted = false,
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
  void didUpdateWidget(covariant LeoBadge oldWidget) {
    if (oldWidget.count == widget.count) return;

    setState(() {
      count = widget.count ?? 0;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = LeouiTheme.of(LeoFeedback.currentContext!)!.theme();
    String countText = count > 99 ? "99+" : '$count';
    double textPandding = (widget.textFontSize ?? theme.size!().tertiary) / 3;
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
                  fontSize: widget.textFontSize ?? theme.size!().tertiary)),
          textDirection: TextDirection.ltr);
      textPainter.layout();
      textWidth = textPainter.width + textPandding;
      textHeight = textPainter.height + textPandding;
    }

    double fontSize = widget.textFontSize ?? theme.size!().tertiary;
    Color fontColor = widget.textColor ?? Colors.white;

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
                color: (loading || textHidden || widget.dotted == true)
                    ? Colors.transparent
                    : backgroudColor,
                borderRadius: BorderRadius.circular(
                    widget.textFontSize ?? theme.size!().tertiary)),
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
                    : widget.dotted == true
                        ? Container(
                            width: fontSize,
                            height: fontSize,
                            decoration: BoxDecoration(
                                color: fontColor, shape: BoxShape.circle),
                          )
                        : Text(
                            countText,
                            style: TextStyle(
                                color: fontColor,
                                height: 1,
                                fontSize: fontSize),
                          ),
          ),
        )
      ],
    );
  }
}
