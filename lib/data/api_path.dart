import 'package:flutter/widgets.dart';

class APIPath {
  static String cards(Locale locale, int setNum) =>
      'assets/data/set$setNum-${locale.toString().toLowerCase()}.json';

  static String globals(Locale locale) =>
      'assets/data/globals-${locale.toString().toLowerCase()}.json';
}
