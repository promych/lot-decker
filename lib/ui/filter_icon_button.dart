import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../managers/app_manager.dart';

class FilterIconButton extends StatelessWidget {
  final FilterBloc bloc;

  const FilterIconButton({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, List<dynamic>>>(
      stream: bloc.$filter,
      initialData: bloc.filter,
      builder: (_, snapshot) {
        return IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.filter_list,
            color: snapshot.data?.isEmpty == true ? Colors.white : Styles.cyanColor,
          ),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        );
      },
    );
  }
}
