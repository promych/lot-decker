import 'package:flutter/material.dart';

import '../../helpers/theme.dart';
import '../../managers/locale_manager.dart';
import 'locale_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(LocaleManager.of(context).translate('settings')),
        backgroundColor: Styles.layerColor,
      ),
      body: DefaultTextStyle(
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
