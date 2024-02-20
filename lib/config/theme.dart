import 'package:flutter/material.dart';
import 'package:leoui/widget/leoui_state.dart';

enum LeouiBrightness { light, dark }

class LeouiSize {
  final double title;
  final double content;
  final double secondary;
  final double tertiary;
  final double formControls;
  final double cardBorderRadius;
  final double fieldBorderRadius;
  final double tab;
  final double itemExtent;
  final double itemElevation;
  final double dialogWidth;
  final double buttonNormalMinWidth;
  final double buttonNormalHeight;
  final double buttonNormalFontSize;
  final double buttonSmallMinWidth;
  final double buttonSmallHeight;
  final double buttonSmallFontSize;
  final double buttonDefaultBorderRadius;
  final double buttonElevation;
  final EdgeInsets listItemPadding;

  factory LeouiSize({
    double? title,
    double? content,
    double? secondary,
    double? tertiary,
    double? formControls,
    double? cardBorderRadius,
    double? fieldBorderRadius,
    double? tab,
    double? itemExtent,
    double? dialogWidth,
    double? itemElevation,
    double? buttonNormalMinWidth,
    double? buttonNormalHeight,
    double? buttonNormalFontSize,
    double? buttonSmallMinWidth,
    double? buttonSmallHeight,
    double? buttonSmallFontSize,
    double? buttonElevation,
    double? buttonDefaultBorderRadius,
    EdgeInsets? listItemPadding,
  }) {
    return LeouiSize.raw(
      title: title ?? sz(17),
      content: content ?? sz(17),
      secondary: secondary ?? sz(15),
      tertiary: tertiary ?? sz(13),
      formControls: formControls ?? sz(17),
      cardBorderRadius: cardBorderRadius ?? sz(14),
      fieldBorderRadius: fieldBorderRadius ?? sz(4),
      tab: tab ?? sz(10),
      itemExtent: itemExtent ?? sz(40),
      dialogWidth: dialogWidth ?? sz(270),
      itemElevation: itemElevation ?? sz(4),
      buttonNormalMinWidth: buttonNormalMinWidth ?? sz(120),
      buttonNormalHeight: buttonNormalHeight ?? sz(44),
      buttonNormalFontSize: buttonNormalFontSize ?? sz(15),
      buttonSmallMinWidth: buttonSmallMinWidth ?? sz(100),
      buttonSmallHeight: buttonSmallHeight ?? sz(30),
      buttonSmallFontSize: buttonSmallFontSize ?? sz(13),
      buttonElevation: buttonElevation ?? sz(2),
      buttonDefaultBorderRadius: buttonDefaultBorderRadius ?? sz(8),
      listItemPadding: listItemPadding ??
          const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }

  const LeouiSize.raw({
    required this.title,
    required this.content,
    required this.secondary,
    required this.tertiary,
    required this.formControls,
    required this.cardBorderRadius,
    required this.fieldBorderRadius,
    required this.tab,
    required this.itemExtent,
    required this.dialogWidth,
    required this.itemElevation,
    required this.buttonNormalMinWidth,
    required this.buttonNormalHeight,
    required this.buttonNormalFontSize,
    required this.buttonSmallMinWidth,
    required this.buttonSmallHeight,
    required this.buttonSmallFontSize,
    required this.buttonElevation,
    required this.buttonDefaultBorderRadius,
    required this.listItemPadding,
  });
}

class LeouiThemeData {
  final Color backgroundPrimaryColor;
  final Color backgroundSecondaryColor;
  final Color backgroundTertiaryColor;

  final Color opaqueSeparatorColor;
  final Color nonOpaqueSeparatorColor;

  final Color labelPrimaryColor;
  final Color labelSecondaryColor;
  final Color labelTertiaryColor;
  final Color labelQuarternaryColor;

  final Color fillPrimaryColor;
  final Color fillSecondaryColor;
  final Color fillTertiaryColor;
  final Color fillQuarternaryColor;

  final Color baseRedColor;
  final Color baseOrangeColor;
  final Color baseYellowColor;
  final Color baseGreenColor;
  final Color baseTealColor;
  final Color baseBlueColor;
  final Color baseIndigoColor;
  final Color basePurpleColor;
  final Color basePinkColor;
  final Color baseGreyColor;
  final Color baseGrey2Color;
  final Color baseGrey3Color;
  final Color baseGrey4Color;
  final Color baseGrey5Color;
  final Color baseGrey6Color;

  final Color errorColor;
  final Color userAccentColor;

  final Color dialogBackgroundColor;

  final List<BoxShadow> boxShadow;
  final LeouiBrightness brightness;

  /// size meybe use SizeTool to scale
  final LeouiSize Function()? size;

  factory LeouiThemeData(
      {Color? backgroundPrimaryColor,
      Color? backgroundSecondaryColor,
      Color? backgroundTertiaryColor,
      Color? opaqueSeparatorColor,
      Color? nonOpaqueSeparatorColor,
      Color? labelPrimaryColor,
      Color? labelSecondaryColor,
      Color? labelTertiaryColor,
      Color? labelQuarternaryColor,
      Color? fillPrimaryColor,
      Color? fillSecondaryColor,
      Color? fillTertiaryColor,
      Color? fillQuarternaryColor,
      Color? baseRedColor,
      Color? baseOrangeColor,
      Color? baseYellowColor,
      Color? baseGreenColor,
      Color? baseTealColor,
      Color? baseBlueColor,
      Color? baseIndigoColor,
      Color? basePurpleColor,
      Color? basePinkColor,
      Color? baseGreyColor,
      Color? baseGrey2Color,
      Color? baseGrey3Color,
      Color? baseGrey4Color,
      Color? baseGrey5Color,
      Color? baseGrey6Color,
      Color? errorColor,
      Color? userAccentColor,
      Color? textPrimaryColor,
      Color? dialogBackgroundColor,
      List<BoxShadow>? boxShadow,
      LeouiBrightness? brightness,

      /// size meybe use SizeTool to scale
      LeouiSize Function()? size}) {
    brightness = brightness ?? LeouiBrightness.light;
    bool isDark = brightness == LeouiBrightness.dark;
    backgroundPrimaryColor ??= isDark ? Colors.black : Colors.white;
    backgroundSecondaryColor ??= isDark
        ? Color.fromRGBO(28, 28, 30, 1)
        : Color.fromRGBO(242, 242, 247, 1);
    backgroundTertiaryColor ??=
        isDark ? Color.fromRGBO(44, 44, 46, 1) : Colors.white;

    opaqueSeparatorColor ??= isDark
        ? Color.fromRGBO(56, 56, 58, 1)
        : Color.fromRGBO(198, 198, 200, 1);
    nonOpaqueSeparatorColor ??= isDark
        ? Color.fromRGBO(84, 84, 88, 0.65)
        : Color.fromRGBO(60, 60, 67, 0.36);

    labelPrimaryColor ??= isDark ? Colors.white : Colors.black;
    labelSecondaryColor ??= isDark
        ? Color.fromRGBO(235, 235, 245, 0.6)
        : Color.fromRGBO(60, 60, 67, 0.6);
    labelTertiaryColor ??= isDark
        ? Color.fromRGBO(235, 235, 245, 0.3)
        : Color.fromRGBO(60, 60, 67, 0.3);
    labelQuarternaryColor ??= isDark
        ? Color.fromRGBO(235, 235, 245, 0.18)
        : Color.fromRGBO(60, 60, 67, 0.18);

    fillPrimaryColor ??= isDark
        ? Color.fromRGBO(120, 120, 128, 0.36)
        : Color.fromRGBO(120, 120, 128, 0.2);
    fillSecondaryColor ??= isDark
        ? Color.fromRGBO(120, 120, 128, 0.32)
        : Color.fromRGBO(120, 120, 128, 0.16);
    fillTertiaryColor ??= isDark
        ? Color.fromRGBO(120, 120, 128, 0.24)
        : Color.fromRGBO(120, 120, 128, 0.12);
    fillQuarternaryColor ??= isDark
        ? Color.fromRGBO(120, 120, 128, 0.18)
        : Color.fromRGBO(120, 120, 128, 0.08);

    baseRedColor ??= isDark
        ? Color.fromRGBO(255, 69, 58, 1)
        : Color.fromRGBO(255, 69, 48, 1);
    baseOrangeColor ??= isDark
        ? Color.fromRGBO(255, 159, 10, 1)
        : Color.fromRGBO(255, 149, 0, 1);
    baseYellowColor ??= isDark
        ? Color.fromRGBO(255, 214, 10, 1)
        : Color.fromRGBO(255, 204, 0, 1);
    baseGreenColor ??= isDark
        ? Color.fromRGBO(50, 215, 75, 1)
        : Color.fromRGBO(52, 199, 89, 1);
    baseTealColor ??= isDark
        ? Color.fromRGBO(100, 210, 255, 1)
        : Color.fromRGBO(90, 200, 250, 1);
    baseBlueColor ??= isDark
        ? Color.fromRGBO(10, 132, 255, 1)
        : Color.fromRGBO(0, 122, 255, 1);
    baseIndigoColor ??= isDark
        ? Color.fromRGBO(94, 92, 230, 1)
        : Color.fromRGBO(88, 86, 214, 1);
    basePurpleColor ??= isDark
        ? Color.fromRGBO(191, 90, 242, 1)
        : Color.fromRGBO(175, 82, 222, 1);
    basePinkColor ??= isDark
        ? Color.fromRGBO(255, 55, 95, 1)
        : Color.fromRGBO(255, 45, 85, 1);
    baseGreyColor ??= isDark
        ? Color.fromRGBO(142, 142, 147, 1)
        : Color.fromRGBO(142, 142, 147, 1);
    baseGrey2Color ??= isDark
        ? Color.fromRGBO(99, 99, 102, 1)
        : Color.fromRGBO(147, 147, 178, 1);
    baseGrey3Color ??= isDark
        ? Color.fromRGBO(72, 72, 74, 1)
        : Color.fromRGBO(199, 199, 204, 1);
    baseGrey4Color ??= isDark
        ? Color.fromRGBO(58, 58, 60, 1)
        : Color.fromRGBO(209, 209, 214, 1);
    baseGrey5Color ??= isDark
        ? Color.fromRGBO(44, 44, 46, 1)
        : Color.fromRGBO(229, 229, 234, 1);
    baseGrey6Color ??= isDark
        ? Color.fromRGBO(28, 28, 30, 1)
        : Color.fromRGBO(242, 242, 247, 1);

    dialogBackgroundColor ??= isDark
        ? Color.fromRGBO(30, 30, 30, 0.99)
        : Color.fromRGBO(242, 242, 242, .99);

    errorColor ??= isDark
        ? Color.fromRGBO(207, 102, 121, 1.000)
        : Color.fromRGBO(176, 1, 32, 1.000);

    userAccentColor ??= isDark ? Color(0xFF0A7AFF) : Color(0xFF0084FF);

    boxShadow ??= isDark
        ? [
            BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 0.14),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0),
          ]
        : [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.14),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0),
          ];
    size ??= () => LeouiSize();
    return LeouiThemeData.raw(
        backgroundPrimaryColor: backgroundPrimaryColor,
        backgroundSecondaryColor: backgroundSecondaryColor,
        backgroundTertiaryColor: backgroundTertiaryColor,
        opaqueSeparatorColor: opaqueSeparatorColor,
        nonOpaqueSeparatorColor: nonOpaqueSeparatorColor,
        labelPrimaryColor: labelPrimaryColor,
        labelSecondaryColor: labelSecondaryColor,
        labelTertiaryColor: labelTertiaryColor,
        labelQuarternaryColor: labelQuarternaryColor,
        fillPrimaryColor: fillPrimaryColor,
        fillSecondaryColor: fillSecondaryColor,
        fillTertiaryColor: fillTertiaryColor,
        fillQuarternaryColor: fillQuarternaryColor,
        baseRedColor: baseRedColor,
        baseOrangeColor: baseOrangeColor,
        baseYellowColor: baseYellowColor,
        baseGreenColor: baseGreenColor,
        baseTealColor: baseTealColor,
        baseBlueColor: baseBlueColor,
        baseIndigoColor: baseIndigoColor,
        basePurpleColor: basePurpleColor,
        basePinkColor: basePinkColor,
        baseGreyColor: baseGreyColor,
        baseGrey2Color: baseGrey2Color,
        baseGrey3Color: baseGrey3Color,
        baseGrey4Color: baseGrey4Color,
        baseGrey5Color: baseGrey5Color,
        baseGrey6Color: baseGrey6Color,
        errorColor: errorColor,
        userAccentColor: userAccentColor,
        dialogBackgroundColor: dialogBackgroundColor,
        boxShadow: boxShadow,
        brightness: brightness,
        size: size);
  }

  const LeouiThemeData.raw(
      {required this.backgroundPrimaryColor,
      required this.backgroundSecondaryColor,
      required this.backgroundTertiaryColor,
      required this.opaqueSeparatorColor,
      required this.nonOpaqueSeparatorColor,
      required this.labelPrimaryColor,
      required this.labelSecondaryColor,
      required this.labelTertiaryColor,
      required this.labelQuarternaryColor,
      required this.fillPrimaryColor,
      required this.fillSecondaryColor,
      required this.fillTertiaryColor,
      required this.fillQuarternaryColor,
      required this.baseRedColor,
      required this.baseOrangeColor,
      required this.baseYellowColor,
      required this.baseGreenColor,
      required this.baseTealColor,
      required this.baseBlueColor,
      required this.baseIndigoColor,
      required this.basePurpleColor,
      required this.basePinkColor,
      required this.baseGreyColor,
      required this.baseGrey2Color,
      required this.baseGrey3Color,
      required this.baseGrey4Color,
      required this.baseGrey5Color,
      required this.baseGrey6Color,
      required this.errorColor,
      required this.userAccentColor,
      required this.dialogBackgroundColor,
      required this.boxShadow,
      required this.brightness,
      required this.size});

  factory LeouiThemeData.dark() =>
      LeouiThemeData(brightness: LeouiBrightness.dark);
  factory LeouiThemeData.light() =>
      LeouiThemeData(brightness: LeouiBrightness.light);

  LeouiThemeData copyWith(
      {Color? backgroundPrimaryColor,
      Color? backgroundSecondaryColor,
      Color? backgroundTertiaryColor,
      Color? opaqueSeparatorColor,
      Color? nonOpaqueSeparatorColor,
      Color? labelPrimaryColor,
      Color? labelSecondaryColor,
      Color? labelTertiaryColor,
      Color? labelQuarternaryColor,
      Color? fillPrimaryColor,
      Color? fillSecondaryColor,
      Color? fillTertiaryColor,
      Color? fillQuarternaryColor,
      Color? baseRedColor,
      Color? baseOrangeColor,
      Color? baseYellowColor,
      Color? baseGreenColor,
      Color? baseTealColor,
      Color? baseBlueColor,
      Color? baseIndigoColor,
      Color? basePurpleColor,
      Color? basePinkColor,
      Color? baseGreyColor,
      Color? baseGrey2Color,
      Color? baseGrey3Color,
      Color? baseGrey4Color,
      Color? baseGrey5Color,
      Color? baseGrey6Color,
      Color? errorColor,
      Color? userAccentColor,
      Color? textPrimaryColor,
      Color? dialogBackgroundColor,
      List<BoxShadow>? boxShadow,
      LeouiBrightness? brightness,
      LeouiSize Function()? size}) {
    brightness ??= this.brightness;
    backgroundPrimaryColor ??= this.backgroundPrimaryColor;
    backgroundSecondaryColor ??= this.backgroundSecondaryColor;
    backgroundTertiaryColor ??= this.backgroundTertiaryColor;

    opaqueSeparatorColor ??= this.opaqueSeparatorColor;
    nonOpaqueSeparatorColor ??= this.nonOpaqueSeparatorColor;

    labelPrimaryColor ??= this.labelPrimaryColor;
    labelSecondaryColor ??= this.labelSecondaryColor;
    labelTertiaryColor ??= this.labelTertiaryColor;
    labelQuarternaryColor ??= this.labelQuarternaryColor;

    fillPrimaryColor ??= this.fillPrimaryColor;
    fillSecondaryColor ??= this.fillSecondaryColor;
    fillTertiaryColor ??= this.fillTertiaryColor;
    fillQuarternaryColor ??= this.fillQuarternaryColor;

    baseRedColor ??= this.baseRedColor;
    baseOrangeColor ??= this.baseOrangeColor;
    baseYellowColor ??= this.baseYellowColor;
    baseGreenColor ??= this.baseGreenColor;
    baseTealColor ??= this.baseTealColor;
    baseBlueColor ??= this.baseBlueColor;
    baseIndigoColor ??= this.baseIndigoColor;
    basePurpleColor ??= this.basePurpleColor;
    basePinkColor ??= this.basePinkColor;
    baseGreyColor ??= this.baseGreyColor;
    baseGrey2Color ??= this.baseGrey2Color;
    baseGrey3Color ??= this.baseGrey3Color;
    baseGrey4Color ??= this.baseGrey4Color;
    baseGrey5Color ??= this.baseGrey5Color;
    baseGrey6Color ??= this.baseGrey6Color;

    dialogBackgroundColor ??= this.dialogBackgroundColor;

    errorColor ??= this.errorColor;

    userAccentColor ??= this.userAccentColor;
    boxShadow ??= this.boxShadow;
    size ??= this.size;
    return LeouiThemeData.raw(
        backgroundPrimaryColor: backgroundPrimaryColor,
        backgroundSecondaryColor: backgroundSecondaryColor,
        backgroundTertiaryColor: backgroundTertiaryColor,
        opaqueSeparatorColor: opaqueSeparatorColor,
        nonOpaqueSeparatorColor: nonOpaqueSeparatorColor,
        labelPrimaryColor: labelPrimaryColor,
        labelSecondaryColor: labelSecondaryColor,
        labelTertiaryColor: labelTertiaryColor,
        labelQuarternaryColor: labelQuarternaryColor,
        fillPrimaryColor: fillPrimaryColor,
        fillSecondaryColor: fillSecondaryColor,
        fillTertiaryColor: fillTertiaryColor,
        fillQuarternaryColor: fillQuarternaryColor,
        baseRedColor: baseRedColor,
        baseOrangeColor: baseOrangeColor,
        baseYellowColor: baseYellowColor,
        baseGreenColor: baseGreenColor,
        baseTealColor: baseTealColor,
        baseBlueColor: baseBlueColor,
        baseIndigoColor: baseIndigoColor,
        basePurpleColor: basePurpleColor,
        basePinkColor: basePinkColor,
        baseGreyColor: baseGreyColor,
        baseGrey2Color: baseGrey2Color,
        baseGrey3Color: baseGrey3Color,
        baseGrey4Color: baseGrey4Color,
        baseGrey5Color: baseGrey5Color,
        baseGrey6Color: baseGrey6Color,
        errorColor: errorColor,
        userAccentColor: userAccentColor,
        dialogBackgroundColor: dialogBackgroundColor,
        boxShadow: boxShadow,
        brightness: brightness,
        size: size);
  }
}

class LeouiTheme extends InheritedWidget {
  final Widget child;

  LeouiThemeData theme({LeouiBrightness? brightness}) {
    final _brightness = brightness ?? this.brightness;
    if (_brightness == LeouiBrightness.dark) {
      return darkTheme;
    }

    return lightTheme;
  }

  final LeouiThemeData lightTheme;
  final LeouiThemeData darkTheme;
  final LeouiBrightness brightness;
  final LeouiSize size;

  factory LeouiTheme({
    Key? key,
    required Widget child,
    LeouiBrightness? brightness,
    LeouiThemeData? lightTheme,
    LeouiThemeData? darkTheme,
    LeouiSize? size,
  }) {
    return LeouiTheme.raw(
      key: key,
      child: child,
      brightness: brightness ?? LeouiBrightness.light,
      lightTheme: lightTheme ?? LeouiThemeData.light(),
      darkTheme: darkTheme ?? LeouiThemeData.dark(),
      size: size ?? LeouiSize(),
    );
  }

  const LeouiTheme.raw(
      {Key? key,
      required this.child,
      required this.lightTheme,
      required this.darkTheme,
      required this.brightness,
      required this.size})
      : super(child: child);

  static LeouiTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LeouiTheme>();

  @override
  bool updateShouldNotify(LeouiTheme oldWidget) => (theme != oldWidget.theme ||
      darkTheme != oldWidget.darkTheme ||
      brightness != oldWidget.brightness ||
      size != oldWidget.size);
}
