import 'package:flutter/cupertino.dart';
import 'package:lor_builder/managers/locale_manager.dart';

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension Translate on BuildContext {
  String translate(String text) {
    return LocaleManager.of(this)?.translate(text) ?? text;
  }
}
