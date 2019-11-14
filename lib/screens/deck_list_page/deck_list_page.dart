import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db_bloc.dart';
import '../../helpers/theme.dart';
import '../../managers/locale_manager.dart';
import '../../models/deck.dart';
import '../../ui/fake_card_img.dart';
import '../../ui/sliver_container.dart';
import '../deck_page/deck_page.dart';
import 'deck_list_tile.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key key}) : super(key: key);

  Future<void> _editDeck(BuildContext context) async {
    final deckPage = await DeckPage.create(context);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => deckPage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(LocaleManager.of(context).translate('decks')),
            backgroundColor: Styles.layerColor,
            forceElevated: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Provider.of<DbBloc>(context).selectedDeckId = null;
                  _editDeck(context);
                },
              )
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            sliver: _DeckList(
              onEdit: () => _editDeck(context),
            ),
          )
        ],
      ),
    );
  }
}

class _DeckList extends StatelessWidget {
  final Function onEdit;

  const _DeckList({Key key, @required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DbBloc>(context);

    return StreamBuilder(
      stream: bloc.$decksStream,
      initialData: <Deck>[],
      builder: (context, AsyncSnapshot<List<Deck>> snapshot) {
        if (snapshot.hasError) {
          return SliverContainer(child: Text('${snapshot.error}'));
        }
        if (snapshot.data.isEmpty) {
          return SliverContainer(child: _EmptyDecksContainer());
        }
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((_, i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: GestureDetector(
                  child: Card(
                    elevation: 4.0,
                    color: Styles.layerColor,
                    child: DeckListTile(deck: snapshot.data[i]),
                  ),
                  onTap: () {
                    bloc.selectedDeckId = snapshot.data[i].id;
                    onEdit();
                  },
                ),
              );
            }, childCount: snapshot.data.length),
          );
        }
        return SliverContainer(child: Text('No decks'));
      },
    );
  }
}

class _EmptyDecksContainer extends StatelessWidget {
  final Matrix4 _tr = Matrix4.identity()
    ..setEntry(3, 2, 0.001)
    ..rotateX(-pi / 2.4)
    ..rotateZ(-pi / 6.9)
    ..rotateY(pi / 19);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Transform(
              origin: Offset(10.0, 50.0),
              transform: _tr,
              child: FakeCardImg(),
            ),
            Transform(
              origin: Offset(-10.0, 45.0),
              transform: _tr,
              child: FakeCardImg(),
            ),
            Transform(
              origin: Offset(-30.0, 40.0),
              transform: _tr,
              child: FakeCardImg(),
            ),
            Transform(
              origin: Offset(-50.0, 35.0),
              transform: _tr,
              child: FakeCardImg(),
            ),
          ],
        ),
        Text(
          LocaleManager.of(context).translate('no decks'),
          style: Styles.defaultText20,
          textAlign: TextAlign.center,
        ),
        Text(
          LocaleManager.of(context).translate('no decks hint'),
          style: Styles.defaultText16,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
