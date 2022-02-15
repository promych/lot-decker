import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CardModel extends Equatable {
  final List<String> associatedCardRefs;
  final String imagePath;
  final List<String> regions;
  final List<String> regionRefs;
  final int attack;
  final int cost;
  final int health;
  final String description;
  final String flavor;
  final String name;
  final String cardCode;
  final List<String> keywords;
  final List<String> keywordRefs;
  final String spellSpeed;
  final String spellSpeedRef;
  final String rarity;
  final String rarityRef;
  final String subtype;
  final String supertype;
  final String type;
  final bool collectible;

  CardModel({
    this.associatedCardRefs,
    @required this.imagePath,
    @required this.regions,
    @required this.regionRefs,
    @required this.attack,
    @required this.cost,
    @required this.health,
    @required this.description,
    @required this.flavor,
    @required this.name,
    @required this.cardCode,
    this.keywords,
    this.keywordRefs,
    this.spellSpeed,
    this.spellSpeedRef,
    @required this.rarity,
    @required this.rarityRef,
    this.subtype,
    this.supertype,
    @required this.type,
    @required this.collectible,
  });

  factory CardModel.fromMap(Map<String, dynamic> data,
      {String lang = 'en_US'}) {
    return CardModel(
      associatedCardRefs: data['associatedCardRefs'].isEmpty
          ? []
          : List<String>.from(data['associatedCardRefs']),
      imagePath: 'assets/img/cards/${data['cardCode']}.webp',
      regions:
          data['regions'].isEmpty ? [] : List<String>.from(data['regions']),
      regionRefs: data['regionRefs'].isEmpty
          ? []
          : List<String>.from(data['regionRefs']),
      attack: data['attack'],
      cost: data['cost'],
      health: data['health'],
      description: data['descriptionRaw'],
      flavor: data['flavorText'],
      name: data['name'],
      cardCode: data['cardCode'],
      keywords:
          data['keywords'].isEmpty ? [] : List<String>.from(data['keywords']),
      keywordRefs: data['keywordRefs'].isEmpty
          ? []
          : List<String>.from(data['keywordRefs']),
      spellSpeed: data['spellSpeed'],
      spellSpeedRef: data['spellSpeedRef'],
      rarity: data['rarity'],
      rarityRef: data['rarityRef'],
      subtype: data['subtype'],
      supertype: data['supertype'],
      type: data['type'],
      collectible: data['collectible'],
    );
  }

  String get cardType => supertype.isNotEmpty
      ? supertype
      : (!['Trap', 'Ability'].contains(type) ? type : 'Spell');

  @override
  List<Object> get props => [cardCode];
}
