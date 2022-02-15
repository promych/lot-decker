import 'dart:async';
import 'dart:ui' show Locale;

import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_storage.dart';
import '../helpers/constants.dart';
import '../models/card.dart';
import '../models/globals.dart';

abstract class FilterBloc {
  void dispose();
  void updateSearch(String text);
  void updateFilter(MapEntry<String, dynamic> entry);
  void clearFilter();
  Map<String, List<dynamic>> get filter;
  Stream<Map<String, List<dynamic>>> get $filter;
  bool inFilter(MapEntry<String, dynamic> entry);
}

class AppManager implements FilterBloc {
  Future<void> load() async {
    await _fetchLocale().whenComplete(() async {
      _globals = await LocalStorage.fetchGlobals(_locale);
      _cards = await LocalStorage.fetchCards(_locale)
        ..sort((a, b) => a.cost.compareTo(b.cost));
    });

    _cardsController.sink.add(_cards);
    clearFilter();

    $searchText.listen((text) {
      if (text != null && text != '') {
        _filteredCardsController.sink.add(_filteredCards
            .where((card) =>
                card.name.toLowerCase().contains(text.toLowerCase()) ||
                card.description.toLowerCase().contains(text.toLowerCase()))
            .toList());
      } else {
        _applyFilter();
      }
    });
  }

  // globals

  Globals _globals;
  Globals get globals => _globals;

  Region regionByName(String name) =>
      _globals.regions.firstWhere((r) => r.nameRef == name, orElse: () => null);

  Region regionByAbbrName(String name) => _globals.regions
      .firstWhere((r) => r.abbreviation == name, orElse: () => null);

  // locale

  Locale _locale;
  Locale get locale => _locale;

  final _localeController = StreamController<Locale>();
  Stream<Locale> get $locale => _localeController.stream;

  Future<void> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    final newLocale = (prefs.getString('languageCode') == null ||
            prefs.getString('countryCode') == null)
        ? kAppLocales['EN']
        : Locale(
            prefs.getString('languageCode'), prefs.getString('countryCode'));
    _locale = newLocale;
    _localeController.sink.add(newLocale);
  }

  Future<void> changeLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    await SharedPreferences.getInstance()
      ..setString('languageCode', newLocale.languageCode)
      ..setString('countryCode', newLocale.countryCode);
    _locale = newLocale;
    _localeController.sink.add(newLocale);

    _globals = await LocalStorage.fetchGlobals(_locale);
    _cards = await LocalStorage.fetchCards(_locale)
      ..sort((a, b) => a.cost.compareTo(b.cost));

    _cardsController.sink.add(_cards);
    clearFilter();
  }

  // cards

  List<CardModel> _cards = [];
  List<CardModel> get cards => _cards;

  final _cardsController = StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> get $cards => _cardsController.stream;

  List<CardModel> get cardsCollectible =>
      _cards.where((card) => card.collectible == true).toList();

  List<CardModel> associatedCards(List<String> cardCodes) =>
      _cards.where((card) => cardCodes.contains(card.cardCode)).toList();

  CardModel cardByCode(String code) =>
      _cards?.firstWhere((card) => card.cardCode == code, orElse: () => null);

  // search field

  final _searchController = StreamController<String>.broadcast();
  Stream<String> get $searchText => _searchController.stream;

  void updateSearch(String text) {
    if (text != null) _searchController.sink.add(text);
  }

  // filter

  List<CardModel> _filteredCards = [];
  List<CardModel> get filteredCards => _filteredCards;

  final _filteredCardsController =
      StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> get $filteredCards => _filteredCardsController.stream;

  var _filter = Map<String, List<dynamic>>();
  Map<String, List<dynamic>> get filter => _filter;

  final _filterController =
      StreamController<Map<String, List<dynamic>>>.broadcast();
  Stream<Map<String, List<dynamic>>> get $filter => _filterController.stream;

  void updateFilter(MapEntry<String, dynamic> entry) {
    final newValue = _filter.update(
      entry.key,
      (value) {
        return value.contains(entry.value)
            ? (value..remove(entry.value))
            : (value..add(entry.value));
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
        ? cardsCollectible
            .where((card) => _filter.containsKey('regions')
                ? card.regions.any((e) => _filter['regions'].contains(e))
                : true)
            .where((card) {
              if (!_filter.containsKey('cost')) {
                return true;
              } else if (_filter['cost'].contains(7)) {
                return (_filter['cost'].contains(card.cost) || card.cost > 7);
              }
              return _filter['cost'].contains(card.cost);
            })
            .where((card) => _filter.containsKey('types')
                ? _filter['types'].contains(card.cardType)
                : true)
            .where((card) => _filter.containsKey('rarities')
                ? _filter['rarities'].contains(card.rarity)
                : true)
            .toList()
        : cardsCollectible;
    _filteredCardsController.sink.add(_filteredCards);
  }

  bool inFilter(MapEntry<String, dynamic> entry) {
    return _filter.containsKey(entry.key) &&
        _filter[entry.key].contains(entry.value);
  }

  dispose() {
    _localeController.close();
    _cardsController.close();
    _filteredCardsController.close();
    _filterController.close();
    _searchController.close();
  }
}
