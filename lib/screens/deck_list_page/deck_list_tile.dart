import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/theme.dart';
import '../../managers/app_manager.dart';
import '../../models/card.dart';
import '../../models/deck.dart';
import '../../ui/deck_status_bar.dart';
import '../../ui/faction_image.dart';
import '../../ui/mana_cost_bar.dart';

class DeckListTile extends StatelessWidget {
  final Deck deck;

  const DeckListTile({Key key, @required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardsStorage = Provider.of<AppManager>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  deck.name,
                  style: Styles.defaultText20,
                ),
              ),
              for (var fName in deck.factions)
                Container(height: 40.0, child: FactionImage(abbrName: fName)),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ManaCostChart(
                manaCost: deck.manaCost,
                showNumbers: false,
              ),
            ),
          ],
        ),
        StreamBuilder<List<CardModel>>(
            initialData: cardsStorage.cards,
            stream: cardsStorage.$cards,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: snapshot.hasData && snapshot.data.isNotEmpty
                    ? DeckStatusBar(
                        cardsInDeck: deck.cardCodes
                            .map(cardsStorage.cardByCode)
                            .toList(),
                      )
                    : Container(),
              );
            })
      ],
    );
  }
}
