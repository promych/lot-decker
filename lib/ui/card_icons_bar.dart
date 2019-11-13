import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../managers/app_manager.dart';
import '../models/card.dart';
import 'faction_image.dart';

class CardIconsBar extends StatelessWidget {
  final CardModel card;

  const CardIconsBar({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppManager>(context);
    final region = app.regionByName(card.regionRef);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FactionImage(size: kIconSize, abbrName: region.abbreviation),
            // Text(card.region),
          ],
        ),
        SizedBox(width: 10.0),
        if (card.rarityRef != 'None')
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/img/rarities/${card.rarityRef}.png',
                height: kIconSize,
              ),
              // Text(card.rarity),
            ],
          ),
        SizedBox(width: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/types/${app.globals.cardTypeRef(card.cardType)}.png',
              height: kIconSize,
            ),
            // Text(card.cardType),
          ],
        )
      ],
    );
  }
}
