import 'dart:async';

import 'package:lor_builder/helpers/extensions.dart';

import '../models/deck.dart';
import 'persistent_database.dart';

class DbBloc {
  late PersistentDatabase _db;

  // decks

  int? selectedDeckId;

  Stream<List<Deck>> get decks$ => _db.decks$;

  Future<Deck?> get currentDeck async {
    final decks = await _db.decks();
    return decks.firstWhereOrNull((deck) => deck.id == selectedDeckId);
  }

  // favorites

  List<String> _favoritedCards = <String>[];
  List<String> get favoritedCards => _favoritedCards;

  bool isCardFavorite(String cardCode) => _favoritedCards.contains(cardCode);

  StreamController<List<String>> _favoritedCardsController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get $favoritedCards => _favoritedCardsController.stream;

  Future<void> updateFavoriteCard(String cardCode) async {
    await _db.updateFavoriteCard(cardCode);
    isCardFavorite(cardCode) ? _favoritedCards.remove(cardCode) : _favoritedCards.add(cardCode);
    _favoritedCardsController.sink.add(_favoritedCards);
    // print(_favoritedCards);
  }

  // load

  Future<void> load() async {
    _db = SembastDatabase();
    _favoritedCards = await _db.favoritedCards();
    _favoritedCardsController.sink.add(_favoritedCards);
  }

  dispose() {
    _favoritedCardsController.close();
  }
}
