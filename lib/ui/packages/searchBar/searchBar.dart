import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class SearchBar extends StatefulWidget {
  final String? placeholder;
  final String? defaultkeywords;
  final ValueChanged<String> onSubmit;
  final LeouiBrightness? brightness;
  final VoidCallback? onCancel;
  final String? cancelText;
  final bool focus;
  const SearchBar(
      {Key? key,
      this.placeholder,
      this.defaultkeywords,
      this.brightness,
      required this.onSubmit,
      this.onCancel,
      this.cancelText,
      this.focus = false})
      : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late String keywords;

  GlobalKey<InputItemState> input = GlobalKey();

  void clear() {
    input.currentState?.clear();
  }

  void blur() {
    input.currentState?.blur();
  }

  void focus() {
    input.currentState?.focus();
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });
    keywords = widget.defaultkeywords ?? '';
    if (keywords.isNotEmpty) {
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
  Widget build(BuildContext context) {
    LeouiThemeData theme =
        LeouiTheme.of(context)!.theme(brightness: widget.brightness);
    return Container(
      height: theme.size!().itemExtent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: theme.size!().cardBorderRadius),
              height: theme.size!().itemExtent,
              decoration: BoxDecoration(
                  color: theme.fillTertiaryColor,
                  borderRadius:
                      BorderRadius.circular(theme.size!().cardBorderRadius)),
              child: InputItem(
                focus: widget.focus,
                brightness: widget.brightness,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.search,
                ),
                solid: false,
                placeholder: widget.placeholder ??
                    LeouiLocalization.of(LeoFeedback.currentContext!).search,
                onChanged: (_keywords) {
                  keywords = _keywords;
                },
                onFocus: (_) {
                  _controller.forward();
                },
                key: input,
                onSubmit: widget.onSubmit,
                defaultValue: keywords,
                inputAction: TextInputAction.search,
              ),
            ),
          ),
          AnimatedBuilder(
              animation: _animation,
              child: Padding(
                child: GestureDetector(
                    child: Center(
                      child: Text(
                          widget.cancelText ??
                              LeouiLocalization.of(LeoFeedback.currentContext!)
                                  .cancel,
                          style: TextStyle(
                              color: theme.labelPrimaryColor,
                              fontSize: theme.size!().title)),
                    ),
                    onTap: () {
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      } else {
                        (input.currentState as InputItemState).clear();
                        (input.currentState as InputItemState).blur();
                        _controller.reverse();
                      }
                    }),
                padding: EdgeInsets.only(left: theme.size!().cardBorderRadius),
              ),
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: child,
                    widthFactor: _animation.value,
                  ),
                );
              })
        ],
      ),
    );
  }
}
