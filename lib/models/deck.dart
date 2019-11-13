import 'package:flutter/foundation.dart';

class Deck {
  final String name;
  final List<String> cardCodes;
  final Map<String, int> manaCost;
  final int id;

  const Deck({
    @required this.id,
    @required this.name,
    @required this.cardCodes,
    @required this.manaCost,
  });

  Deck.fromMap(MapEntry<int, Map<String, dynamic>> data)
      : this.id = data.key,
        this.name = data.value['name'],
        this.cardCodes = List<String>.from(data.value['cardCodes']),
        this.manaCost = Map<String, int>.from(data.value['manaCost']);

  static int get uniqueId => DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'cardCodes': cardCodes,
        'manaCost': manaCost,
      };

  List<String> get factions {
    if (cardCodes.isEmpty) return [];
    return cardCodes.map((card) => card.substring(2, 4)).toSet().toList();
  }

  //encode-decode with Platform
  static String encode(Deck deck) {
    return 'CEAAECABAQJRWHBIFU2DOOYIAEBAMCIMCINCILJZAICACBANE4VCYBABAILR2HRL';
  }

  static Deck decode(String code) {
    return Deck(
      id: uniqueId,
      name: code,
      cardCodes: ['01DE123'],
      manaCost: {},
    );
  }
}
