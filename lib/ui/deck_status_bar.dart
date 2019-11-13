import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../models/card.dart';
import 'faction_image.dart';

const _iconSize = 32.0;

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
    if (cardsInDeck == null || cardsInDeck.isEmpty) return Container();
    final globals = Provider.of<AppManager>(context).globals;

    // int spellsNum = 0;
    // int championsNum = 0;
    // int unitsNum = 0;
    // int total = 0;
    // Set<String> factions = {};

    final unitLocaleName = globals.cardTypes
        .singleWhere((t) => t.nameRef == 'Unit', orElse: () => null)
        ?.name;

    final spellsNum =
        cardsInDeck.where((card) => card.spellSpeedRef.isNotEmpty).length;
    final championsNum =
        cardsInDeck.where((card) => card.supertype.isNotEmpty).length;
    final unitsNum =
        cardsInDeck.where((card) => card.cardType == unitLocaleName).length;
    final factions =
        cardsInDeck.map((card) => card.cardCode.substring(2, 4)).toSet();
    final total = cardsInDeck.length;

    int _cardsByFaction(String fAbbr) {
      final nameRef = globals.regions
          .singleWhere((f) => f.abbreviation == fAbbr, orElse: () => null)
          ?.nameRef;
      return cardsInDeck.where((card) => card.regionRef == nameRef).length;
    }

    return Row(
      children: [
        _IconBadge(
          child:
              Image.asset('assets/img/types/Champion.png', height: _iconSize),
          cardNum: championsNum,
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
