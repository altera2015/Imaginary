import 'package:flutter/material.dart';
import 'drawcanvas.dart';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'words.dart';
import 'dart:async';
import 'dart:math';
import 'player.dart';

class GamePage extends StatefulWidget {
  final Words _words;
  final Game _game;
  final String _word;

  GamePage(this._words, this._word, this._game, {Key key}) : super(key: key);

  @override
  _GamePageState createState() => new _GamePageState();
}

class _GamePageState extends State<GamePage> {
  DrawPainter _painter;

  String _guessedWord;
  int _totalSeconds;
  int _currentSeconds;
  Timer _countdown;
  Stopwatch _stopwatch;
  Random _rnd = Random(DateTime.now().millisecondsSinceEpoch);

  void _startTimer(int total) {
    _totalSeconds = total;
    _currentSeconds = 0;
    if (_countdown != null) {
      _countdown.cancel();
    }

    _countdown = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _currentSeconds++;
      if (_totalSeconds == _currentSeconds) {
        timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _painter = DrawPainter();
    _stopwatch = Stopwatch();
    _totalSeconds = 0;
    _currentSeconds = 0;
    _guessedWord = null;
    _startTimer(120);
  }

  @override
  void dispose() {
    _countdown.cancel();
    super.dispose();
  }


  void _finished(BuildContext context, Color color) async {
    Duration elapsed = _stopwatch.elapsed;
    _stopwatch.stop();
    widget._words.solve(widget._word, elapsed);
    Player p = Player.find(widget._game.players, color);
    if (p != null) {
      p.points += 1;
    } else {
    }
    setState( () {
      _guessedWord = widget._word;
    });
  }

  Widget buildPostGame(BuildContext context) {
    List<Widget> list = [];

    list.add(Text("$_guessedWord",
        textAlign: TextAlign.center, style: Theme.of(context).textTheme.title));

    widget._game.players.sort((Player p1, Player p2) {
      return p2.points - p1.points;
    });

    widget._game.players.forEach((Player player) {
      list.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.person, color: player.color),
        SizedBox(width: 10.0),
        Text("${player.points}")
      ]));
    });

    widget._game.players.sort((Player p1, Player p2) {
      return p1.index - p2.index;
    });

    list.add(Padding(
        padding: EdgeInsets.all(20.0),
        child: RaisedButton(
          child: Text("Next round!"),
          onPressed: () {
            Navigator.pop(context);
          },
        )));

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Imaginary"),
        ),
        body: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: list,
            )));
  }

  @override
  Widget build(BuildContext context) {

    if (_painter.tool != null) {
      _painter.tool.floatActionButtonStateChanged = () {
        setState(() {});
      };
    }

    if (_guessedWord != null) {
      return buildPostGame(context);
    }

    List<Widget> acceptButtons = [];
    widget._game.players.forEach((Player player) {
      //if ( widget._game.drawer() != player ) {
        acceptButtons.add(IconButton(
            icon: Icon(Icons.person),
            color: player.color,
            onPressed: () {
              _finished(context, player.color);
            }));
      // }
    });
    acceptButtons.add(IconButton(
        icon: Icon(Icons.thumb_down),
        color: Colors.black,
        onPressed: () {
          _finished(context, null);
        }));

    return Scaffold(
      /* drawer: Drawer(
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
              title: Text("New Game"),
              onTap: () {
                Navigator.pop(context);
                _startGame(context);
              }
            )

          ],
        )
      ),*/
      appBar: new AppBar(
        title: new Text("Imaginary"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              _painter.undo();
            },
          ),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _painter.clear();
              }),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                ByteData b = await _painter.toByteData();
                EsysFlutterShare.shareImage(
                    'Imaginary${_rnd.nextInt(10000)}.png',
                    b,
                    'Imaginary Drawing');
              })
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: acceptButtons),
      ),
      body: Column(children: [
        LinearProgressIndicator(
          value:
              _totalSeconds > 0 ? 1.0 - _currentSeconds / _totalSeconds : 1.0,
        ),
        new Expanded(
            // padding: new EdgeInsets.all(20.0),
            child: new ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: new Card(
                  elevation: 10.0,
                  child: DrawCanvasWidget(
                    _painter,
                  ),
                )))
      ]),
      floatingActionButton: _painter.tool.floatingActionButton(context),
    );
  }
}
