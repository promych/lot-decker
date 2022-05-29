import 'dart:ui' show Locale;

const Map<String, Locale> kAppLocales = {
  'EN': const Locale('en', 'US'),
  'DE': const Locale('de', 'DE'),
  'ES': const Locale('es', 'ES'),
  'FR': const Locale('fr', 'FR'),
  'IT': const Locale('it', 'IT'),
  'RU': const Locale('ru', 'RU'),
  'TR': const Locale('tr', 'TR'),
};

const kSetsNumber = 6; // TODO change this when new set is added to game

const kMaxRegionsInDeck = 2;
const kMaxSameCardsInDeck = 3;
const kMaxChampionsInDeck = 6;
const kMaxCardsInDeck = 40;

const kIconSize = 24.0;
