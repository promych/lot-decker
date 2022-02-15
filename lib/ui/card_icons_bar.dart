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

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (card.regionRefs.isNotEmpty) ..._buildRegions(card.regionRefs, app),
        if (card.rarityRef != 'None')
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/img/rarities/${card.rarityRef}.png',
                height: kIconSize,
              ),
              Text(card.rarity),
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
            Text(card.cardType),
          ],
        )
      ],
    );
  }

  List<Widget> _buildRegions(List<String> regRefs, AppManager app) {
    final result = <Widget>[];
    for (final ref in card.regionRefs) {
      final region = app.regionByName(ref);
      result.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FactionImage(size: kIconSize, abbrName: region.abbreviation),
            Text(region.name),
            SizedBox(width: 10.0),
          ],
        ),
      );
    }
    return result;
  }
}
