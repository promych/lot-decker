import 'dart:async';

import '../models/card.dart';

mixin FilterMixin {
  List<CardModel> _filteredCards;
  List<CardModel> get filteredCards => _filteredCards;

  final _filteredCardsController = StreamController<List<CardModel>>.broadcast();
  Stream<List<CardModel>> $filteredCards;

  var _filter = Map<String, List<dynamic>>();
  Map<String, List<dynamic>> get filter => _filter;

  final _filterController = StreamController<Map<String, List<dynamic>>>.broadcast();
  Stream<Map<String, List<dynamic>>> get $filter => _filterController.stream;

  bool inFilter(MapEntry<String, dynamic> entry) {
    return _filter.containsKey(entry.key) && _filter[entry.key].contains(entry.value);
  }

  dispose() {
    _filteredCardsController.close();
    _filterController.close();
  }
}
