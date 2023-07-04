import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class SearchBar extends StatefulWidget {
  final String? placeholder;
  final String? defaultkeywords;
  final ValueChanged<String> onSubmit;
  final LeouiBrightness? brightness;
  const SearchBar(
      {Key? key,
      this.placeholder,
      this.defaultkeywords,
      this.brightness,
      required this.onSubmit})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late String keywords;

  GlobalKey input = GlobalKey();

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
    LeouiThemeData theme = widget.brightness == null
        ? LeouiTheme.of(context)
        : LeouiTheme.of(context).copyWith(brightness: widget.brightness);
    return Container(
      height: theme.size!().itemExtent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: theme.size!().cardBorderRadius),
              child: InputItem(
                brightness: widget.brightness,
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
              height: theme.size!().itemExtent,
              decoration: BoxDecoration(
                  color: theme.fillTertiaryColor,
                  borderRadius:
                      BorderRadius.circular(theme.size!().cardBorderRadius)),
            ),
          ),
          AnimatedBuilder(
              animation: _animation,
              child: Padding(
                child: GestureDetector(
                    child: Center(
                      child: Text(
                          LeouiLocalization.of(LeoFeedback.currentContext!)
                              .cancel,
                          style: TextStyle(
                              color: theme.labelPrimaryColor,
                              fontSize: theme.size!().title)),
                    ),
                    onTap: () {
                      (input.currentState as InputItemState).clear();
                      (input.currentState as InputItemState).blur();
                      _controller.reverse();
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
