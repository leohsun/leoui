import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/ui/packages/common/common.dart';
import 'package:leoui/utils/index.dart';

class NoticeBar extends StatefulWidget {
  final String content; // 通知内容
  final bool? round; // 圆形
  final bool? closable; // 关闭
  final bool? link; // 链接 可点击
  final bool scrollable; // true--> 内容超出，滚动显示 false-->折行
  final Icon? icon; // 左侧icon
  final Duration duration; // 关闭时间，默认
  final Color? color; // 通知字体颜色
  final VoidCallback? onClose; // /关闭回调，仅在closeable=true时生效
  final VoidCallback? onTap; // 点击noticeBar回调

  const NoticeBar(
      {Key? key,
      required this.content,
      this.round = false,
      this.closable,
      this.link,
      this.scrollable = false,
      this.icon,
      this.color,
      this.duration = Duration.zero,
      this.onClose,
      this.onTap})
      : assert(link != true || closable != true),
        super(key: key);

  @override
  _NoticeBarState createState() => _NoticeBarState();
}

class _NoticeBarState extends State<NoticeBar> {
  bool closed = false;

  double maxWidth = 0;

  ScrollController _scrollController = ScrollController();

  void _handleActionIconTab() {
    if (widget.closable == true) {
      setState(() {
        closed = !closed;
      });
      if (widget.onClose != null) {
        widget.onClose!();
      }
    }
  }

  @override
  void initState() {
    if (widget.scrollable) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        LeouiThemeData theme = LeouiTheme.of(context)!.theme();
        int time = (_scrollController.position.maxScrollExtent /
                sz(theme.size!().title * 2))
            .floor();

        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(seconds: time), curve: Curves.linear);

        _scrollController.addListener(() {
          if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent) {
            _scrollController.jumpTo(0);
            Future.microtask(() => _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(seconds: time),
                curve: Curves.linear));
          }
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (closed) return SizedBox.shrink();

    LeouiThemeData theme = LeouiTheme.of(context)!.theme();

    Color color = widget.color ?? theme.userAccentColor;

    return LayoutBuilder(builder: (context, constrains) {
      maxWidth = constrains.maxWidth - sz(theme.size!().title * 2);
      if (widget.closable != null) {
        maxWidth -= sz(theme.size!().title * 1.5);
      }

      if (widget.link != null) {
        maxWidth -= sz(theme.size!().title * 1.5);
      }

      List<Widget> rowChildren = [];

      rowChildren.add(SizedBox(
        width: sz(theme.size!().title * 1.5),
        child: Center(
          child: widget.icon ?? SizedBox.shrink(),
        ),
      ));

      rowChildren.add(Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: sz(theme.size!().title / 3)),
          child: widget.scrollable == true
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: maxWidth,
                      ),
                      Text(
                        widget.content,
                        maxLines: 1,
                      ),
                      SizedBox(
                        width: maxWidth,
                      )
                    ],
                  ))
              : Text(
                  widget.content,
                ),
        ),
      ));

      rowChildren.add(widget.closable == true
          ? buildButtonWidget(
              onTap: _handleActionIconTab,
              child: Container(
                  width: sz(theme.size!().title * 1.5),
                  child: Center(
                    child: Icon(Icons.close_sharp),
                  )),
            )
          : SizedBox.shrink());

      rowChildren.add(widget.link == true
          ? buildButtonWidget(
              onTap: _handleActionIconTab,
              child: Container(
                  width: sz(theme.size!().title * 1.5),
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  )),
            )
          : SizedBox.shrink());

      return ClipRRect(
        borderRadius: widget.round == true
            ? BorderRadius.circular(300)
            : BorderRadius.zero,
        child: buildButtonWidget(
          onTap: widget.onTap,
          child: Container(
              width: constrains.maxWidth,
              decoration: BoxDecoration(
                  color: color..withValues(alpha: 0.05),
                  borderRadius: widget.round == true
                      ? BorderRadius.circular(300)
                      : BorderRadius.zero),
              child: DefaultTextIconStyle(
                color: color,
                size: theme.size!().secondary,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sz(theme.size!().title / 2)),
                    child: Row(
                      children: rowChildren,
                    ),
                  ),
                ),
              )),
        ),
      );
    });
  }
}
