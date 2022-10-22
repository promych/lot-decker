import 'dart:math' show max;

import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class ManaCostChart extends StatelessWidget {
  final Map<String, int> manaCost;
  final int selectedManaCostBar;
  final bool showNumbers;
  final Function onTapManaCostBar;

  const ManaCostChart({
    Key key,
    @required this.manaCost,
    this.selectedManaCostBar,
    this.showNumbers = true,
    this.onTapManaCostBar,
  }) : super(key: key);

  Widget _buildManaCostChart() {
    if (manaCost == null) return Container();
    final costs = <Widget>[];
    manaCost.forEach(
      (k, v) => costs
        ..add(
          onTapManaCostBar == null
              ? _singleManaCostBar(int.tryParse(k), v)
              : GestureDetector(
                  child: _singleManaCostBar(int.tryParse(k), v),
                  onTap: () => onTapManaCostBar(int.tryParse(k)),
                ),
        ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: costs,
    );
  }

  int get _maxManaCost {
    final maxCost = manaCost.values.reduce(max);
    return maxCost != 0 ? maxCost : 1;
  }

  Widget _singleManaCostBar(int cost, int selectedCardsByManaCost) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 80.0,
              width: 20.0,
              color: selectedManaCostBar == cost ? Styles.lightGrey : Styles.layerColor,
            ),
            Column(
              children: <Widget>[
                if (showNumbers) selectedCardsByManaCost == 0 ? Container() : Text(selectedCardsByManaCost.toString()),
                Container(
                  height: 60.0 * selectedCardsByManaCost / _maxManaCost,
                  width: 20.0,
                  color: Styles.cyanColor,
                ),
              ],
            )
          ],
        ),
        if (showNumbers) SizedBox(height: 10.0),
        if (showNumbers) Text('$cost${cost == 7 ? '+' : ''}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return showNumbers
        ? _buildManaCostChart()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Styles.cyanColor, width: 1.0)),
            ),
            child: _buildManaCostChart(),
          );
  }
}
