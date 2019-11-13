import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/card.dart';
import '../../ui/card_tile.dart';
import '../../ui/same_cards_num_in_deck_chip.dart';
import 'deck_page_bloc.dart';

class DeckPageCardsSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DeckPageBloc>(context);

    return Expanded(
      child: StreamBuilder<List<CardModel>>(
        stream: bloc.$filteredCards,
        initialData: bloc.filterCards(bloc.cards),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              final card = snapshot.data[index];
              return CardTile(
                card: card,
                selectCard: bloc.selectCard,
                actions: GestureDetector(
                  child: SameCardsInDeck(card: card),
                  onTap: () => bloc.unselectCard(card),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
