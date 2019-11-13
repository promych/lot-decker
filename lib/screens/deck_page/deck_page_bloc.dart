import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/persistent_database.dart';
import '../../helpers/constants.dart';
import '../../models/card.dart';
import '../../models/deck.dart';

class DeckPageBloc {
  final Deck deck;
  final List<CardModel> cards;

  DeckPageBloc({
    @required this.deck,
    @required this.cards,
  });

  bool _isEditing = true;
  List<CardModel> _selectedCards = [];
  Map<String, int> _manaCost = Map<String, int>.fromIterables(
    List<String>.generate(8, (i) => i.toString()),
    List<int>.filled(8, 0),
  );

  PersistentDatabase get _db => SembastDatabase();

  // editing flag

  final _editingController = StreamController<bool>.broadcast();
  Stream<bool> get $isEditing => _editingController.stream;

  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    _editingController.sink.add(_isEditing);
    // selectManaCostBar(0);
  }

  // deck

  final _deckNameController = StreamController<String>.broadcast();
  Stream<String> get $deckName => _deckNameController.stream;

  final _deckNameToShow = StreamController<String>();
  Stream<String> get $deckNameToShow => _deckNameToShow.stream;

  void updateName(String name) => _deckNameToShow.sink.add(name);

  void onEditName(String text) {
    if (text == null || text == '') {
      _deckNameController.sink.addError('Field can\'t be empty');
    } else {
      _deckNameController.sink.add(text);
    }
  }

  Future<void> saveDeck(String name) async {
    _deckNameToShow.sink.add(name);

    final newDeck = Deck(
      id: deck?.id ?? Deck.uniqueId,
      name: name,
      cardCodes: _selectedCards.map((card) => card.cardCode).toList(),
      manaCost: _manaCost,
    );

    await _db.saveDeck(newDeck);
  }

  Future<void> deleteDeck() async {
    if (deck == null) return;
    await _db.deleteDeck(deck.id);
  }

  // cards and mana cost

  final _selectedCardsController =
      StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> get $selectedCards => _selectedCardsController.stream;

  List<CardModel> get selectedCards => _selectedCards;

  int sameCardsInDeckNum(CardModel card) =>
      _selectedCards.where((c) => c.cardCode == card.cardCode).length;

  final _manaCostController = StreamController<Map<String, int>>();
  Stream<Map<String, int>> get $manaCost => _manaCostController.stream;

  void selectCard(CardModel selectedCard) {
    if (sameCardsInDeckNum(selectedCard) >= kMaxSameCardsInDeck) return;
    if (selectedCard.cardType == 'Champion' &&
        _selectedCards
                .where((c) => c.cardType == selectedCard.cardType)
                .length >=
            kMaxChampionsInDeck) return;

    final _selectedFactions =
        _selectedCards.map((card) => card.regionRef).toSet();
    if ((_selectedFactions.length + 1 > kMaxRegionsInDeck) &&
        !_selectedFactions.contains(selectedCard.regionRef)) return;

    _selectedCards.add(selectedCard);
    _manaCost.update(selectedCard.cost.toString(), (i) => i + 1);
    _manaCostController.sink.add(_manaCost);
    _selectedCardsController.sink.add(_selectedCards);
  }

  void unselectCard(CardModel selectedCard) {
    if (_selectedCards.remove(selectedCard)) {
      _manaCost.update(selectedCard.cost.toString(), (i) => i - 1);
      _manaCostController.sink.add(_manaCost);
      _selectedCardsController.sink.add(_selectedCards);
    }
  }

  // filter

  List<CardModel> _filteredCards;
  List<CardModel> get filteredCards => _filteredCards;

  final _filteredCardsController =
      StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> $filteredCards;

  // selected bar
  int _selectedManaCostBar;

  final _selectedManaCostBarController = StreamController<int>.broadcast();
  Stream<int> get $selectedManaCostBar => _selectedManaCostBarController.stream;

  void selectManaCostBar(int i) {
    _selectedManaCostBar == i
        ? _selectedManaCostBar = null
        : _selectedManaCostBar = i;
    _selectedManaCostBarController.sink.add(_selectedManaCostBar);
  }

  // search field

  final _searchController = StreamController<String>.broadcast();
  Stream<String> get $searchText => _searchController.stream;

  void updateSearch(String text) {
    if (text != null && text != '') _searchController.sink.add(text);
  }

  // load

  List<CardModel> filterCards(cards) {
    final selectedFactions =
        _selectedCards.map((card) => card.regionRef).toSet();
    return cards
        .where((card) => _selectedManaCostBar != null
            ? card.cost == _selectedManaCostBar
            : true)
        .where((card) => selectedFactions.length >= kMaxRegionsInDeck
            ? selectedFactions.contains(card.regionRef)
            : true)
        .toList();
  }

  void load() {
    final tr = StreamTransformer<List<CardModel>, List<CardModel>>.fromHandlers(
        handleData: (value, sink) => sink.add(filterCards(value)));

    $filteredCards = _filteredCardsController.stream.transform(tr);
    // ..listen((data) {
    //   print(data.length);
    // });

    _filteredCards = cards;
    _filteredCardsController.sink.add(_filteredCards);

    $isEditing.listen((data) {
      if (data) selectManaCostBar(0);
    });

    $searchText.listen((text) {
      if (text != null && text != '') {
        _filteredCardsController.sink.add(cards
            .where(
                (card) => card.name.toLowerCase().contains(text.toLowerCase()))
            .toList());
      } else {
        _filteredCardsController.sink.add(cards);
      }
    });

    $selectedCards
        .listen((data) => _filteredCardsController.sink.add(_filteredCards));

    $selectedManaCostBar
        .listen((data) => _filteredCardsController.sink.add(_filteredCards));

    if (deck != null) {
      _isEditing = false;
      _manaCost = deck.manaCost;
      _selectedCards = deck.cardCodes
          .map((cardCode) => cards.firstWhere(
              (card) => card.cardCode == cardCode,
              orElse: () => null))
          .toList();
    }

    _editingController.sink.add(_isEditing);
    _manaCostController.sink.add(_manaCost);
    _selectedCardsController.sink.add(_selectedCards);
  }

  void dispose() {
    _editingController.close();
    _deckNameController.close();
    _deckNameToShow.close();
    _selectedCardsController.close();
    _searchController.close();
    _selectedManaCostBarController.close();
    _filteredCardsController.close();
    _manaCostController.close();
  }
}
