import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../managers/locale_manager.dart';

class SearchField extends StatelessWidget {
  final Function onChanged;
  final bool withFilter;

  const SearchField({
    Key key,
    @required this.onChanged,
    this.withFilter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CupertinoTextField(
            onChanged: onChanged,
            placeholder: LocaleManager.of(context).translate('search'),
            padding: const EdgeInsets.all(8.0),
            placeholderStyle: TextStyle(color: Styles.lightGrey),
            decoration: BoxDecoration(
              color: Styles.layerColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.search,
                color: Styles.lightGrey,
              ),
            ),
          ),
        ),
        if (withFilter)
          IconButton(
            icon: Icon(Icons.filter_list),
            alignment: Alignment.centerRight,
            onPressed: Scaffold.of(context).openEndDrawer,
          )
      ],
    );
  }
}
