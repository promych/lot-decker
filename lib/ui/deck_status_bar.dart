import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../models/card.dart';
import 'faction_image.dart';

const _iconSize = 28.0;

class DeckStatusBar extends StatelessWidget {
  final List<CardModel> cardsInDeck;
  final bool withFactions;

  const DeckStatusBar({
    Key key,
    @required this.cardsInDeck,
    this.withFactions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globals = Provider.of<AppManager>(context).globals;

    int spellsNum = 0;
    // int championsNum = 0;
    int unitsNum = 0;
    int total = 0;
    Set<String> factions = {};

    final unitLocaleName = globals.cardTypes
        .singleWhere((t) => t.nameRef == 'Unit', orElse: () => null)
        ?.name;

    if (cardsInDeck != null && cardsInDeck.isNotEmpty) {
      spellsNum =
          cardsInDeck.where((card) => card.spellSpeedRef.isNotEmpty).length;
      // championsNum =
      //     cardsInDeck.where((card) => card.supertype.isNotEmpty).length;
      unitsNum =
          cardsInDeck.where((card) => card.cardType == unitLocaleName).length;
      factions =
          cardsInDeck.map((card) => card.cardCode.substring(2, 4)).toSet();
      total = cardsInDeck.length;
    }

    int _cardsByFaction(String fAbbr) {
      final nameRef = globals.regions
          .singleWhere((f) => f.abbreviation == fAbbr, orElse: () => null)
          ?.nameRef;
      return cardsInDeck.where((card) => card.regionRef == nameRef).length;
    }

    return Row(
      children: [
        // _IconBadge(
        //   child:
        //       Image.asset('assets/img/types/Champion.png', height: _iconSize),
        //   cardNum: championsNum,
        // ),
        for (var card
            in cardsInDeck.where((card) => card.supertype.isNotEmpty).toSet())
          _IconBadge(
            child: CircleAvatar(
              radius: _iconSize / 2,
              backgroundImage:
                  AssetImage('assets/img/champions/${card.name.replaceAll(' ', '')}.webp'),
            ),
            cardNum: cardsInDeck.where((c) => c.name == card.name).length,
          ),
        _IconBadge(
          child: Image.asset('assets/img/types/Unit.png', height: _iconSize),
          cardNum: unitsNum,
        ),
        _IconBadge(
          child: Image.asset('assets/img/types/Spell.png', height: _iconSize),
          cardNum: spellsNum,
        ),
        if (withFactions)
          for (var f in factions)
            _IconBadge(
              child: FactionImage(abbrName: f, size: _iconSize),
              cardNum: _cardsByFaction(f),
            ),
        Spacer(),
        Text('$total/40', style: Styles.defaultText16),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  final int cardNum;
  final Widget child;

  const _IconBadge({
    Key key,
    @required this.cardNum,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Badge(
        child: child,
        badgeContent: Text(cardNum.toString()),
        position: BadgePosition.bottomRight(),
        badgeColor: Styles.lightGrey,
        animationType: BadgeAnimationType.fade,
      ),
    );
  }
}
