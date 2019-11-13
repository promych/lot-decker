import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class FakeCardImg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 100.0,
      decoration: BoxDecoration(
        color: Styles.layerColor,
        boxShadow: [BoxShadow(color: Styles.lightGrey)],
        border: Border.all(color: Styles.scaffoldBackgroundColor, width: 5.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
    );
  }
}
