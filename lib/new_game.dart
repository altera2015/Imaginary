import 'package:flutter/material.dart';
import 'words.dart';
import 'next_round.dart';
import 'player.dart';

class NewGamePage extends StatefulWidget {
  final String title;

  NewGamePage({this.title});

  @override
  _NewGameState createState() {
    return _NewGameState();
  }
}

class _NewGameState extends State<NewGamePage> {
  Game _game;
  List<bool> _activePlayers = [true, true, false, false, false];
  Words _words;

  @override
  void initState() {
    super.initState();
    _words = Words();
    _game = Game();
  }

  @override
  void dispose() {
    _words.dispose();
    super.dispose();
  }

  Iterable<Widget> get playerWidgets sync* {
    for (PlayerConfig config in PlayerConfig.players) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          avatar: CircleAvatar(
              child: Icon(config.iconData, color: config.color, size: 25)),
          label: Text(config.name),
          selected: _activePlayers[config.index],
          onSelected: (bool value) {
            setState(() {
              _activePlayers[config.index] = value;
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int cnt = 0;
    for (int i = 0; i < _activePlayers.length; i++) {
      if (_activePlayers[i]) {
        cnt++;
      }
    }

    return Scaffold(
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Imaginary"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
                title: Text("Reset word database"),
                onTap: () {
                  _words.clearLastOffers();
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text("Dump"),
                onTap: () {
                  // _words.dump();
                  _words.getStats();
                  Navigator.pop(context);
                })
          ],
        )),
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Imaginary, drawing fun with real life friends.",
                    textAlign: TextAlign.center),
                Wrap(
                  children: playerWidgets.toList(),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text("Start game!"),
                      onPressed: cnt == 0
                          ? null
                          : () {
                              _game.players = [];
                              for (int i = 0; i < _activePlayers.length; i++) {
                                if (_activePlayers[i]) {
                                  _game.players.add(
                                      Player(i, PlayerConfig.players[i], 0));
                                }
                              }
                              _game.currentDrawer = 0;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NextRoundWidget(_words, _game)));
                            },
                    ))
              ],
            )));
  }
}
