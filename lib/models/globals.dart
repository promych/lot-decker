import 'package:lor_builder/helpers/extensions.dart';

const Map<String, Map<String, String>> _kTypes = {
  'en': {
    'Champion': 'Champion',
    'Spell': 'Spell',
    'Unit': 'Unit',
    'Landmark': 'Landmark',
    'Equipment': 'Equipment',
  },
  'de': {
    'Champion': 'Champion',
    'Spell': 'Zauber',
    'Unit': 'Einheit',
    'Landmark': 'Wahrzeichen',
    'Equipment': 'Ausrüstung',
  },
  'es': {
    'Champion': 'Campeón',
    'Spell': 'Hechizo',
    'Unit': 'Unidad',
    'Landmark': 'Hito',
    'Equipment': 'Equipo',
  },
  'fr': {
    'Champion': 'Champion',
    'Spell': 'Sort',
    'Unit': 'Unité',
    'Landmark': 'Site',
    'Equipment': 'Équipement',
  },
  'it': {
    'Champion': 'Campione',
    'Spell': 'Incantesimo',
    'Unit': 'Unità',
    'Landmark': 'Monumento',
    'Equipment': 'Attrezzatura',
  },
  'ru': {
    'Champion': 'Чемпион',
    'Spell': 'Заклинание',
    'Unit': 'Боец',
    'Landmark': 'Место силы',
    'Equipment': 'Снаряжение',
  },
  'tr': {
    'Champion': 'Şampiyon',
    'Spell': 'Büyü',
    'Unit': 'Birim',
    'Landmark': 'Yer',
    'Equipment': 'Teçhizat',
  },
  'ja': {
    'Champion': 'チャンピオン',
    'Spell': 'スペル',
    'Unit': 'ユニット',
    'Landmark': 'Landmark',
    'Equipment': '装置',
  },
  'ko': {
    'Champion': '챔피언',
    'Spell': '주문',
    'Unit': '유닛',
    'Landmark': 'Landmark',
    'Equipment': '장비',
  },
};

abstract class Referable {
  final String name;
  final String nameRef;

  Referable({required this.name, required this.nameRef});
}

class Globals {
  final List<Keyword> keywords;
  final List<Region> regions;
  final List<SpellSpeed> spellSpeeds;
  final List<Rarity> rarities;
  final List<CardType> cardTypes;

  const Globals({
    required this.keywords,
    required this.regions,
    required this.spellSpeeds,
    required this.rarities,
    required this.cardTypes,
  });

  static Globals fromJson(Map<String, dynamic> json, {String lang = 'en'}) => Globals(
        keywords: List.from(json['keywords'].map((k) => Keyword.fromJson(k))),
        regions: List.from(json['regions'].map((k) => Region.fromJson(k)))
          ..removeWhere((e) => [
                'Jhin',
                'Bard',
                'Evelynn',
                'Jax',
                'Kayn',
                'Varus',
                'Ryze',
                'Aatrox',
              ].contains(e.name)), // TODO fix 3.8 constants.dart/regions
        spellSpeeds: List.from(json['spellSpeeds'].map((k) => SpellSpeed.fromJson(k))),
        rarities: List.from(json['rarities'].map((k) => Rarity.fromJson(k))),
        cardTypes: _kTypes[lang]?.entries.map((e) => CardType(name: e.value, nameRef: e.key)).toList() ?? [],
      );

  String? cardTypeRef(String name) => cardTypes.firstWhereOrNull((t) => t.name == name)?.nameRef;
}

class CardType implements Referable {
  final String name;
  final String nameRef;

  const CardType({required this.name, required this.nameRef});
}

class Keyword implements Referable {
  final String description;
  final String name;
  final String nameRef;

  const Keyword({
    required this.description,
    required this.name,
    required this.nameRef,
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
    required this.abbreviation,
    required this.name,
    required this.nameRef,
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
    required this.name,
    required this.nameRef,
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
    required this.name,
    required this.nameRef,
  });

  static Rarity fromJson(Map<String, dynamic> json) => Rarity(
        name: json['name'],
        nameRef: json['nameRef'],
      );
}
