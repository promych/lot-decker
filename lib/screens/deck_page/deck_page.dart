import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/db_bloc.dart';
import '../../helpers/theme.dart';
import '../../managers/app_manager.dart';
import '../../managers/locale_manager.dart';
import '../../models/card.dart';
import '../../ui/deck_status_bar.dart';
import '../../ui/filter_cards_drawer.dart';
import 'deck_cards_selection.dart';
import 'deck_cards_view.dart';
import 'deck_mana_cost_bar.dart';
import 'deck_page_bloc.dart';

class DeckPage extends StatefulWidget {
  final DeckPageBloc bloc;

  DeckPage({Key key, @required this.bloc}) : super(key: key);

  static Future<Widget> create(
      BuildContext context, Map<String, int> cardCodes) async {
    final currentDeck =
        await Provider.of<DbBloc>(context, listen: false).currentDeck;

    return Provider<DeckPageBloc>(
      create: (_) => DeckPageBloc(
        cards: Provider.of<AppManager>(context).cardsCollectible,
        deck: currentDeck,
      )..load(cardCodes),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<DeckPageBloc>(
        builder: (context, bloc, _) => DeckPage(bloc: bloc),
      ),
    );
  }

  @override
  _DeckPageState createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  TextEditingController _deckNameEditingController;
  TextEditingController _deckCodeContoller;

  Future<void> _saveDeck(BuildContext context) async {
    await widget.bloc.saveDeck(_deckNameEditingController.text != ''
        ? _deckNameEditingController.text
        : _name);
    Navigator.of(context).pop();
  }

  Future<void> _deleteDeck(BuildContext context) async {
    await widget.bloc.deleteDeck();
    Navigator.of(context).pop();
  }

  String get _name => widget.bloc.deck != null
      ? widget.bloc.deck.name
      : LocaleManager.of(context).translate('new deck');

  void _editDeckName(BuildContext context) {
    _deckNameEditingController.text = _name;

    showDialog(
      context: context,
      builder: (context) {
        return StreamBuilder<String>(
          stream: widget.bloc.$deckName,
          builder: (context, deckName) {
            return AlertDialog(
              backgroundColor: Styles.layerColor,
              title: Text(LocaleManager.of(context).translate('edit name')),
              content: TextField(
                controller: _deckNameEditingController,
                onChanged: widget.bloc.onEditName,
                decoration: InputDecoration(
                  errorText: deckName.hasError
                      ? LocaleManager.of(context).translate('empty field error')
                      : null,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(LocaleManager.of(context).translate('cancel')),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: deckName.hasError
                      ? null
                      : () {
                          _saveDeck(context);
                          Navigator.of(context).pop();
                        },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _getDeckCode(BuildContext context) async {
    _deckCodeContoller.text = await widget.bloc.deckCode();
    _deckCodeContoller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _deckCodeContoller.text.length,
    );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Styles.layerColor,
            title: Text(LocaleManager.of(context).translate('deck code')),
            content: TextField(
              controller: _deckCodeContoller,
            ),
            actions: [
              TextButton(
                child: Text(LocaleManager.of(context).translate('cancel')),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: _deckCodeContoller.text),
                  ).then((res) {
                    // Scaffold.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Copied to Clipboard'),
                    //     action: SnackBarAction(
                    //       label: 'Undo',
                    //       onPressed: () {},
                    //     ),
                    //   ),
                    // );
                    _deckCodeContoller.clear();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  Widget _buildDeckName(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.bloc.$deckNameToShow,
      initialData: _name,
      builder: (context, deckName) =>
          Text(deckName.hasData ? deckName.data : _name),
    );
  }

  Widget _buildSaveButton() {
    return StreamBuilder<List<CardModel>>(
      stream: widget.bloc.$selectedCards,
      initialData: widget.bloc.selectedCards,
      builder: (_, selectedCards) {
        if (!selectedCards.hasData || selectedCards.data.isEmpty) {
          return Container();
        }
        return IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {
              widget.bloc.deck != null
                  ? _saveDeck(context)
                  : _editDeckName(context);
            });
      },
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    return [
      widget.bloc.isEditing
          ? _buildSaveButton()
          : IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => widget.bloc.toggleEdit(),
            ),
      PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) {
          switch (value) {
            case 'Rename':
              _editDeckName(context);
              break;
            case 'Delete':
              _deleteDeck(context);
              break;
            case 'Deck code':
              _getDeckCode(context);
              break;
          }
        },
        color: Styles.layerColor,
        itemBuilder: (_) => <PopupMenuItem>[
          if (widget.bloc.deck != null) ...[
            _appBarPopupAction('Rename'),
            _appBarPopupAction('Delete')
          ],
          if (widget.bloc.selectedCards.isNotEmpty)
            _appBarPopupAction('Deck code'),
        ],
      )
    ];
  }

  Widget _appBarPopupAction(String title) {
    return PopupMenuItem(
      value: title,
      child: InkWell(
        child: Text(LocaleManager.of(context).translate(title.toLowerCase())),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _deckNameEditingController = TextEditingController();
    _deckCodeContoller = TextEditingController();
  }

  @override
  void dispose() {
    _deckNameEditingController.dispose();
    _deckCodeContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.$isEditing,
      initialData: widget.bloc.isEditing,
      builder: (context, isEditing) {
        return WillPopScope(
          onWillPop: () => _onExit(context, isEditing.data),
          child: Scaffold(
            endDrawer: FilterCardsDrawer(
              key: ValueKey('deck-filter-drawer'),
              filterBloc: Provider.of<DeckPageBloc>(context, listen: false),
            ),
            appBar: AppBar(
              title: _buildDeckName(context),
              backgroundColor: Styles.layerColor,
              actions: _appBarActions(context),
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Icon(Icons.arrow_back),
                onTap: Navigator.of(context).pop,
              ),
            ),
            body: StreamBuilder<List<CardModel>>(
              stream: widget.bloc.$selectedCards,
              initialData: widget.bloc.selectedCards,
              builder: (context, selectedCards) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    DeckPageManaCostBar(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      child: DeckStatusBar(
                        cardsInDeck: selectedCards.data,
                        withFactions: true,
                        isEditing: isEditing.data,
                      ),
                    ),
                    isEditing.data ? DeckPageCardsSelection() : DeckViewCards(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onExit(BuildContext context, bool isEditing) {
    if (Provider.of<DeckPageBloc>(context, listen: false)
            .selectedCards
            .isEmpty ||
        !isEditing) return Future.value(true);
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Styles.layerColor,
            title: Text(
                LocaleManager.of(context).translate('unsaved data warning')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(LocaleManager.of(context).translate('cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(LocaleManager.of(context).translate('yes')),
              ),
            ],
          ),
        ) ??
        false;
  }
}
