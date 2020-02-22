import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/theme.dart';
import '../models/card.dart';
import '../screens/deck_page/deck_page_bloc.dart';

class SameCardsInDeck extends StatelessWidget {
  final CardModel card;

  const SameCardsInDeck({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sameCardsNum =
        Provider.of<DeckPageBloc>(context).sameCardsInDeckNum(card);

    return Chip(
      label: Text('x${sameCardsNum.toString()}'),
      backgroundColor: sameCardsNum > 0 ? Styles.cyanColor : Styles.lightGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }
}
