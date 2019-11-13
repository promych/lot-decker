import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../models/card.dart';
import '../screens/card_page.dart';
import 'card_icons_bar.dart';

class CardTile extends StatelessWidget {
  final CardModel card;
  final Function selectCard;
  final Widget actions;

  const CardTile({
    Key key,
    @required this.card,
    @required this.selectCard,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Styles.layerColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 150.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Card(child: Image.asset(card.imagePath), elevation: 4.0),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => CardPage(card: card),
                )),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => selectCard(card),
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    card.name,
                                    style: Styles.defaultText20,
                                  ),
                                ),
                                if (actions != null) actions,
                              ],
                            ),
                            if (card.description.isNotEmpty)
                              Text(card.description),
                          ],
                        ),
                        Expanded(
                            child: Center(child: CardIconsBar(card: card))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
