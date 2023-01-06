import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/extensions.dart';

import '../helpers/theme.dart';

class SearchField extends StatelessWidget {
  final Function(String)? onChanged;
  final Stream<String> textStream;
  final Color backgroundColor;

  const SearchField({
    Key? key,
    required this.onChanged,
    required this.textStream,
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
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                  placeholder: context.translate('search'),
                  padding: const EdgeInsets.all(8.0),
                  placeholderStyle: TextStyle(color: Styles.lightGrey),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffix: snapshot.data?.isEmpty == true
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.search, color: Styles.lightGrey),
                        )
                      : null,
                  clearButtonMode: OverlayVisibilityMode.always,
                ),
              ),
            ],
          );
        });
  }
}
