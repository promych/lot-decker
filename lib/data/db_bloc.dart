import 'dart:async';

import '../models/deck.dart';
import 'persistent_database.dart';

class DbBloc {
  PersistentDatabase get _db => SembastDatabase();

  // decks

  int selectedDeckId;

  Stream<List<Deck>> get $decksStream => _db.decks().asStream();

  Future<Deck> get currentDeck async {
    final decks = await _db.decks();
    return decks.firstWhere((deck) => deck.id == selectedDeckId,
        orElse: () => null);
  }

  // favorites

  List<String> _favoritedCards = <String>[];
  List<String> get favoritedCards => _favoritedCards;

  bool isCardFavorite(String cardCode) => _favoritedCards.contains(cardCode);

  StreamController<List<String>> _favoritedCardsController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get $favoritedCards => _favoritedCardsController.stream;

  Future<void> updateFavoriteCard(String cardCode) async {
    await _db.updateFavoriteCard(cardCode);
    isCardFavorite(cardCode)
        ? _favoritedCards.remove(cardCode)
        : _favoritedCards.add(cardCode);
    _favoritedCardsController.sink.add(_favoritedCards);
    // print(_favoritedCards);
  }

  // load

  Future<void> load() async {
    _favoritedCards = await _db.favoritedCards();
    _favoritedCardsController.sink.add(_favoritedCards);
  }

  dispose() {
    _favoritedCardsController.close();
  }
}
