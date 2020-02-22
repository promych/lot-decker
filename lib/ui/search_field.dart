import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../managers/locale_manager.dart';

class SearchField extends StatelessWidget {
  final Function onChanged;
  final Stream<String> textStream;
  final Color backgroundColor;

  const SearchField({
    Key key,
    @required this.onChanged,
    @required this.textStream,
    this.backgroundColor = Styles.scaffoldBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: textStream,
        initialData: '',
        builder: (_, snapshot) {
          return Row(
            children: <Widget>[
              Expanded(
                child: CupertinoTextField(
                  onChanged: onChanged,
                  cursorColor: Styles.cyanColor,
                  style: TextStyle(
                      color: Colors.white, decoration: TextDecoration.none),
                  placeholder: LocaleManager.of(context).translate('search'),
                  padding: const EdgeInsets.all(8.0),
                  placeholderStyle: TextStyle(color: Styles.lightGrey),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffix: snapshot.data.isEmpty ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.search, color: Styles.lightGrey),
                  ) : null,
                  clearButtonMode: OverlayVisibilityMode.always,
                ),
              ),
            ],
          );
        });
  }
}
