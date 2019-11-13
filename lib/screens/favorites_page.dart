import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db_bloc.dart';
import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../ui/card_tile_favorite.dart';
import '../ui/sliver_container.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Wishlist'),
          forceElevated: true,
          backgroundColor: Styles.layerColor,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: _CardList(),
        )
      ],
    );
  }
}

class _CardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cards = Provider.of<AppManager>(context);
    final favBloc = Provider.of<DbBloc>(context);

    return StreamBuilder<List<String>>(
      stream: favBloc.$favoritedCards,
      initialData: favBloc.favoritedCards,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.isEmpty) {
          return SliverContainer(child: Text('no fav cards'));
        }
        final cardCodes = snapshot.data;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final card = cards.cardByCode(cardCodes[index]);
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: CardTileFavorite(
                  card: card,
                  isFavorite: snapshot.data.contains(card.cardCode),
                ),
              );
            },
            childCount: cardCodes.length,
          ),
        );
      },
    );
  }
}
