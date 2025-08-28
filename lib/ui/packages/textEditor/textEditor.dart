import 'dart:ui' as ui show ParagraphBuilder, PlaceholderAlignment;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leoui/widget/leoui_state.dart';

class TextEdtor extends StatefulWidget {
  const TextEdtor({super.key});

  @override
  State<TextEdtor> createState() => _TextEdtorState();
}

class SpecialTextSpan {
  SpecialTextSpan(
      {required this.prefix,
      required this.suffix,
      required this.widgetBuilder});
  final String prefix;
  final String suffix;
  final Widget Function(String value) widgetBuilder;
  int selectionLength = 0;

  InlineSpan buildInlineSpan(String value, TextStyle? style) {
    selectionLength = value.length + prefix.length + suffix.length;
    // return WidgetSpan(child: widgetBuilder(value));
    return SpecialWidgetSpan(child: widgetBuilder(value), text: value);
  }
}

class SpecialWidgetSpan extends WidgetSpan {
  const SpecialWidgetSpan({
    required this.child,
    required this.text,
    super.alignment,
    super.baseline,
    super.style,
  })  : assert(
          baseline != null ||
              !(identical(alignment, ui.PlaceholderAlignment.aboveBaseline) ||
                  identical(alignment, ui.PlaceholderAlignment.belowBaseline) ||
                  identical(alignment, ui.PlaceholderAlignment.baseline)),
        ),
        super(child: child);

  /// The widget to embed inline within text.
  final Widget child;

  final String text;

  @override
  void build(
    ui.ParagraphBuilder builder, {
    TextScaler textScaler = TextScaler.noScaling,
    List<PlaceholderDimensions>? dimensions,
  }) {
    assert(debugAssertIsValid());
    assert(dimensions != null);
    final bool hasStyle = style != null;
    if (hasStyle) {
      builder.pushStyle(style!.getTextStyle(textScaler: textScaler));
    }
    assert(builder.placeholderCount < dimensions!.length);
    final PlaceholderDimensions currentDimensions =
        dimensions![builder.placeholderCount];
    builder.addPlaceholder(
      currentDimensions.size.width,
      currentDimensions.size.height,
      alignment,
      baseline: currentDimensions.baseline,
      baselineOffset: currentDimensions.baselineOffset,
    );
    if (hasStyle) {
      builder.pop();
    }
  }

  @override
  bool visitChildren(InlineSpanVisitor visitor) => visitor(this);

  @override
  bool visitDirectChildren(InlineSpanVisitor visitor) => true;

  @override
  InlineSpan? getSpanForPositionVisitor(
      TextPosition position, Accumulator offset) {
    print("getSpanForPositionVisitor: ${position.offset} :${offset.value}");
    if (position.offset == offset.value) {
      return this;
    }
    offset.increment(1);
    return null;
  }

  @override
  int? codeUnitAtVisitor(int index, Accumulator offset) {
    print("codeUnitAtVisitor: $index :${offset.value}");
    final int localOffset = index - offset.value;
    assert(localOffset >= 0);
    offset.increment(1);
    return localOffset == 0 ? PlaceholderSpan.placeholderCodeUnit : null;
  }

  @override
  RenderComparison compareTo(InlineSpan other) {
    if (identical(this, other)) {
      return RenderComparison.identical;
    }
    if (other.runtimeType != runtimeType) {
      return RenderComparison.layout;
    }
    if ((style == null) != (other.style == null)) {
      return RenderComparison.layout;
    }
    final SpecialWidgetSpan typedOther = other as SpecialWidgetSpan;
    if (child != typedOther.child || alignment != typedOther.alignment) {
      return RenderComparison.layout;
    }
    RenderComparison result = RenderComparison.identical;
    if (style != null) {
      final RenderComparison candidate = style!.compareTo(other.style!);
      if (candidate.index > result.index) {
        result = candidate;
      }
      if (result == RenderComparison.layout) {
        return result;
      }
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (super != other) {
      return false;
    }
    return other is SpecialWidgetSpan &&
        other.child == child &&
        other.alignment == alignment &&
        other.baseline == baseline;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, child, alignment, baseline);

  /// Returns the text span that contains the given position in the text.
  @override
  InlineSpan? getSpanForPosition(TextPosition position) {
    assert(debugAssertIsValid());
    return null;
  }

  /// In debug mode, throws an exception if the object is not in a
  /// valid configuration. Otherwise, returns true.
  ///
  /// This is intended to be used as follows:
  ///
  /// ```dart
  /// assert(myWidgetSpan.debugAssertIsValid());
  /// ```
  @override
  bool debugAssertIsValid() {
    // WidgetSpans are always valid as asserts prevent invalid WidgetSpans
    // from being constructed.
    return true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('widget', child));
  }
}

class SpecialTextSpanPayload {
  final InlineSpan widget;
  final int start;
  final int end;

  SpecialTextSpanPayload(
      {required this.start, required this.end, required this.widget});
}

class emojiSpan extends SpecialTextSpan {
  emojiSpan()
      : super(
            prefix: '[', suffix: ']', widgetBuilder: (value) => FlutterLogo());
}

class RichTextEditingController extends TextEditingController {
  RichTextEditingController(
      {required List<SpecialTextSpan> specialTextSpanList})
      : specialTextSpanMap = RichTextEditingController.buildSpecialTextSpanMap(
            specialTextSpanList),
        super(text: "123[aa]456[bb]789[cc]{dfg}");
  Map<String, SpecialTextSpan> specialTextSpanMap = {};

  static Map<String, SpecialTextSpan> buildSpecialTextSpanMap(
      List<SpecialTextSpan> specialTextSpanList) {
    Map<String, SpecialTextSpan> result = {};
    specialTextSpanList.reduceWithDefault<Map<String, SpecialTextSpan>>(
        (s, next) => ({...s, '${next.prefix}-${next.suffix}': next}), {});
    Set<String> set = Set();
    specialTextSpanList.forEach(
      (element) {
        String key = '${element.prefix}-${element.suffix}';
        if (set.contains(key)) {
          throw FlutterError(
              "there has same prefix and suffix in diffrent SpecialTextSpan");
        } else {
          set.add(key);
          result[element.prefix] = element;
        }
      },
    );

    return result;
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    SpecialTextSpan? currentSpecialSpan;
    String currentSpecialSpanInnerText = "";
    String currentTextSpanInnerText = "";
    int newTextLength = value.text.length;
    print("input: ${value.text}");

    List<InlineSpan> children = [];

    void resetSpecialVars() {
      currentSpecialSpan = null;
      currentSpecialSpanInnerText = "";
    }

    for (int i = 0; i < value.text.length; i++) {
      String char = value.text[i];
      if (currentSpecialSpan == null) {
        if (specialTextSpanMap.containsKey(char)) {
          currentSpecialSpan = specialTextSpanMap[char];
          if (currentTextSpanInnerText.isNotEmpty) {
            children
                .add(TextSpan(text: currentTextSpanInnerText, style: style));
            currentTextSpanInnerText = "";
          }
        } else {
          currentTextSpanInnerText += char;
        }
      } else {
        if (char != currentSpecialSpan!.suffix) {
          currentSpecialSpanInnerText += char;
        } else {
          children.add(currentSpecialSpan!
              .buildInlineSpan(currentSpecialSpanInnerText, style));
          newTextLength -= currentSpecialSpan!.selectionLength;
          currentSpecialSpanInnerText = "";
          resetSpecialVars();
        }
      }
    }

    // selection = TextSelection.collapsed(offset: newTextLength);
    return TextSpan(children: children);

    return super.buildTextSpan(
        context: context, style: style, withComposing: withComposing);
  }
}

class _TextEdtorState extends State<TextEdtor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller:
              RichTextEditingController(specialTextSpanList: [emojiSpan()]),
        )
      ],
    );
  }
}
