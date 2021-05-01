import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lor_deck_coder/lor_deck_coder.dart';
import 'package:provider/provider.dart';

import '../../data/db_bloc.dart';
import '../../helpers/theme.dart';
import '../../managers/locale_manager.dart';
import '../../models/deck.dart';
import '../../ui/fake_card_img.dart';
import '../../ui/sliver_container.dart';
import '../deck_page/deck_page.dart';
import 'deck_list_tile.dart';

class DeckListPage extends StatefulWidget {
  final Function onTap;

  const DeckListPage({Key key, @required this.onTap}) : super(key: key);

  @override
  _DeckListPageState createState() => _DeckListPageState();
}

class _DeckListPageState extends State<DeckListPage> {
  TextEditingController _codeController;

  Future<void> _codeToDeck(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Styles.layerColor,
          title: Text(LocaleManager.of(context).translate('paste code')),
          content: TextField(
            controller: _codeController,
          ),
          actions: [
            TextButton(
              child: Text(LocaleManager.of(context).translate('cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                try {
                  if (_codeController.text.isEmpty) return;
                  final cardsInDeck =
                      await LorDeckCoder.decodeToDeck(_codeController.text);
                  final deckPage = await DeckPage.create(
                      context, Map<String, int>.from(cardsInDeck));
                  Navigator.of(context).pop();
                  _codeController.clear();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => deckPage,
                  ));
                } on PlatformException catch (e) {
                  print(e.message);
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
              TextButton.icon(
                icon: Icon(Icons.library_add),
                label: Text('Code'),
                onPressed: () => _codeToDeck(context),
              )
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            sliver: _DeckList(onEdit: widget.onTap),
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
      stream: bloc.decks$,
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
        SizedBox(height: 50.0),
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
      ],
    );
  }
}
