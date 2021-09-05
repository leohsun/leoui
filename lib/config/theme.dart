import 'package:flutter/material.dart';

enum LeouiBrightness { light, dark }

class LeoThemeData {
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

  final List<BoxShadow>? boxShadow;
  final LeouiBrightness? brightness;

  factory LeoThemeData(
      {backgroundPrimaryColor,
      backgroundSecondaryColor,
      backgroundTertiaryColor,
      opaqueSeparatorColor,
      nonOpaqueSeparatorColor,
      labelPrimaryColor,
      labelSecondaryColor,
      labelTertiaryColor,
      labelQuarternaryColor,
      fillPrimaryColor,
      fillSecondaryColor,
      fillTertiaryColor,
      fillQuarternaryColor,
      baseRedColor,
      baseOrangeColor,
      baseYellowColor,
      baseGreenColor,
      baseTealColor,
      baseBlueColor,
      baseIndigoColor,
      basePurpleColor,
      basePinkColor,
      baseGreyColor,
      baseGrey2Color,
      baseGrey3Color,
      baseGrey4Color,
      baseGrey5Color,
      baseGrey6Color,
      errorColor,
      userAccentColor,
      textPrimaryColor,
      dialogBackgroundColor,
      boxShadow,
      brightness}) {
    brightness = brightness ?? LeouiBrightness.light;
    bool isDark = brightness == LeouiBrightness.dark;
    backgroundPrimaryColor = isDark ? Colors.black : Colors.white;
    backgroundSecondaryColor = isDark
        ? Color.fromRGBO(28, 28, 30, 1)
        : Color.fromRGBO(242, 242, 247, 1);
    backgroundTertiaryColor =
        isDark ? Color.fromRGBO(44, 44, 46, 1) : Colors.white;

    opaqueSeparatorColor = isDark
        ? Color.fromRGBO(56, 56, 58, 1)
        : Color.fromRGBO(198, 198, 200, 1);
    nonOpaqueSeparatorColor = isDark
        ? Color.fromRGBO(84, 84, 88, 0.65)
        : Color.fromRGBO(60, 60, 67, 0.36);

    labelPrimaryColor = isDark ? Colors.white : Colors.black;
    labelSecondaryColor = isDark
        ? Color.fromRGBO(235, 235, 245, 0.6)
        : Color.fromRGBO(60, 60, 67, 0.6);
    labelTertiaryColor = isDark
        ? Color.fromRGBO(235, 235, 245, 0.3)
        : Color.fromRGBO(60, 60, 67, 0.3);
    labelQuarternaryColor = isDark
        ? Color.fromRGBO(235, 235, 245, 0.18)
        : Color.fromRGBO(60, 60, 67, 0.18);

    fillPrimaryColor = isDark
        ? Color.fromRGBO(120, 120, 128, 0.36)
        : Color.fromRGBO(120, 120, 128, 0.2);
    fillSecondaryColor = isDark
        ? Color.fromRGBO(120, 120, 128, 0.32)
        : Color.fromRGBO(120, 120, 128, 0.16);
    fillTertiaryColor = isDark
        ? Color.fromRGBO(120, 120, 128, 0.24)
        : Color.fromRGBO(120, 120, 128, 0.12);
    fillQuarternaryColor = isDark
        ? Color.fromRGBO(120, 120, 128, 0.18)
        : Color.fromRGBO(120, 120, 128, 0.08);

    baseRedColor = isDark
        ? Color.fromRGBO(255, 69, 58, 1)
        : Color.fromRGBO(255, 69, 48, 1);
    baseOrangeColor = isDark
        ? Color.fromRGBO(255, 159, 10, 1)
        : Color.fromRGBO(255, 149, 0, 1);
    baseYellowColor = isDark
        ? Color.fromRGBO(255, 214, 10, 1)
        : Color.fromRGBO(255, 204, 0, 1);
    baseGreenColor = isDark
        ? Color.fromRGBO(50, 215, 75, 1)
        : Color.fromRGBO(52, 199, 89, 1);
    baseTealColor = isDark
        ? Color.fromRGBO(100, 210, 255, 1)
        : Color.fromRGBO(90, 200, 250, 1);
    baseBlueColor = isDark
        ? Color.fromRGBO(10, 132, 255, 1)
        : Color.fromRGBO(0, 122, 255, 1);
    baseIndigoColor = isDark
        ? Color.fromRGBO(94, 92, 230, 1)
        : Color.fromRGBO(88, 86, 214, 1);
    basePurpleColor = isDark
        ? Color.fromRGBO(191, 90, 242, 1)
        : Color.fromRGBO(175, 82, 222, 1);
    basePinkColor = isDark
        ? Color.fromRGBO(255, 55, 95, 1)
        : Color.fromRGBO(255, 45, 85, 1);
    baseGreyColor = isDark
        ? Color.fromRGBO(142, 142, 147, 1)
        : Color.fromRGBO(142, 142, 147, 1);
    baseGrey2Color = isDark
        ? Color.fromRGBO(99, 99, 102, 1)
        : Color.fromRGBO(147, 147, 178, 1);
    baseGrey3Color = isDark
        ? Color.fromRGBO(72, 72, 74, 1)
        : Color.fromRGBO(199, 199, 204, 1);
    baseGrey4Color = isDark
        ? Color.fromRGBO(58, 58, 60, 1)
        : Color.fromRGBO(209, 209, 214, 1);
    baseGrey5Color = isDark
        ? Color.fromRGBO(44, 44, 46, 1)
        : Color.fromRGBO(229, 229, 234, 1);
    baseGrey6Color = isDark
        ? Color.fromRGBO(28, 28, 30, 1)
        : Color.fromRGBO(242, 242, 247, 1);

    dialogBackgroundColor = isDark
        ? Color.fromRGBO(30, 30, 30, 0.99)
        : Color.fromRGBO(242, 242, 242, .99);

    errorColor = isDark
        ? Color.fromRGBO(207, 102, 121, 1.000)
        : Color.fromRGBO(176, 1, 32, 1.000);

    userAccentColor = isDark ? Color(0xFF0A7AFF) : Color(0xFF0084FF);

    boxShadow = isDark
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
    return LeoThemeData.raw(
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
        brightness: brightness);
  }

  const LeoThemeData.raw(
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
      required this.brightness});

  factory LeoThemeData.dark() => LeoThemeData(brightness: LeouiBrightness.dark);
  factory LeoThemeData.light() =>
      LeoThemeData(brightness: LeouiBrightness.light);
}

class LeoTheme extends InheritedWidget {
  final Widget child;

  final LeoThemeData? theme;

  LeoTheme({
    Key? key,
    required this.child,
    this.theme,
  }) : super(key: key, child: child);

  static LeoThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LeoTheme>()?.theme ??
      LeoThemeData.light();

  @override
  bool updateShouldNotify(LeoTheme oldWidget) => theme != oldWidget.theme;
}
