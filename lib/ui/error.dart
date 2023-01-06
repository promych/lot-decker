import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/constants.dart';

import '../helpers/theme.dart';
import '../managers/locale_manager.dart';
import '../screens/simple_page.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final locale = LocaleManager.of(context);
    final err = locale?.translate('default error');
    return SimplePage(
      title: locale?.translate('appName') ?? appName,
      child: Center(
        child: Text(
          message.isEmpty ? (err ?? 'Error') : message,
          style: Styles.defaultText20,
        ),
      ),
    );
  }
}
