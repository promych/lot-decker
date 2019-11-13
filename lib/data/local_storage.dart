import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter/services.dart';

import '../models/card.dart';
import '../models/globals.dart';
import 'api_path.dart';

class LocalStorage {
  static Future<List<CardModel>> fetchCards(Locale locale) async {
    print('cards load with ${locale.countryCode}');
    String data = await rootBundle.loadString(APIPath.cards(locale));
    List<Map<String, dynamic>> cardsJson = List.from(json.decode(data));
    return cardsJson
        .map((json) => CardModel.fromMap(json, lang: locale.toString()))
        .toList();
  }

  static Future<Globals> fetchGlobals(Locale locale) async {
    print('globals load with ${locale.countryCode}');
    String data = await rootBundle.loadString(APIPath.globals(locale));
    Map<String, dynamic> globalsJson = json.decode(data);
    return Globals.fromJson(globalsJson, lang: locale.languageCode);
  }
}
