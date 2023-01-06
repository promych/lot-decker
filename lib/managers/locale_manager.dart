import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../helpers/constants.dart';

class LocaleManager {
  Locale locale;

  LocaleManager(this.locale);

  static LocaleManager? of(BuildContext context) => Localizations.of<LocaleManager>(context, LocaleManager);

  Map<String, dynamic> _sentences = {};

  Future<bool> load() async {
    String data;
    if (locale.countryCode == null && kAppLocales['EN'] != null) {
      locale = kAppLocales['EN']!;
    }
    data = await rootBundle.loadString('assets/lang/${locale.languageCode}_${locale.countryCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    _sentences = new Map();
    _result.forEach((String key, dynamic value) {
      _sentences[key] = value;
    });

    return true;
  }

  String translate(String key, {List<String> args = const []}) {
    String res = _resolve(key, _sentences);
    if (args.isNotEmpty) {
      args.forEach((String str) {
        res = res.replaceFirst(RegExp(r'{}'), str);
      });
    }
    return res;
  }

  // String plural(String key, dynamic value) {
  //   String res = '';
  //   if (value == 0) {
  //     res = _sentences[key]['zero'];
  //   } else if (value == 1) {
  //     res = _sentences[key]['one'];
  //   } else {
  //     res = _sentences[key]['other'];
  //   }
  //   return res.replaceFirst(RegExp(r'{}'), '$value');
  // }

  String _resolve(String path, dynamic obj) {
    List<String> keys = path.split('.');

    if (keys.length > 1) {
      for (int index = 0; index <= keys.length; index++) {
        if (obj.containsKey(keys[index]) && obj[keys[index]] is! String) {
          return _resolve(keys.sublist(index + 1, keys.length).join('.'), obj[keys[index]]);
        }

        return obj[path] ?? path;
      }
    }

    return obj[path] ?? path;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<LocaleManager> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => kAppLocales.values.map((l) => l.languageCode).contains(locale.languageCode);

  @override
  Future<LocaleManager> load(Locale locale) async {
    LocaleManager localizations = LocaleManager(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocaleManager> old) => true;
}
