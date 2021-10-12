import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/config/size.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/ui/index.dart';
import 'package:leoui/ui/packages/inputItem/inputItem.dart';
import 'package:leoui/utils/index.dart';

class SearchBar extends StatefulWidget {
  final String? searchText;
  final String? placeholder;
  final String? defaultkeywords;
  final ValueChanged<String> onSubmit;
  const SearchBar(
      {Key? key,
      this.searchText,
      this.placeholder,
      this.defaultkeywords,
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
  Widget build(BuildContext context) {
    return Container(
      height: sz(LeoSize.itemExtent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: sz(LeoSize.cardBorderRadius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                  ),
                  _controller.status == AnimationStatus.dismissed
                      ? Text(
                          widget.placeholder ??
                              LeouiLocalization.of(context).search,
                          style: TextStyle(
                              fontSize: sz(LeoSize.fontSize.title),
                              color: LeoTheme.of(context).labelSecondaryColor),
                        )
                      : SizedBox(
                          width: sz(LeoSize.fontSize.title / 3),
                        ),
                  Expanded(
                    child: InputItem(
                      onChanged: (_keywords) {
                        keywords = _keywords;
                      },
                      onFocus: (_) {
                        _controller.forward();
                      },
                      key: input,
                      defaultValue: keywords,
                    ),
                  ),
                ],
              ),
              height: sz(LeoSize.itemExtent),
              decoration: BoxDecoration(
                  color: LeoTheme.of(context).fillQuarternaryColor,
                  borderRadius:
                      BorderRadius.circular(sz(LeoSize.cardBorderRadius))),
            ),
          ),
          AnimatedBuilder(
              animation: _controller,
              child: Padding(
                child: Button(
                  widget.searchText ?? LeouiLocalization.of(context).search,
                  onTap: () {
                    String keywords =
                        (input.currentState as InputItemState).blur();
                    if (keywords.isEmpty) {
                      _controller.reverse();
                    } else {
                      widget.onSubmit(keywords);
                    }
                  },
                ),
                padding: EdgeInsets.only(left: sz(LeoSize.cardBorderRadius)),
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
