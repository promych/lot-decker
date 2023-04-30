import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/constants.dart';
import 'package:lor_builder/helpers/extensions.dart';
import 'package:lor_builder/models/champs.dart';
import 'package:lor_builder/models/globals.dart';
import 'package:provider/provider.dart';

import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../models/card.dart';
import 'faction_image.dart';

const _iconSize = 32.0;

enum StatusBarMode { Rarities, Types }

class DeckStatusBar extends StatefulWidget {
  final List<CardModel> cardsInDeck;
  final bool withFactions;
  final bool isEditing;

  const DeckStatusBar({
    Key? key,
    required this.cardsInDeck,
    this.withFactions = false,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _DeckStatusBarState createState() => _DeckStatusBarState();
}

class _DeckStatusBarState extends State<DeckStatusBar> {
  Locale? locale;
  Globals? globals;
  var statusBarMode = StatusBarMode.Types;

  int spellsNum = 0;
  int unitsNum = 0;
  int landmarksNum = 0;
  int equipNum = 0;
  int total = 0;
  Set<String> factions = {};

  @override
  void initState() {
    super.initState();
    globals = context.read<AppManager>().globals;
    locale = context.read<AppManager>().locale;
  }

  @override
  Widget build(BuildContext context) {
    final unitLocaleName = globals?.cardTypes.firstWhereOrNull((t) => t.nameRef == 'Unit')?.name;
    final landmarkLocaleName = globals?.cardTypes.firstWhereOrNull((t) => t.nameRef == 'Landmark')?.name;
    final equipmentLocaleName = globals?.cardTypes.firstWhereOrNull((t) => t.nameRef == 'Equipment')?.name;

    int _cardsByFaction(String fAbbr) {
      final nameRef = globals?.regions.firstWhereOrNull((f) => f.abbreviation == fAbbr)?.nameRef;
      return widget.cardsInDeck.where((card) => card.regionRefs.contains(nameRef)).length;
    }

    if (widget.cardsInDeck.isNotEmpty) {
      spellsNum = widget.cardsInDeck.where((card) => card.spellSpeedRef.isNotEmpty).length;
      unitsNum = widget.cardsInDeck.where((card) => card.cardType == unitLocaleName).length;
      landmarksNum = widget.cardsInDeck.where((card) => card.cardType == landmarkLocaleName).length;
      equipNum = widget.cardsInDeck.where((card) => card.cardType == equipmentLocaleName).length;
      factions = widget.cardsInDeck.map((card) => card.cardCode.substring(2, 4)).toSet();
      total = widget.cardsInDeck.length;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: widget.isEditing ? 8.0 : 2.0),
      child: GestureDetector(
        child: Row(
          children: [
            if (widget.withFactions)
              for (var f in factions)
                _IconBadge(
                  child: FactionImage(abbrName: f, size: _iconSize),
                  cardNum: _cardsByFaction(f),
                ),
            statusBarMode == StatusBarMode.Types ? _buildStatsByType() : _buildStatsByRarity(),
            // Spacer(),
            // CircularPercentIndicator(
            //   radius: 36,
            //   animation: false,
            //   lineWidth: 2.0,
            //   percent: total / 40,
            //   center: Text(total.toString()),
            //   circularStrokeCap: CircularStrokeCap.butt,
            //   backgroundColor: Styles.cyanColor.withAlpha(100),
            //   progressColor: Styles.cyanColor,
            // ),
          ],
        ),
        onTap: _changeStatusBarMode,
      ),
    );
  }

  Widget _buildChampAvatar(CardModel card) {
    final nameRU = kChampionsNamesRU[card.name];
    return _IconBadge(
      child: CircleAvatar(
        radius: _iconSize / 2,
        backgroundImage: (locale == kAppLocales['RU'] && nameRU != null)
            ? AssetImage('assets/img/champions/${nameRU.replaceAll(' ', '').replaceAll("'", '')}.webp')
            : AssetImage('assets/img/champions/${card.name.replaceAll(' ', '').replaceAll("'", '')}.webp'),
      ),
      cardNum: widget.cardsInDeck.where((c) => c.name == card.name).length,
    );
  }

  Widget _buildStatsByType() {
    return Row(children: [
      for (final card in widget.cardsInDeck.where((card) => card.supertype.isNotEmpty).toSet()) _buildChampAvatar(card),
      _IconBadge(
        child: Image.asset('assets/img/types/Unit.png', height: _iconSize),
        cardNum: unitsNum,
      ),
      _IconBadge(
        child: Image.asset('assets/img/types/Spell.png', height: _iconSize),
        cardNum: spellsNum,
      ),
      _IconBadge(
        child: Image.asset('assets/img/types/Landmark.png', height: _iconSize),
        cardNum: landmarksNum,
      ),
      _IconBadge(
        child: Image.asset('assets/img/types/Equipment.png', height: _iconSize),
        cardNum: equipNum,
      ),
    ]);
  }

  Widget _buildStatsByRarity() {
    return globals != null
        ? Row(children: [
            for (final rarity in globals!.rarities.takeWhile((t) => t.nameRef != 'None').toSet())
              _IconBadge(
                child: CircleAvatar(
                  radius: _iconSize / 2,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/img/rarities/${rarity.nameRef}.png'),
                ),
                cardNum: widget.cardsInDeck.where((c) => c.rarityRef == rarity.nameRef).length,
              ),
          ])
        : const SizedBox.shrink();
  }

  void _changeStatusBarMode() {
    (statusBarMode == StatusBarMode.Types)
        ? statusBarMode = StatusBarMode.Rarities
        : statusBarMode = StatusBarMode.Types;
    setState(() {});
  }
}

class _IconBadge extends StatelessWidget {
  final int cardNum;
  final Widget child;

  const _IconBadge({
    Key? key,
    required this.cardNum,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: badges.Badge(
        child: child,
        badgeContent: Text(cardNum.toString()),
        position: badges.BadgePosition.bottomEnd(),
        badgeStyle: badges.BadgeStyle(badgeColor: Styles.lightGrey),
        badgeAnimation: badges.BadgeAnimation.fade(),
      ),
    );
  }
}
