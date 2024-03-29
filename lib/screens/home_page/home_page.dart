import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/extensions.dart';
import 'package:provider/provider.dart';

import '../../data/db_bloc.dart';
import '../../helpers/theme.dart';
import '../../managers/app_manager.dart';
import '../../ui/filter_cards_drawer.dart';
import '../card_list_page.dart';
import '../deck_list_page/deck_list_page.dart';
import '../deck_page/deck_page.dart';
import '../favorites_page.dart';
import '../settings_page/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageStorageBucket _bucket;

  Future<void> _editDeck(BuildContext context) async {
    final deckPage = await DeckPage.create(context, {});
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => deckPage,
    ));
  }

  Widget _bottomNavigationBar(int selectedIndex) {
    return BottomNavigationBar(
      onTap: (int index) => setState(() => _selectedIndex = index),
      currentIndex: selectedIndex,
      selectedItemColor: Styles.cyanColor,
      unselectedItemColor: Colors.blueGrey,
      showUnselectedLabels: true,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: context.translate('decks'),
          backgroundColor: Styles.layerColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_module),
          label: context.translate('cards'),
          backgroundColor: Styles.layerColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: context.translate('favorites'),
          backgroundColor: Styles.layerColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: context.translate('settings'),
          backgroundColor: Styles.layerColor,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _bucket = PageStorageBucket();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DeckListPage(
        key: PageStorageKey('decks'),
        onTap: () => _editDeck(context),
      ),
      CardListPage(key: PageStorageKey('cards')),
      FavoritesPage(key: PageStorageKey('favorites')),
      SettingsPage(key: PageStorageKey('settings')),
    ];

    return Scaffold(
      endDrawer: _selectedIndex == 1
          ? FilterCardsDrawer(
              key: ValueKey('app-filter-drawer'),
              filterBloc: Provider.of<AppManager>(context, listen: false),
            )
          : null,
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: _bucket,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Styles.cyanColor,
              onPressed: () {
                Provider.of<DbBloc>(context, listen: false).selectedDeckId = null;
                _editDeck(context);
              },
            )
          : null,
    );
  }
}
