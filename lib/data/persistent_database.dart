import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/deck.dart';

abstract class PersistentDatabase {
  Future<List<Deck>> decks();
  Future<void> saveDeck(Deck deck);
  Future<void> deleteDeck(int id);
  Future<List<String>> favoritedCards();
  Future<void> updateFavoriteCard(String cardCode);
}

class SembastDatabase implements PersistentDatabase {
  final _service = SembastService.instance;

  @override
  Future<List<Deck>> decks() async {
    return await _service.decks();
  }

  @override
  Future<void> saveDeck(Deck deck) async {
    await _service.saveDeck(deck);
  }

  @override
  Future<void> deleteDeck(int id) async {
    await _service.deleteDeck(id);
  }

  @override
  Future<List<String>> favoritedCards() async {
    return await _service.favoritedCards();
  }

  @override
  Future<void> updateFavoriteCard(String cardCode) async {
    await _service.updateFavoriteCard(cardCode);
  }
}

class SembastService {
  SembastService._();

  static final SembastService instance = SembastService._();

  static Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await _openDatabase();
    return _db;
  }

  Future<Database> _openDatabase() async {
    print('open deck db');
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'lor-deck.db');

    // await databaseFactoryIo.deleteDatabase(path); //wipe db
    return await databaseFactoryIo.openDatabase(path);
  }

  // stores

  final _deckStore = intMapStoreFactory.store('decks');
  final _favStore = StoreRef<String, bool>('favorites');

  // decks

  Future<List<Deck>> decks() async {
    // final finder = Finder(sortOrders: [SortOrder('classId')]);
    final records = await _deckStore.find(await database);
    return records
        .map((record) => Deck.fromMap(MapEntry(record.key, record.value)))
        .toList();
  }

  Future<void> saveDeck(Deck deck) async {
    final db = await database;
    final data = Map<String, dynamic>.fromIterables(
      ['name', 'factions', 'cardCodes', 'manaCost'],
      [deck.name, deck.factions, deck.cardCodes, deck.manaCost],
    );
    await _deckStore.record(deck.id).exists(db)
        ? await _deckStore.record(deck.id).update(db, data)
        : await _deckStore.record(deck.id).add(db, data);
  }

  Future<void> deleteDeck(int id) async {
    if (id == null) return;
    await _deckStore.record(id).delete(await database);
  }

  // favorites

  Future<List<String>> favoritedCards() async {
    final records = await _favStore.find(await database);
    return records.map((record) => record.key).toList();
  }

  Future<void> updateFavoriteCard(String cardCode) async {
    final db = await database;
    final record = _favStore.record(cardCode);
    await record.exists(db)
        ? await record.delete(db)
        : await record.add(db, true);
  }
}
