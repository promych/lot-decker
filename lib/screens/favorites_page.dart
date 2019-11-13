import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db_bloc.dart';
import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../managers/locale_manager.dart';
import '../ui/card_tile_favorite.dart';
import '../ui/fake_card_img.dart';
import '../ui/sliver_container.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(LocaleManager.of(context).translate('favorites')),
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
          return SliverContainer(
            child: _EmptyFavContainer(),
          );
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

class _EmptyFavContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: [
            Transform.rotate(
              angle: pi / 12,
              origin: Offset(330.0, 20.0),
              child: FakeCardImg(),
            ),
            Transform.rotate(
              angle: -pi / 12,
              child: FakeCardImg(),
              origin: Offset(-400.0, 20.0),
            ),
          ],
        ),
        Text(
          LocaleManager.of(context).translate('no fav'),
          style: Styles.defaultText20,
          textAlign: TextAlign.center,
        ),
        Text(
          LocaleManager.of(context).translate('no fav hint'),
          style: Styles.defaultText16,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
