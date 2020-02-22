import 'package:flutter/material.dart';
import 'package:lor_builder/ui/filter_icon_button.dart';
import 'package:provider/provider.dart';

import '../../helpers/theme.dart';
import '../../models/card.dart';
import '../../ui/card_tile.dart';
import '../../ui/same_cards_num_in_deck_chip.dart';
import '../../ui/search_field.dart';
import 'deck_page_bloc.dart';

class DeckPageCardsSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DeckPageBloc>(context);

    return Expanded(
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: SearchField(
                onChanged: bloc.updateSearch,
                textStream: bloc.$searchText,
                backgroundColor: Styles.layerColor,
              ),
              floating: true,
              backgroundColor: Styles.scaffoldBackgroundColor,
              automaticallyImplyLeading: false,
              centerTitle: false,
              actions: [FilterIconButton(bloc: bloc)],
            ),
            StreamBuilder<List<CardModel>>(
              stream: bloc.$filteredCards,
              initialData: bloc.filterCards(bloc.cards),
              builder: (context, snapshot) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        final card = snapshot.data[index];
                        return CardTile(
                          card: card,
                          selectCard: bloc.selectCard,
                          actions: GestureDetector(
                            child: SameCardsInDeck(card: card),
                            onTap: () => bloc.unselectCard(card),
                          ),
                        );
                      },
                      childCount: snapshot.data.length,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
