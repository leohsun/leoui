import 'package:flutter/widgets.dart';
import 'package:leoui/widget/leoui_state.dart';

class ScalableText extends StatelessWidget {
  final String content;
  final double? minFontSize;
  final int? maxLines;
  final TextOverflow overflow;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  const ScalableText(this.content,
      {Key? key,
      this.minFontSize,
      this.maxLines = 1,
      this.overflow = TextOverflow.ellipsis,
      this.style,
      this.textDirection = TextDirection.ltr,
      this.textAlign = TextAlign.left})
      : super(key: key);

  static double? getTextScaleFactor(String text,
      {required BoxConstraints constraints,
      double? minFontSize,
      TextStyle? style,
      TextAlign? textAlign = TextAlign.start,
      TextDirection? textDirection = TextDirection.ltr,
      TextOverflow? overflow = TextOverflow.ellipsis,
      int? maxLines = 1}) {
    TextPainter _painter = TextPainter(
        text: TextSpan(
          text: text,
          style: style,
        ),
        textAlign: textAlign!,
        textScaler: TextScaler.noScaling,
        maxLines: maxLines,
        textDirection: textDirection);

    _painter.layout(maxWidth: constraints.maxWidth);
    double textScaleFactor = 1;

    bool isOverflow =
        _painter.didExceedMaxLines || _painter.height > constraints.maxHeight;

    if (isOverflow) {
      if (minFontSize == null) {
        return null;
      }

      double? currentTextFontSize = _painter.text!.style?.fontSize ??
          DefaultTextStyle.of(LeoFeedback.currentContext!).style.fontSize;

      double minTextScaleFactor =
          double.parse((minFontSize / currentTextFontSize!).toStringAsFixed(2));
      // scaleFactor = 1
      _painter.textScaler = TextScaler.linear(minTextScaleFactor);
      _painter.layout(maxWidth: constraints.maxWidth);
      bool isOverflowInMinScaleFactor = _painter.didExceedMaxLines;

      if (isOverflowInMinScaleFactor) {
        textScaleFactor = minTextScaleFactor;
      } else {
        // loop from [minTextScaleFactor] to [1]
        // locate the middle value to rudece loop times
        double step = (1 - minTextScaleFactor) / 2 * 100;
        double middleTextScaleFactor = minTextScaleFactor + step / 100;

        _painter.textScaler = TextScaler.linear(middleTextScaleFactor);

        _painter.layout(maxWidth: constraints.maxWidth);

        bool isOverflowInMidScaleFactor = _painter.didExceedMaxLines;

        double deltaFactor = isOverflowInMidScaleFactor ? -0.01 : 0.01;
        while (--step > 0) {
          // to find a suitable one in range
          middleTextScaleFactor = NumberPrecision.plus(
              [middleTextScaleFactor.toString(), deltaFactor.toString()]);
          _painter.textScaler = TextScaler.linear(middleTextScaleFactor);
          _painter.layout(maxWidth: constraints.maxWidth);
          bool isOverflowInRangeScaleFactor = _painter.didExceedMaxLines;
          if (!isOverflowInRangeScaleFactor) {
            textScaleFactor = middleTextScaleFactor;

            // _painter.textScaler = TextScaler.linear(middleTextScaleFactor);
            // textScaleFactor = _painter.textScaler.

            // right here; break the loop
            break;
          }
        }
      }
    }

    return textScaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrans) {
        double? textScaleFactor = ScalableText.getTextScaleFactor(content,
            constraints: constrans,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            minFontSize: minFontSize,
            overflow: overflow,
            textDirection: textDirection);
        if (textScaleFactor == null) {
          return FittedBox(
              child: Text(
            content,
            style: style,
            textAlign: textAlign,
            textDirection: textDirection,
            maxLines: maxLines,
            overflow: overflow,
          ));
        }

        return Text(
          content,
          style: style,
          strutStyle: StrutStyle(leading: 0),
          textAlign: textAlign,
          textDirection: textDirection,
          textScaler: TextScaler.linear(textScaleFactor),
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
