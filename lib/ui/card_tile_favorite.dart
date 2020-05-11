import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db_bloc.dart';
import '../models/card.dart';
import '../screens/card_page.dart';
import 'card_favorite_toggle.dart';
import 'card_tile.dart';

class CardTileFavorite extends StatelessWidget {
  final CardModel card;
  final bool isFavorite;

  const CardTileFavorite({
    Key key,
    @required this.card,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTile(
      card: card,
      selectCard: (card) => Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => CardPage(card: card),
        ),
      ),
      actions: CardFavoriteToggle(
        isFavorite: isFavorite,
        onTap: () =>
            Provider.of<DbBloc>(context, listen: false).updateFavoriteCard(card.cardCode),
      ),
    );
  }
}
