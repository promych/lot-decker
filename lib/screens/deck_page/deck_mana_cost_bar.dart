import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/mana_cost_bar.dart';
import 'deck_page_bloc.dart';

class DeckPageManaCostBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editorBloc = Provider.of<DeckPageBloc>(context);

    return StreamBuilder<Map<String, int>>(
      stream: editorBloc.$manaCost,
      builder: (context, manaCost) {
        return StreamBuilder<int>(
          stream: editorBloc.$selectedManaCostBar,
          builder: (context, selectedBar) {
            return ManaCostChart(
              selectedManaCostBar: selectedBar.data,
              manaCost: manaCost.data,
              onTapManaCostBar:
                  editorBloc.isEditing ? editorBloc.selectManaCostBar : null,
            );
          },
        );
      },
    );
  }
}
