import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../managers/app_manager.dart';

class FactionImage extends StatelessWidget {
  final String abbrName;
  final double? size;

  const FactionImage({Key? key, required this.abbrName, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final region = Provider.of<AppManager>(context).regionByAbbrName(abbrName);
    //final formattedName = kFactions[name].replaceAll(r'&', '').replaceAll(' ', '').toLowerCase();
    return region != null
        ? Image.asset(
            'assets/img/regions/icon-${region.nameRef.toLowerCase()}.png',
            height: size ?? null,
          )
        : Container();
  }
}
