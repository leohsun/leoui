import 'package:flutter/material.dart';
import 'dart:math' show max;

import 'package:leoui/config/index.dart';
import 'package:leoui/utils/index.dart';

// best thanks to https://github.com/mdbassit/Coloris
class ColorPicker extends StatefulWidget {
  final List<Color>? presetColors;
  final Color? color;
  final ValueChanged<Color>? onChange;
  final LeouiBrightness? brightness;
  const ColorPicker(
      {Key? key,
      this.presetColors = const [
        Color(0xff264653),
        Color(0xff2a9d8f),
        Color(0xffe9c46a),
        Color(0xfff4a261),
        Color(0xffe76f51),
        Color(0xffd62828),
        Color(0xff023e8a),
        Color(0xff0077b6),
        Color(0xff0096c7),
        Color(0xff00b4d8),
        Color(0xff48cae4),
      ],
      this.color,
      this.brightness = LeouiBrightness.light,
      this.onChange})
      : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  TextEditingController _colorCtr = TextEditingController();
  FocusNode _colorFocusNode = FocusNode();
  Offset _swatchIndicatorOffset = Offset.zero;
  double _indicatorSize = 30;
  double _sliderHeight = 20;

  late double _swatchWidth;
  late double _swatchHeight;
  late Color _color; // chosen color with opacity
  late HSLColor _swatchColor; // has no opacity; alpha = 1
  late HSVColor _swatchIndicatorColor; // has no opacity; alpha = 1
  late double _alpha; // 0 <===> 1
  late LeouiThemeData theme;
  late BoxShadow _indicatorBoxShadow;

  @override
  void initState() {
    Color _color = (widget.color != null
        ? widget.color
        : widget.presetColors != null
            ? widget.presetColors!.first
            : Colors.orange)!;
    _setUp(_color, isInit: true);

    super.initState();
  }

  @override
  void dispose() {
    _colorFocusNode.dispose();
    _colorCtr.dispose();
    super.dispose();
  }

  void _setUp(Color color, {bool isInit = false}) {
    setState(() {
      _colorCtr.text = '0x' + color.value.toRadixString(16).padLeft(8, '0');
      _colorFocusNode.unfocus();
      _color = color;
      _alpha = _color.alpha / 0xFF;
      HSLColor hslRaw = HSLColor.fromColor(_color);
      _swatchColor = HSLColor.fromAHSL(1, hslRaw.hue, hslRaw.saturation, 0.5);
      final double value =
          max(_color.red / 0xFF, max(_color.green / 0xFF, _color.blue / 0xFF));

      _swatchIndicatorColor =
          HSVColor.fromAHSV(1, hslRaw.hue, hslRaw.saturation, value);
    });

    if (widget.onChange != null && !isInit) {
      widget.onChange!(color);
    }
  }

  void _handleColorChange() {
    if (widget.onChange != null) {
      widget.onChange!(_color);
    }
    _colorFocusNode.unfocus();
  }

  void _updateHueColorBaseOnOffset(Offset offset) {
    double suturation = offset.dx / _swatchWidth;

    double value = 1 - offset.dy / _swatchHeight;

    HSVColor swatchIndicatorColor =
        HSVColor.fromAHSV(1, _swatchColor.hue, suturation, value.clamp(0, 1));

    this.setState(() {
      _swatchIndicatorColor = swatchIndicatorColor;
      _color = HSVColor.fromAHSV(
              _alpha, _swatchColor.hue, suturation, value.clamp(0, 1))
          .toColor();
      _handleColorChange();
    });
  }

  void _updateHueColorBaseOnDx(double dx, double sliderWidth) {
    double _dx = dx < 0
        ? 0
        : dx > sliderWidth
            ? sliderWidth
            : dx;

    this.setState(() {
      double hue = _dx / sliderWidth * 360;
      _swatchColor = HSLColor.fromAHSL(1, hue, 1, 0.5);
      _swatchIndicatorColor = HSVColor.fromAHSV(1, hue,
          _swatchIndicatorColor.saturation, _swatchIndicatorColor.value);
      _color = HSLColor.fromAHSL(_alpha, hue, 1, 0.5).toColor();
      _handleColorChange();
    });
  }

  void _updateAlpahBasesOnDx(double dx, double sliderWidth) {
    double _dx = dx < 0
        ? 0
        : dx > sliderWidth
            ? sliderWidth
            : dx;
    setState(() {
      _alpha = _dx / sliderWidth;
      _color = _swatchIndicatorColor.withAlpha(_alpha).toColor();
      _handleColorChange();
    });
  }

  Offset _calcIndicatorOffsetBaseOnColor() {
    double _dx = _swatchIndicatorColor.saturation * _swatchWidth;
    double _dy = (1 - _swatchIndicatorColor.value) * _swatchHeight;

    double dx = _dx < 0
        ? 0
        : _dx > _swatchWidth - _indicatorSize
            ? _swatchWidth - _indicatorSize
            : _dx;

    double dy = _dy < 0
        ? 0
        : _dy > _swatchHeight
            ? _swatchHeight
            : _dy;

    return Offset(dx, dy);
  }

  Widget _buildColorSwatch() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(_indicatorSize / 2),
          child: SizedBox(
            width: _swatchWidth,
            height: _swatchHeight,
            child: CustomPaint(
              painter: GradientSwatch(color: _swatchColor.toColor()),
            ),
          ),
        ),
        Positioned(
            left: _swatchIndicatorOffset.dx,
            top: _swatchIndicatorOffset.dy,
            child: Container(
              width: _indicatorSize,
              height: _indicatorSize,
              decoration: BoxDecoration(
                  color: _swatchIndicatorColor.toColor(),
                  shape: BoxShape.circle,
                  boxShadow: [_indicatorBoxShadow],
                  border: Border.all(width: 2, color: Colors.white)),
            )),
        Positioned.fill(
          child: Padding(
            // padding: EdgeInsets.all(_indicatorSize / 2),
            padding: EdgeInsets.zero,
            child: GestureDetector(
              onPanDown: (details) {
                _updateHueColorBaseOnOffset(details.localPosition);
              },
              onPanUpdate: (details) {
                double dx = details.localPosition.dx < 0
                    ? 0
                    : details.localPosition.dx > _swatchWidth
                        ? _swatchWidth
                        : details.localPosition.dx;

                double dy = details.localPosition.dy < 0
                    ? 0
                    : details.localPosition.dy > _swatchHeight
                        ? _swatchHeight
                        : details.localPosition.dy;

                _updateHueColorBaseOnOffset(Offset(dx, dy));
              },
              child: Container(
                  width: _swatchWidth,
                  height: _swatchHeight,
                  color: Color(0x000000)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHueSlider() {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      double _sliderWidth = maxWidth - _indicatorSize;
      double _left = _swatchColor.hue / 360 * _sliderWidth;
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(_indicatorSize / 2),
            child: Container(
              height: _sliderHeight,
              width: maxWidth - _indicatorSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_swatchHeight / 2),
                  gradient: LinearGradient(colors: [
                    Color(0xffff0000),
                    Color(0xffffff00),
                    Color(0xff00ff00),
                    Color(0xff00ffff),
                    Color(0xff0000ff),
                    Color(0xffff00ff),
                    Color(0xffff0000),
                  ])),
            ),
          ),
          Positioned(
              left: _left,
              top: _indicatorSize / 2 - (_indicatorSize - _sliderHeight) / 2,
              child: Container(
                width: _indicatorSize,
                height: _indicatorSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [_indicatorBoxShadow],
                    color: _swatchColor.toColor()),
              )),
          Positioned(
              left: 0,
              right: 0,
              top: _indicatorSize / 2,
              child: Padding(
                // padding: EdgeInsets.symmetric(horizontal: _indicatorSize / 2),
                padding: EdgeInsets.zero,
                child: GestureDetector(
                  onTapDown: (details) {
                    _updateHueColorBaseOnDx(
                        details.localPosition.dx, _sliderWidth);
                  },
                  onPanUpdate: (details) {
                    _updateHueColorBaseOnDx(
                        details.localPosition.dx, _sliderWidth);
                  },
                  child: Container(
                    height: _sliderHeight,
                    color: Colors.transparent,
                  ),
                ),
              ))
        ],
      );
    });
  }

  Widget _buildOpacitySlider() {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      double _sliderWidth = maxWidth - _indicatorSize;
      double _left = _alpha * _sliderWidth;
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(_indicatorSize / 2),
            child: Container(
              height: _sliderHeight,
              width: maxWidth - _indicatorSize,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _swatchIndicatorColor.withAlpha(0).toColor(),
                    _swatchIndicatorColor.toColor(),
                  ],
                ),
                borderRadius: BorderRadius.circular(_swatchHeight / 2),
              )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_swatchHeight / 2),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xffaaaaaa),
                        Color(0x00000000),
                        Color(0x00000000),
                        Color(0xffaaaaaa),
                      ],
                      begin: Alignment(0.1, 0),
                      end: Alignment(0.15, 0.1),
                      tileMode: TileMode.repeated)),
            ),
          ),
          Positioned(
              left: _left,
              top: _indicatorSize / 2 - (_indicatorSize - _sliderHeight) / 2,
              child: Container(
                width: _indicatorSize,
                height: _indicatorSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [_indicatorBoxShadow],
                    color: _color),
              )),
          Positioned(
              left: 0,
              right: 0,
              top: _indicatorSize / 2,
              child: Padding(
                padding: EdgeInsets.zero,
                child: GestureDetector(
                  onTapDown: (details) {
                    _updateAlpahBasesOnDx(
                        details.localPosition.dx, _sliderWidth);
                  },
                  onPanUpdate: (details) {
                    _updateAlpahBasesOnDx(
                        details.localPosition.dx, _sliderWidth);
                  },
                  child: Container(
                    height: _sliderHeight,
                    color: Colors.transparent,
                  ),
                ),
              ))
        ],
      );
    });
  }

  Widget _buildPreview() {
    _colorCtr.text = '0x' + _color.value.toRadixString(16).padLeft(8, '0');
    return Padding(
      padding: EdgeInsets.only(
          bottom: _sliderHeight,
          left: _indicatorSize / 2,
          right: _indicatorSize / 2),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: _sliderHeight),
            child: Stack(
              children: [
                Container(
                  height: _sliderHeight * 3,
                  width: _sliderHeight * 3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [
                            Color(0xffaaaaaa),
                            Color(0x00000000),
                            Color(0x00000000),
                            Color(0xffaaaaaa),
                          ],
                          begin: Alignment(0, 0),
                          end: Alignment(0.3, 0.1),
                          tileMode: TileMode.repeated)),
                ),
                Positioned.fill(
                  child: Container(
                    height: _sliderHeight * 3,
                    width: _sliderHeight * 3,
                    decoration: BoxDecoration(
                        color: _color,
                        shape: BoxShape.circle,
                        boxShadow: [_indicatorBoxShadow]),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: TextField(
            controller: _colorCtr,
            focusNode: _colorFocusNode,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.labelPrimaryColor,
                fontSize: 12,
                backgroundColor: Color(0x00000000)),
            onSubmitted: (val) {
              late Color c;
              try {
                c = Color(int.parse(val));
              } catch (err) {
                c = Color(0xff000000);
              }
              _setUp(c);
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.labelPrimaryColor),
                  borderRadius: BorderRadius.circular(_sliderHeight * 3)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.labelPrimaryColor),
                  borderRadius: BorderRadius.circular(_sliderHeight * 3)),
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildPresetClolors() {
    return Padding(
      padding: EdgeInsets.all(_indicatorSize / 2),
      child: Wrap(
          spacing: _sliderHeight,
          runSpacing: _sliderHeight,
          alignment: WrapAlignment.center,
          children: widget.presetColors!
              .map((c) => GestureDetector(
                    onTap: () {
                      _setUp(c);
                    },
                    child: Container(
                      width: _indicatorSize,
                      height: _indicatorSize,
                      decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          boxShadow: [_indicatorBoxShadow]),
                    ),
                  ))
              .toList(growable: false)),
    );
  }

  double val = 0;

  @override
  Widget build(BuildContext context) {
    theme = widget.brightness == null
        ? LeouiTheme.of(context)
        : LeouiTheme.of(context).copyWith(brightness: widget.brightness);

    _indicatorBoxShadow =
        BoxShadow(color: theme.nonOpaqueSeparatorColor, spreadRadius: 1);

    return Material(
      color: Color(0x000000),
      child: LayoutBuilder(builder: (context, constraints) {
        double maxWidth = constraints.maxWidth.isInfinite
            ? SizeTool.deviceWidth
            : constraints.maxWidth;

        _swatchWidth = maxWidth;
        _swatchHeight = _swatchWidth / 2;
        _swatchIndicatorOffset = _calcIndicatorOffsetBaseOnColor();
        return SingleChildScrollView(
          child: Container(
            color: theme.backgroundSecondaryColor,
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                Slider(
                    value: val,
                    onChanged: (v) {
                      setState(() {
                        val = v;
                      });
                    }),
                _buildColorSwatch(),
                Column(
                  children: [
                    _buildHueSlider(),
                    _buildOpacitySlider(),
                    _buildPreview(),
                    ...(widget.presetColors != null
                        ? [
                            _buildPresetClolors(),
                          ]
                        : [])
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class GradientSwatch extends CustomPainter {
  final Color? color;

  GradientSwatch({this.color = Colors.red});
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    Paint _brigthnessPaint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect);

    Paint _colorPaint = Paint()
      ..shader =
          LinearGradient(colors: [Colors.white, color!]).createShader(rect);

    Path path = Path()..addRect(rect);

    canvas.drawPath(path, _colorPaint);
    canvas.drawPath(path, _brigthnessPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
