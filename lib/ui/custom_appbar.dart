import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? trailing;

  CustomAppBar({this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Styles.layerColor,
      centerTitle: true,
      title: title ?? null,
      actions: trailing != null
          ? [
              trailing!,
              SizedBox(width: 10.0),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
