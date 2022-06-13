import 'package:flutter/material.dart';
import 'package:leoui/config/index.dart';
import 'package:leoui/utils/index.dart';

class ActionSheetAction {
  final String text;
  final ValueChanged<BuildContext>? onTap;

  ActionSheetAction(this.text, {this.onTap});
}

class ActionSheet extends StatelessWidget {
  final LeouiBrightness? brightness;
  final String? title; //窗口标题
  final List<ActionSheetAction> actions;
  final VoidCallback? onCancel;
  const ActionSheet(
      {Key? key,
      required this.actions,
      this.brightness,
      this.title,
      this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LeouiThemeData theme = brightness == null
        ? LeouiTheme.of(context)
        : LeouiTheme.of(context).copyWith(brightness: brightness);

    List<Widget> _children = [];

    double dividerHeight = 0.6;

    Divider divider = Divider(
      height: dividerHeight,
      color: theme.opaqueSeparatorColor,
    );

    if (title != null) {
      _children.add(Container(
        height: theme.size!().itemExtent * 1.2,
        alignment: Alignment.center,
        child: Text(
          title!,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: theme.size!().title, color: theme.labelPrimaryColor),
        ),
      ));

      _children.add(divider);
    }

    Column actionWidget = Column(
        children: mapWithIndex(actions, (d, i) {
      if (i != actions.length - 1) {
        return Column(
          children: [
            buildButtonWidget(
                splashColor: theme.opaqueSeparatorColor,
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: theme.size!().itemExtent / 2),
                    height: theme.size!().buttonNormalHeight,
                    child: Text(
                      d.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.labelPrimaryColor,
                          fontSize: theme.size!().content),
                    )),
                onPress: d.onTap != null
                    ? () {
                        d.onTap?.call(context);
                      }
                    : null),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: theme.size!().itemExtent / 2),
              child: divider,
            )
          ],
        );
      } else {
        return buildButtonWidget(
            splashColor: theme.opaqueSeparatorColor,
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: theme.size!().itemExtent / 2),
                height: theme.size!().buttonNormalHeight,
                child: Text(d.text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.labelPrimaryColor,
                        fontSize: theme.size!().content))),
            onPress: d.onTap != null
                ? () {
                    d.onTap?.call(context);
                  }
                : null);
      }
    }));

    _children.add(actionWidget);

    _children.add(Container(
      height: dividerHeight * 6,
      color: theme.opaqueSeparatorColor,
    ));

    _children.add(buildButtonWidget(
        splashColor: theme.opaqueSeparatorColor,
        onPress: onCancel,
        child: Container(
          height:
              theme.size!().buttonNormalHeight + SizeTool.devicePadding.bottom,
          padding: EdgeInsets.only(bottom: SizeTool.devicePadding.bottom),
          alignment: Alignment.center,
          child: Text(LeouiLocalization.of(context).cancel),
        )));

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.size!().cardBorderRadius),
          topRight: Radius.circular(theme.size!().cardBorderRadius)),
      child: Container(
        width: double.infinity,
        color: theme.dialogBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _children,
        ),
      ),
    );
  }
}
