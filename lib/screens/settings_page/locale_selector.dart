import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../managers/app_manager.dart';
import '../../managers/locale_manager.dart';

class LocaleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppManager>(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              LocaleManager.of(context).translate('select language'),
            ),
          ),
        ),
        DropdownButton<String>(
          value: LocaleManager.of(context).locale.languageCode.toUpperCase(),
          items: kAppLocales.keys.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newLocale) {
            app.changeLocale(kAppLocales[newLocale]);
          },
        ),
      ],
    );
  }
}
