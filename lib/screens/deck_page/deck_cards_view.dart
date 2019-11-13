import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/theme.dart';
import '../../ui/same_cards_num_in_deck_chip.dart';
import 'deck_page_bloc.dart';

class DeckViewCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cards = Provider.of<DeckPageBloc>(context)
        .selectedCards
        .toSet()
        .toList()
          ..sort((a, b) => a.cost.compareTo(b.cost));

    return Expanded(
      child: ListView.separated(
        itemCount: cards.length,
        itemBuilder: (_, index) {
          final card = cards[index];
          return ListTile(
            title: Text(card.name),
            leading: Chip(
              backgroundColor: Styles.cyanColor,
              label: Text(
                card.cost.toString(),
                style: Styles.defaultText,
              ),
            ),
            trailing: SameCardsInDeck(card: card),
          );
        },
        separatorBuilder: (_, index) => Container(
          height: 1.0,
          color: Styles.layerColor,
        ),
      ),
    );
  }
}
