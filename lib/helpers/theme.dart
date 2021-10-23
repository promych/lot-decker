import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final appMaterialTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
  primaryColor: CupertinoColors.white,
);

abstract class Styles {
  // colors
  static const Color scaffoldBackgroundColor = const Color(0xff171e28);

  static const Color cyanColor = Color(0xff078d9b);

  static const Color layerColor = Color(0xff1d2730);

  static const Color lightGrey = Color(0xff37474f);

  static const Color defaultWhite = CupertinoColors.white;

  // text styles
  static const defaultText = TextStyle(color: CupertinoColors.white);

  static const defaultText16 = TextStyle(
    fontSize: 16.0,
    color: defaultWhite,
  );

  static const defaultText20 = TextStyle(
    fontSize: 20.0,
    color: defaultWhite,
    fontFamily: 'Alegreya',
  );
}
