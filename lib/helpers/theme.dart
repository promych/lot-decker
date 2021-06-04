import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const appCupertinoTheme = CupertinoThemeData(
//   scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
//   primaryColor: CupertinoColors.white,
// );

final appMaterialTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
  primaryColor: CupertinoColors.white,
  buttonColor: Styles.cyanColor,
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

  // text fields
  // static const EdgeInsetsGeometry textFieldPadding = const EdgeInsets.all(8.0);

  // static const TextStyle textFildStyle = TextStyle(color: Styles.lightGrey);

  // static BoxDecoration textFieldDecoration = BoxDecoration(
  //   color: Styles.layerColor,
  //   borderRadius: BorderRadius.circular(10.0),
  // );
}
