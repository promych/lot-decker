import 'package:flutter/foundation.dart';

const Map<String, Map<String, String>> _kTypes = {
  'en': {
    'Champion': 'Champion',
    'Spell': 'Spell',
    'Unit': 'Unit',
    'Landmark': 'Landmark',
  },
  'de': {
    'Champion': 'Champion',
    'Spell': 'Zauber',
    'Unit': 'Einheit',
    'Landmark': 'Wahrzeichen',
  },
  'es': {
    'Champion': 'Campeón',
    'Spell': 'Hechizo',
    'Unit': 'Unidad',
    'Landmark': 'Hito',
  },
  'fr': {
    'Champion': 'Champion',
    'Spell': 'Sort',
    'Unit': 'Unité',
    'Landmark': 'Site',
  },
  'it': {
    'Champion': 'Campione',
    'Spell': 'Incantesimo',
    'Unit': 'Unità',
    'Landmark': 'Monumento',
  },
  'ru': {
    'Champion': 'Чемпион',
    'Spell': 'Заклинание',
    'Unit': 'Боец',
    'Landmark': 'Место силы',
  },
  'tr': {
    'Champion': 'Şampiyon',
    'Spell': 'Büyü',
    'Unit': 'Birim',
    'Landmark': 'Yer',
  },
  'ja': {
    'Champion': 'チャンピオン',
    'Spell': 'スペル',
    'Unit': 'ユニット',
    'Landmark': 'Landmark',
  },
  'ko': {
    'Champion': '챔피언',
    'Spell': '주문',
    'Unit': '유닛',
    'Landmark': 'Landmark',
  },
};

const kChampionsNamesRU = {
  'Анивия': 'Anivia',
  'Афелий': 'Aphelios',
  'Аурелион Сол': 'AurelionSol',
  'Эш': 'Ashe',
  'Азир': 'Azir',
  'Дариус': 'Darius',
  'Браум': 'Braum',
  'Диана': 'Diana',
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
  'Джарван IV': 'JarvanIV',
  'Калиста': 'Kalista',
  'Карма': 'Karma',
  'Катарина': 'Katarina',
  'Киндред': 'Kindred',
  'Леона': 'Leona',
  'Ле Блан': 'LeBlanc',
  'Ли Син': 'LeeSin',
  'Люциан': 'Lucian',
  'Люкс': 'Lux',
  'Лиссандра': 'Lissandra',
  'Лулу': 'Lulu',
  'Маокай': 'Maokai',
  'Мисс Фортуна': 'MissFortune',
  'Насус': 'Nasus',
  'Наутилус': 'Nautilus',
  'Ноктюрн': 'Nocturne',
  'Квинн': 'Quinn',
  'Ренектон': 'Renekton',
  'Ривен': 'Riven',
  'Седжуани': 'Sejuani',
  'Шен': 'Shen',
  'Шивана': 'Shyvana',
  'Свейн': 'Swain',
  'Сивир': 'Sivir',
  'Сорака': 'Soraka',
  'Таам Кенч': 'TahmKench',
  'Талия': 'Taliyah',
  'Тарик': 'Taric',
  'Тимо': 'Teemo',
  'Треш': 'Thresh',
  'Трандл': 'Trundle',
  'Триндамир': 'Tryndamere',
  'Твистед Фэйт': 'TwistedFate',
  'Вай': 'Vi',
  'Виктор': 'Viktor',
  'Владимир': 'Vladimir',
  'Ясуо': 'Yasuo',
  'Зед': 'Zed',
  'Зои': 'Zoe',
  'Зилеан': 'Zilean',
  'Ирелия': 'Irelia',
  'Мальфит': 'Malphite',
  'Экко': 'Ekko',
  'Пайк': 'Pyke',
  'Рек’Сай': 'Rek’sai',
  'Виего': 'Viego',
  'Акшан': 'Akshan',
  'Нами': 'Nami',
  'Тристана': 'Tristana',
  'Зиггс': 'Ziggs',
  'Поппи': 'Poppy',
  'Вейгар': 'Veigar',
  'Кейтлин': 'Caitlyn',
  'Сенна': 'Senna',
  'Сион': 'Sion',
  'Зерат': 'Xerath',
  'Юми': 'Yuumi',
  'Галио': 'Galio',
  'Удир': 'Udyr',
  'Ари': 'Ahri',
  'Гнар': 'Gnar',
  'Джейс': 'Jayce',
  'Кеннен': 'Kennen',
  'Пантеон': 'Pantheon',
  'Рамбл': 'Rumble',
  'Иллаой': 'Illaoi',
  'Джин': 'Jhin',
  'Бард': 'Bard',
  'Энни': 'Annie',
  'Кай’Са': 'Kai’Sa',
  'Гвен': 'Gwen',
  'Эвелинн': 'Evelynn',
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

  static Globals fromJson(Map<String, dynamic> json, {String lang = 'en'}) => Globals(
        keywords: List.from(json['keywords'].map((k) => Keyword.fromJson(k))),
        regions: List.from(json['regions'].map((k) => Region.fromJson(k)))
          ..removeWhere((e) => ['Jhin', 'Bard', 'Evelynn'].contains(e.name)), // TODO fix 3.8 constants.dart/regions
        spellSpeeds: List.from(json['spellSpeeds'].map((k) => SpellSpeed.fromJson(k))),
        rarities: List.from(json['rarities'].map((k) => Rarity.fromJson(k))),
        cardTypes: _kTypes[lang].entries.map((e) => CardType(name: e.value, nameRef: e.key)).toList(),
      );

  String cardTypeRef(String name) => cardTypes.singleWhere((t) => t.name == name, orElse: () => null)?.nameRef;
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
