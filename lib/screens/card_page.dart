import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db_bloc.dart';
import '../helpers/constants.dart';
import '../helpers/theme.dart';
import '../managers/app_manager.dart';
import '../models/card.dart';
import '../ui/card_favorite_toggle.dart';
import '../ui/card_icons_bar.dart';
import '../ui/custom_appbar.dart';

class CardPage extends StatefulWidget {
  final CardModel card;

  const CardPage({Key key, this.card}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  PageController _pageController;
  List<CardModel> _cardList;
  CardModel _selectedCard;

  Widget _buildAssociatedCardsView() {
    return Center(
      child: PageView(
        controller: _pageController,
        children: _cardList.map((card) => Image.asset(card.imagePath)).toList(),
      ),
    );
  }

  Widget _buildFavoriteAction(BuildContext context) {
    final bloc = Provider.of<DbBloc>(context);
    return StreamBuilder<List<String>>(
      initialData: bloc.favoritedCards,
      stream: bloc.$favoritedCards,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return CardFavoriteToggle(
            isFavorite: snapshot.data.contains(widget.card.cardCode),
            onTap: () => bloc.updateFavoriteCard(widget.card.cardCode),
          );
        }
        return Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.6, initialPage: 0);
    _cardList = [widget.card];
    _selectedCard = widget.card;
    _pageController.addListener(() {
      if (_pageController.page.round() is int)
        setState(() {
          _selectedCard = _cardList[_pageController.page.round()];
        });
    });
  }

  @override
  void didChangeDependencies() {
    final _associatedCards = Provider.of<AppManager>(context)
        .associatedCards(widget.card.associatedCardRefs);
    if (_associatedCards.length != 0) {
      _cardList.addAll(
        _associatedCards..sort((a, b) => b.supertype.compareTo(a.supertype)),
      );
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.card.name),
        trailing: _buildFavoriteAction(context),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: _buildAssociatedCardsView(),
            ),
            Expanded(
              flex: 2,
              child:
                  SingleChildScrollView(child: _CardInfo(card: _selectedCard)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _CardInfo extends StatelessWidget {
  final CardModel card;

  const _CardInfo({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppManager>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text('${card.name}', style: Styles.defaultText20),
          SizedBox(height: 10.0),
          CardIconsBar(card: card),
          SizedBox(height: 10.0),
          if (card.keywordRefs.isNotEmpty) ...[
            for (var keyword in app.globals.keywords
                .where((k) => card.keywordRefs.contains(k.nameRef))
                .toList())
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          if (!['Autoplay', 'Fleeting', 'Skill']
                              .contains(keyword.nameRef))
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              baseline: TextBaseline.alphabetic,
                              child: Image.asset(
                                'assets/img/keywords/${keyword.nameRef}.png',
                                height: kIconSize,
                              ),
                            ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            baseline: TextBaseline.alphabetic,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                keyword.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TextSpan(text: keyword.description),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10.0),
          ],
          if (card.description.isNotEmpty)
            Text(card.description.replaceAll('\n', '')),
          if (card.flavor.isNotEmpty) ...[
            Divider(color: Styles.layerColor),
            Text(
              card.flavor,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
