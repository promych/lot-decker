import 'package:flutter/widgets.dart';

class APIPath {
  static String cards(Locale locale) =>
      'assets/data/set1-${locale.toString().toLowerCase()}.json';

  static String globals(Locale locale) =>
      'assets/data/globals-${locale.toString().toLowerCase()}.json';
}
