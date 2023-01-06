import 'package:flutter/material.dart';
import 'package:lor_builder/ui/filter_icon_button.dart';
import 'package:provider/provider.dart';

import '../data/db_bloc.dart';
import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../models/card.dart';
import '../ui/card_tile_favorite.dart';
import '../ui/search_field.dart';

class CardListPage extends StatelessWidget {
  const CardListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AppManager>(context);

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: SearchField(
              onChanged: bloc.updateSearch,
              textStream: bloc.$searchText,
            ),
            backgroundColor: Styles.layerColor,
            automaticallyImplyLeading: false,
            centerTitle: false,
            forceElevated: true,
            floating: true,
            actions: [FilterIconButton(bloc: bloc)],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            sliver: _CardList(),
          )
        ],
      ),
    );
  }
}

// class _SearchBar extends StatelessWidget {
//   final Function onChanged;

//   const _SearchBar({Key? key, required this.onChanged}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoTextField(
//       onChanged: onChanged,
//       style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
//       placeholder: context.translate('search'),
//       padding: const EdgeInsets.all(8.0),
//       placeholderStyle: TextStyle(color: Styles.lightGrey),
//       decoration: BoxDecoration(
//         color: Styles.scaffoldBackgroundColor,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//     );
//   }
// }

class _CardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final filterBloc = Provider.of<AppManager>(context);
    final favBloc = Provider.of<DbBloc>(context);

    return StreamBuilder<List<String>>(
      stream: favBloc.$favoritedCards,
      initialData: favBloc.favoritedCards,
      builder: (context, favoritedCards) {
        return StreamBuilder<List<CardModel>>(
          stream: filterBloc.$filteredCards,
          initialData: filterBloc.filteredCards,
          builder: (context, filteredCards) {
            return (!filteredCards.hasData)
                ? const SizedBox.shrink()
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        final card = filteredCards.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: CardTileFavorite(
                            card: card,
                            isFavorite: favoritedCards.data!.contains(card.cardCode),
                          ),
                        );
                      },
                      childCount: filteredCards.data!.length,
                    ),
                  );
          },
        );
      },
    );
  }
}
