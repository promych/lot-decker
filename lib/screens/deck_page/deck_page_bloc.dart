import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lor_builder/helpers/extensions.dart';
import 'package:lor_deck_coder/lor_deck_coder.dart';

import '../../data/persistent_database.dart';
import '../../helpers/constants.dart';
import '../../managers/app_manager.dart';
import '../../models/card.dart';
import '../../models/deck.dart';

class DeckPageBloc implements FilterBloc {
  final Deck? deck;
  final List<CardModel> cards;

  DeckPageBloc({
    required this.deck,
    required this.cards,
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
  }

  // deck

  final _deckNameController = StreamController<String>.broadcast();
  Stream<String> get $deckName => _deckNameController.stream;

  final _deckNameToShow = StreamController<String>();
  Stream<String> get $deckNameToShow => _deckNameToShow.stream;

  void updateName(String name) => _deckNameToShow.sink.add(name);

  void onEditName(String text) {
    if (text.isNotEmpty || text == '') {
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
    await _db.deleteDeck(deck!.id);
  }

  Future<String> deckCode() async {
    final cardCodes = Map<String, int>();
    cardCodes.addEntries(_selectedCards.map((card) =>
        MapEntry<String, int>(card.cardCode, _selectedCards.where((c) => c.cardCode == card.cardCode).length)));

    try {
      return await LorDeckCoder.encodeToCode(cardCodes);
    } on PlatformException catch (e) {
      return e.message ?? 'Error';
    }
  }

  // cards and mana cost

  final _selectedCardsController = StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> get $selectedCards => _selectedCardsController.stream;

  List<CardModel> get selectedCards => _selectedCards;

  int sameCardsInDeckNum(CardModel card) => _selectedCards.where((c) => c.cardCode == card.cardCode).length;

  final _manaCostController = StreamController<Map<String, int>>();
  Stream<Map<String, int>> get $manaCost => _manaCostController.stream;

  void selectCard(CardModel selectedCard) {
    if (sameCardsInDeckNum(selectedCard) >= kMaxSameCardsInDeck || _selectedCards.length == kMaxCardsInDeck) return;

    if (selectedCard.cardType == 'Champion' &&
        _selectedCards.where((c) => c.cardType == selectedCard.cardType).length >= kMaxChampionsInDeck) return;

    final _selectedFactions = _selectedCards
        .map(
          (card) => card.regionRefs,
        )
        .expand((e) => e)
        .toSet();
    if ((_selectedFactions.length + 1 > kMaxRegionsInDeck) &&
        !_selectedFactions.any(
          (e) => selectedCard.regionRefs.contains(e),
        )) return;

    _selectedCards.add(selectedCard);
    _manaCost.update(selectedCard.cost > 7 ? '7' : selectedCard.cost.toString(), (i) => i + 1, ifAbsent: () => 1);
    _manaCostController.sink.add(_manaCost);
    _selectedCardsController.sink.add(_selectedCards);
  }

  void unselectCard(CardModel selectedCard) {
    if (_selectedCards.remove(selectedCard)) {
      _manaCost.update(selectedCard.cost > 7 ? '7' : selectedCard.cost.toString(), (i) => i - 1);
      _manaCostController.sink.add(_manaCost);
      _selectedCardsController.sink.add(_selectedCards);
    }
  }

  // filter // TODO refactor this mostly duplicated code in app_manager.dart

  List<CardModel> _filteredCards = [];
  List<CardModel> get filteredCards => _filteredCards;

  final _filteredCardsController = StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> $filteredCards = Stream.empty();

  var _filter = Map<String, List<dynamic>>();
  Map<String, List<dynamic>> get filter => _filter;

  final _filterController = StreamController<Map<String, List<dynamic>>>.broadcast();
  Stream<Map<String, List<dynamic>>> get $filter => _filterController.stream;

  bool inFilter(MapEntry<String, dynamic> entry) {
    return _filter.containsKey(entry.key) && (_filter[entry.key]?.contains(entry.value) ?? false);
  }

  void updateFilter(MapEntry<String, dynamic> entry) {
    final newValue = _filter.update(
      entry.key,
      (value) {
        return value.contains(entry.value) ? (value..remove(entry.value)) : (value..add(entry.value));
      },
      ifAbsent: () => [entry.value],
    );
    if (newValue.isEmpty) _filter.remove(entry.key);
    _filterController.sink.add(_filter);
    _applyFilter();
  }

  void clearFilter() {
    _filter.clear();
    _applyFilter();
    _filterController.sink.add(_filter);
  }

  void _applyFilter() {
    _filteredCards = _filter.isNotEmpty
        ? cards
            .where((card) => _filter.containsKey('regions')
                ? (_filter['regions']?.any((e) => card.regions.contains(e)) ?? false)
                : true)
            .where((card) {
              if (!_filter.containsKey('cost')) {
                return true;
              } else if (_filter['cost']?.contains(7) ?? false) {
                return (_filter['cost']?.contains(card.cost) ?? false || card.cost > 7);
              }
              return _filter['cost']?.contains(card.cost) ?? false;
            })
            .where((card) => _filter.containsKey('types') ? _filter['types']?.contains(card.cardType) ?? false : true)
            .where(
                (card) => _filter.containsKey('rarities') ? _filter['rarities']?.contains(card.rarity) ?? false : true)
            .toList()
        : cards;
    _filteredCardsController.sink.add(_filteredCards);
  }

  // selected bar
  int? _selectedManaCostBar;

  final _selectedManaCostBarController = StreamController<int>.broadcast();
  Stream<int> get $selectedManaCostBar => _selectedManaCostBarController.stream;

  void selectManaCostBar(int? i) {
    _selectedManaCostBar == i ? _selectedManaCostBar = null : _selectedManaCostBar = i;
    if (_selectedManaCostBar != null) _selectedManaCostBarController.sink.add(_selectedManaCostBar!);
  }

  // search field

  final _searchController = StreamController<String>.broadcast();
  Stream<String> get $searchText => _searchController.stream;

  void updateSearch(String text) {
    _searchController.sink.add(text);
  }

  // load

  List<CardModel> filterCards(List<CardModel> cards) {
    final filteredByMana = cards.where((card) {
      if (_selectedManaCostBar == null) {
        return true;
      } else if (_selectedManaCostBar == 7) {
        return (card.cost >= _selectedManaCostBar!);
      }
      return (card.cost == _selectedManaCostBar);
    });

    final selectedFactions = _selectedCards
        .map(
          (card) => card.regionRefs,
        )
        .expand((e) => e)
        .toSet();
    final filteredByFactions = filteredByMana.where(
      (card) => selectedFactions.length >= kMaxRegionsInDeck
          ? selectedFactions.any((e) => card.regionRefs.contains(e))
          : true,
    );

    return filteredByFactions.toList();
  }

  void load([Map<String, int> cardCodes = const {}]) {
    final tr = StreamTransformer<List<CardModel>, List<CardModel>>.fromHandlers(
        handleData: (value, sink) => sink.add(filterCards(value)));

    $filteredCards = _filteredCardsController.stream.transform(tr);

    _filteredCards = cards;
    _filteredCardsController.sink.add(_filteredCards);

    // $isEditing.listen((data) {
    // if (data) selectManaCostBar(0);
    // });

    $searchText.listen((text) {
      if (text.isNotEmpty && text != '') {
        _filteredCards = cards
            .where((card) =>
                card.name.toLowerCase().contains(text.toLowerCase()) ||
                card.description.toLowerCase().contains(text.toLowerCase()))
            .toList();
        _filteredCardsController.sink.add(_filteredCards);
      } else {
        _filteredCardsController.sink.add(cards);
      }
    });

    $selectedCards.listen((data) => _filteredCardsController.sink.add(_filteredCards));

    $selectedManaCostBar.listen((data) => _filteredCardsController.sink.add(_filteredCards));

    if (deck != null) {
      _isEditing = false;
      _manaCost = deck?.manaCost ?? {};
      _selectedCards = deck?.cardCodes
              .map((cardCode) => cards.firstWhereOrNull((card) => card.cardCode == cardCode))
              .whereType<CardModel>()
              .toList() ??
          [];
    }

    if (cardCodes.isNotEmpty) {
      _selectedCards.clear();
      cardCodes.entries.forEach((e) {
        for (var i = 1; i <= e.value; i++) {
          try {
            final card = cards.singleWhere((card) => card.cardCode == e.key);
            _selectedCards.add(card);
            _manaCost.update(
              card.cost < 7 ? card.cost.toString() : '7',
              (v) => v + 1,
              ifAbsent: () => 1,
            );
          } on StateError {
            continue;
          }
        }
      });
    }

    _editingController.sink.add(_isEditing);
    _manaCostController.sink.add(_manaCost);
    _selectedCardsController.sink.add(_selectedCards);
  }

  void dispose() {
    _filterController.close();
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
