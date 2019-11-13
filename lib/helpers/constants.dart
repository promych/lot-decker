import 'dart:ui' show Locale;

const Map<String, Locale> kAppLocales = {
  'EN': const Locale('en', 'US'),
  'DE': const Locale('de', 'DE')
};

// const Map<String, String> kFactions = {
//   'DE': 'Demacia',
//   'FR': 'Freljord',
//   'IO': 'Ionia',
//   'NX': 'Noxus',
//   'PZ': 'Piltover & Zaun',
//   'SI': 'Shadow Isles',
// };

// const kCardTypes = {
//   'types': ['Champion', 'Spell', 'Unit']
// };

// const kCardRarities = {
//   'rarities': ['Champion', 'Rare', 'Epic', 'Common']
// };

const kMaxRegionsInDeck = 2;
const kMaxSameCardsInDeck = 3;
const kMaxChampionsInDeck = 6;

const kIconSize = 24.0;
