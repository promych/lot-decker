import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/theme.dart';
import '../../managers/locale_manager.dart';
import '../simple_page.dart';
import 'locale_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: LocaleManager.of(context).translate('settings'),
      child: DefaultTextStyle(
        style: Styles.defaultText20,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                LocaleSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
