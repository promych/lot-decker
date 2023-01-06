import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/constants.dart';

import '../managers/locale_manager.dart';
import '../screens/simple_page.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      showAppBar: false,
      title: LocaleManager.of(context)?.translate('appName') ?? appName,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
