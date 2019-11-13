import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../managers/locale_manager.dart';
import '../screens/simple_page.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({@required this.message});

  @override
  Widget build(BuildContext context) {
    final locale = LocaleManager.of(context);
    return SimplePage(
      title: locale.translate('appName'),
      child: Center(
        child: Text(
          message.isEmpty ? locale.translate('default error') : message,
          style: Styles.defaultText20,
        ),
      ),
    );
  }
}
