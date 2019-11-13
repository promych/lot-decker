import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class CardFavoriteToggle extends StatelessWidget {
  final bool isFavorite;
  final Function onTap;

  const CardFavoriteToggle({
    Key key,
    this.isFavorite = false,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: isFavorite
          ? Icon(
              Icons.star,
              color: Styles.cyanColor,
            )
          : Icon(
              Icons.star_border,
              color: Styles.cyanColor,
            ),
      onTap: onTap,
    );
  }
}
