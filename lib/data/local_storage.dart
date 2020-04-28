import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter/services.dart';

import '../helpers/constants.dart';
import '../models/card.dart';
import '../models/globals.dart';
import 'api_path.dart';

class LocalStorage {
  static Future<List<CardModel>> fetchCards(Locale locale) async {
    print('cards load with ${locale.countryCode}');
    final List<CardModel> cards = [];

    for (var i = 1; i <= kSetsNumber; i++) {
      String data = await rootBundle.loadString(APIPath.cards(locale, i));
      List<Map<String, dynamic>> cardsJson = List.from(json.decode(data));
      cards.addAll(cardsJson
          .map((json) => CardModel.fromMap(json, lang: locale.toString()))
          .toList());
    }

    return cards;
  }

  static Future<Globals> fetchGlobals(Locale locale) async {
    print('globals load with ${locale.countryCode}');
    String data = await rootBundle.loadString(APIPath.globals(locale));
    Map<String, dynamic> globalsJson = json.decode(data);
    return Globals.fromJson(globalsJson, lang: locale.languageCode);
  }
}
