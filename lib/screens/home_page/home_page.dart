import 'package:flutter/material.dart';

import '../../helpers/theme.dart';
import '../../ui/filter_cards_drawer.dart';
import '../card_list_page.dart';
import '../deck_list_page/deck_list_page.dart';
import '../favorites_page.dart';
import '../settings_page/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageStorageBucket _bucket;

  Widget _bottomNavigationBar(int selectedIndex) {
    return BottomNavigationBar(
      onTap: (int index) => setState(() => _selectedIndex = index),
      currentIndex: selectedIndex,
      selectedItemColor: Styles.cyanColor,
      unselectedItemColor: Colors.blueGrey,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          title: Text('Decks'),
          backgroundColor: Styles.layerColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_module),
          title: Text('Cards'),
          backgroundColor: Styles.layerColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text('Favorites'),
          backgroundColor: Styles.layerColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
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
      DeckListPage(key: PageStorageKey('decks')),
      CardListPage(key: PageStorageKey('cards')),
      FavoritesPage(key: PageStorageKey('favorites')),
      SettingsPage(key: PageStorageKey('settings')),
    ];

    return Scaffold(
      endDrawer: _selectedIndex == 1 ? FilterCardsDrawer() : null,
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: _bucket,
      ),
    );
  }
}
