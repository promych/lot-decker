import 'package:flutter/material.dart';
import 'package:lor_builder/helpers/constants.dart';

import '../helpers/theme.dart';
import '../ui/custom_appbar.dart';

class SimplePage extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showAppBar;

  const SimplePage({
    this.title = appName,
    required this.child,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget _title = Text(title, style: Styles.defaultText);

    return Scaffold(
      appBar: showAppBar
          ? CustomAppBar(title: _title)
          // ? AppBar(
          //     centerTitle: true,
          //     backgroundColor: Styles.layerColor,
          //     title: _title,
          //   )
          : null,
      body: child,
    );
  }
}
