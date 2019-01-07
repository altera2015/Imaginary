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
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple
  ];
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

  @override
  Widget build(BuildContext context) {

    int cnt = 0;
    for (int i = 0; i < _activePlayers.length; i++) {
      if (_activePlayers[i]) {
        cnt++;
      }
    }

    return Scaffold(
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
                CheckboxListTile(
                  title: Icon(Icons.person, color: _colors[0]),
                  value: _activePlayers[0],
                  onChanged: (bool value) {
                    setState(() {
                      _activePlayers[0] = value;
                    });
                  },
                ),
                CheckboxListTile(
                    title: Icon(Icons.person, color: _colors[1]),
                    value: _activePlayers[1],
                    onChanged: (bool value) {
                      setState(() {
                        _activePlayers[1] = value;
                      });
                    }),
                CheckboxListTile(
                  title: Icon(Icons.person, color: _colors[2]),
                  value: _activePlayers[2],
                  onChanged: (bool value) {
                    setState(() {
                      _activePlayers[2] = value;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Icon(Icons.person, color: _colors[3]),
                  value: _activePlayers[3],
                  onChanged: (bool value) {
                    setState(() {
                      _activePlayers[3] = value;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Icon(Icons.person, color: _colors[4]),
                  value: _activePlayers[4],
                  onChanged: (bool value) {
                    setState(() {
                      _activePlayers[4] = value;
                    });
                  },
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(

                      child: Text("Start game!"),
                      onPressed: cnt == 0 ? null : () {

                        _game.players = [];
                        for (int i = 0; i < _activePlayers.length; i++) {
                          if (_activePlayers[i]) {
                            _game.players.add(Player(i, _colors[i], 0));
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
