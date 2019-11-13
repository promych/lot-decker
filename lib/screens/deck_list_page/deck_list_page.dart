import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db_bloc.dart';
import '../../helpers/theme.dart';
import '../../models/deck.dart';
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Decks'),
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
          padding: const EdgeInsets.all(10.0),
          sliver: _DeckList(
            onEdit: () => _editDeck(context),
          ),
        )
      ],
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
