import 'package:flutter/foundation.dart';

const Map<String, Map<String, String>> _kTypes = {
  'en': {
    'Champion': 'Champion',
    'Spell': 'Spell',
    'Unit': 'Unit',
  },
  'de': {
    'Champion': 'Champion',
    'Spell': 'Zauber',
    'Unit': 'Einheit',
  },
  'es': {
    'Champion': 'Campeón',
    'Spell': 'Hechizo',
    'Unit': 'Unidad',
  },
  'fr': {
    'Champion': 'Champion',
    'Spell': 'Sort',
    'Unit': 'Unité',
  },
  'it': {
    'Champion': 'Campione',
    'Spell': 'Incantesimo',
    'Unit': 'Unità',
  },
  'ru': {
    'Champion': 'Чемпион',
    'Spell': 'Заклинание',
    'Unit': 'Боец',
  },
  'tr': {
    'Champion': 'Şampiyon',
    'Spell': 'Büyü',
    'Unit': 'Birim',
  },
  'ja': {
    'Champion': 'チャンピオン',
    'Spell': 'スペル',
    'Unit': 'ユニット',
  },
  'ko': {
    'Champion': '챔피언',
    'Spell': '주문',
    'Unit': '유닛',
  },
};

const kChampionsNamesRU = {
  'Анивия': 'Anivia',
  'Эш': 'Ashe',
  'Дариус': 'Darius',
  'Браум': 'Braum',
  'Дрейвен': 'Draven',
  'Элиза': 'Elise',
  'Эзреаль': 'Ezreal',
  'Фиора': 'Fiora',
  'Физз': 'Fizz',
  'Гангпланк': 'Gangplank',
  'Гарен': 'Garen',
  'Гекарим': 'Hecarim',
  'Хеймердингер': 'Heimerdinger',
  'Джинкс': 'Jinx',
  'Калиста': 'Kalista',
  'Карма': 'Karma',
  'Катарина': 'Katarina',
  'Ли Син': 'LeeSin',
  'Люциан': 'Lucian',
  'Люкс': 'Lux',
  'Маокай': 'Maokai',
  'Мисс Фортуна': 'MissFortune',
  'Наутилус': 'Nautilus',
  'Квинн': 'Quinn',
  'Седжуани': 'Sejuani',
  'Шен': 'Shen',
  'Свейн': 'Swain',
  'Тимо': 'Teemo',
  'Треш': 'Thresh',
  'Триндамир': 'Tryndamere',
  'Твистед Фэйт': 'TwistedFate',
  'Вай': 'Vi',
  'Владимир': 'Vladimir',
  'Ясуо': 'Yasuo',
  'Зед': 'Zed'
};

abstract class Referable {
  final String name;
  final String nameRef;

  Referable({@required this.name, @required this.nameRef});
}

class Globals {
  final List<Keyword> keywords;
  final List<Region> regions;
  final List<SpellSpeed> spellSpeeds;
  final List<Rarity> rarities;
  final List<CardType> cardTypes;

  const Globals({
    @required this.keywords,
    @required this.regions,
    @required this.spellSpeeds,
    @required this.rarities,
    @required this.cardTypes,
  });

  static Globals fromJson(Map<String, dynamic> json, {String lang = 'en'}) =>
      Globals(
        keywords: List.from(json['keywords'].map((k) => Keyword.fromJson(k))),
        regions: List.from(json['regions'].map((k) => Region.fromJson(k))),
        spellSpeeds:
            List.from(json['spellSpeeds'].map((k) => SpellSpeed.fromJson(k))),
        rarities: List.from(json['rarities'].map((k) => Rarity.fromJson(k))),
        cardTypes: _kTypes[lang]
            .entries
            .map((e) => CardType(name: e.value, nameRef: e.key))
            .toList(),
      );

  String cardTypeRef(String name) =>
      cardTypes.singleWhere((t) => t.name == name, orElse: () => null)?.nameRef;
}

class CardType implements Referable {
  final String name;
  final String nameRef;

  const CardType({@required this.name, @required this.nameRef});
}

class Keyword implements Referable {
  final String description;
  final String name;
  final String nameRef;

  const Keyword({
    @required this.description,
    @required this.name,
    @required this.nameRef,
  });

  static Keyword fromJson(Map<String, dynamic> json) => Keyword(
        description: json['description'],
        name: json['name'],
        nameRef: json['nameRef'],
      );
}

class Region implements Referable {
  final String abbreviation;
  final String name;
  final String nameRef;

  const Region({
    @required this.abbreviation,
    @required this.name,
    @required this.nameRef,
  });

  static Region fromJson(Map<String, dynamic> json) => Region(
        abbreviation: json['abbreviation'],
        name: json['name'],
        nameRef: json['nameRef'],
      );
}

class SpellSpeed implements Referable {
  final String name;
  final String nameRef;

  const SpellSpeed({
    @required this.name,
    @required this.nameRef,
  });

  static SpellSpeed fromJson(Map<String, dynamic> json) => SpellSpeed(
        name: json['name'],
        nameRef: json['nameRef'],
      );
}

class Rarity implements Referable {
  final String name;
  final String nameRef;

  const Rarity({
    @required this.name,
    @required this.nameRef,
  });

  static Rarity fromJson(Map<String, dynamic> json) => Rarity(
        name: json['name'],
        nameRef: json['nameRef'],
      );
}
