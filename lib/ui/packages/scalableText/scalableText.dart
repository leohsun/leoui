import 'package:flutter/widgets.dart';
import 'package:leoui/utils/index.dart';

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

  @override
  Widget build(BuildContext context) {
    TextPainter _painter = TextPainter(
        text: TextSpan(
          text: content,
          style: style,
        ),
        textAlign: textAlign,
        textScaler: TextScaler.noScaling,
        maxLines: maxLines,
        textDirection: TextDirection.ltr);

    return LayoutBuilder(
      builder: (context, constrans) {
        _painter.layout(maxWidth: constrans.maxWidth);
        double textScaleFactor = 1;

        bool isOverflow = _painter.didExceedMaxLines;

        if (isOverflow) {
          if (minFontSize == null) {
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

          double? currentTextFontSize = _painter.text!.style?.fontSize ??
              DefaultTextStyle.of(context).style.fontSize;

          double minTextScaleFactor = double.parse(
              (minFontSize! / currentTextFontSize!).toStringAsFixed(2));
          // scaleFactor = 1
          _painter.textScaler = TextScaler.linear(minTextScaleFactor);
          _painter.layout(maxWidth: constrans.maxWidth);
          bool isOverflowInMinScaleFactor = _painter.didExceedMaxLines;

          if (isOverflowInMinScaleFactor) {
            textScaleFactor = minTextScaleFactor;
          } else {
            // loop from [minTextScaleFactor] to [1]
            // locate the middle value to rudece loop times
            double step = (1 - minTextScaleFactor) / 2 * 100;
            double middleTextScaleFactor = minTextScaleFactor + step / 100;

            _painter.textScaler = TextScaler.linear(middleTextScaleFactor);

            _painter.layout(maxWidth: constrans.maxWidth);

            bool isOverflowInMidScaleFactor = _painter.didExceedMaxLines;

            double deltaFactor = isOverflowInMidScaleFactor ? -0.01 : 0.01;
            while (--step > 0) {
              // to find a suitable one in range
              middleTextScaleFactor = NumberPrecision.plus(
                  [middleTextScaleFactor.toString(), deltaFactor.toString()]);
              _painter.textScaler = TextScaler.linear(middleTextScaleFactor);
              _painter.layout(maxWidth: constrans.maxWidth);
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
