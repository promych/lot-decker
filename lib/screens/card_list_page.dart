import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db_bloc.dart';
import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../managers/locale_manager.dart';
import '../models/card.dart';
import '../ui/card_tile_favorite.dart';

class CardListPage extends StatelessWidget {
  const CardListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: _SearchBar(
            onChanged: Provider.of<AppManager>(context).updateSearch,
          ),
          backgroundColor: Styles.layerColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          forceElevated: true,
          floating: true,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            )
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: _CardList(),
        )
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final Function onChanged;

  const _SearchBar({Key key, @required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      onChanged: onChanged,
      placeholder: LocaleManager.of(context).translate('search'),
      padding: const EdgeInsets.all(8.0),
      placeholderStyle: TextStyle(color: Styles.lightGrey),
      decoration: BoxDecoration(
        color: Styles.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final filterBloc = Provider.of<AppManager>(context);
    final favBloc = Provider.of<DbBloc>(context);

    return StreamBuilder<List<String>>(
      stream: favBloc.$favoritedCards,
      initialData: favBloc.favoritedCards,
      builder: (context, favoritedCards) {
        return StreamBuilder<List<CardModel>>(
          stream: filterBloc.$filteredCards,
          initialData: filterBloc.filteredCards,
          builder: (context, filteredCards) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  final card = filteredCards.data[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: CardTileFavorite(
                      card: card,
                      isFavorite: favoritedCards.data.contains(card.cardCode),
                    ),
                  );
                },
                childCount: filteredCards.data.length,
              ),
            );
          },
        );
      },
    );
  }
}
