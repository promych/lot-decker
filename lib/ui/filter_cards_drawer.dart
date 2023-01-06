import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/extensions.dart';
import 'package:provider/provider.dart';

import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../models/globals.dart';
import 'faction_image.dart';

class FilterCardsDrawer extends StatelessWidget {
  final FilterBloc filterBloc;

  const FilterCardsDrawer({Key? key, required this.filterBloc}) : super(key: key);

  Widget _buildManaCostFilter(BuildContext context) {
    final manaList = List<Widget>.generate(
      8,
      (i) {
        final entry = MapEntry('cost', i);
        return GestureDetector(
          child: Container(
            child: CircleAvatar(
              backgroundColor: filterBloc.inFilter(entry) ? Styles.lightGrey : Styles.layerColor,
              child: Text(i == 7 ? '7+' : i.toString()),
              radius: 20.0,
            ),
          ),
          onTap: () => filterBloc.updateFilter(entry),
        );
      },
    );
    return Wrap(
      children: [...manaList],
      runSpacing: 20.0,
      spacing: 20.0,
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Column(
      children: [
        Divider(),
        _FilterSection(
          category: 'regions',
          updateBloc: filterBloc.updateFilter,
          hasInFilter: filterBloc.inFilter,
        ),
        Divider(),
        _buildManaCostFilter(context),
        Divider(),
        _FilterSection(
          category: 'types',
          updateBloc: filterBloc.updateFilter,
          hasInFilter: filterBloc.inFilter,
        ),
        Divider(),
        _FilterSection(
          category: 'rarities',
          updateBloc: filterBloc.updateFilter,
          hasInFilter: filterBloc.inFilter,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Styles.scaffoldBackgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder<Map<String, List<dynamic>>>(
              initialData: filterBloc.filter,
              stream: filterBloc.$filter,
              builder: (context, filter) {
                return Column(
                  children: [
                    AppBar(
                      backgroundColor: Styles.scaffoldBackgroundColor,
                      automaticallyImplyLeading: false,
                      actions: (filter.hasData && filter.data?.isNotEmpty == true)
                          ? [
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () => filterBloc.clearFilter(),
                              ),
                            ]
                          : [Container()],
                      title: Text(context.translate('filter')),
                      centerTitle: false,
                      elevation: 0.0,
                    ),
                    _buildFilters(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildSelectionList(List<Widget> list, int elementsPerRow) {
  return List.generate(
    list.length ~/ elementsPerRow + list.length % 2,
    (x) => Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...list.skip(x * 2).take(1).toList()],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...list.skip(x * 2 + 1).take(1).toList()],
          ),
        ),
      ],
    ),
  );
}

class _FilterSection extends StatelessWidget {
  final String category;
  final void Function(MapEntry<String, dynamic>) updateBloc;
  final bool Function(MapEntry<String, dynamic>) hasInFilter;

  const _FilterSection({
    Key? key,
    required this.category,
    required this.updateBloc,
    required this.hasInFilter,
  }) : super(key: key);

  static const _kIconSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppManager>(context);

    var values = [];
    switch (category) {
      case 'regions':
        values = app.globals?.regions.skipWhile((t) => t.abbreviation == 'NE').toList() ?? [];
        break;
      case 'rarities':
        values = app.globals?.rarities.takeWhile((t) => t.nameRef != 'None').toList() ?? [];
        break;
      case 'types':
        values = app.globals?.cardTypes ?? [];
    }
    if (values.isEmpty) return Container();

    final res = values.map((item) {
      if (item is! Referable) return Container();
      final entry = MapEntry(category, item.name);
      return Container(
        margin: const EdgeInsets.all(4.0),
        color: hasInFilter(entry) ? Styles.layerColor : Styles.scaffoldBackgroundColor,
        child: ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          leading: category == 'regions'
              ? FactionImage(abbrName: (item as Region).abbreviation, size: _kIconSize)
              : Image.asset(
                  'assets/img/$category/${item.nameRef}.png',
                  height: _kIconSize,
                ),
          title: Text(
            item.name,
            style: Styles.defaultText16,
          ),
          onTap: () => updateBloc(entry),
        ),
      );
    }).toList();

    return Column(children: _buildSelectionList(res, 2));
  }
}
