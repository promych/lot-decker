import 'package:flutter/cupertino.dart';

class SliverContainer extends StatelessWidget {
  final Widget child;

  const SliverContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: Center(child: child),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
