import 'package:flutter/material.dart';
import 'drawcanvas.dart';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'words.dart';
import 'dart:async';
import 'dart:math';
import 'player.dart';
import 'post_game.dart';

class GamePage extends StatefulWidget {
  final Words _words;
  final Game _game;

  GamePage(this._words, this._game, {Key key}) : super(key: key);

  @override
  _GamePageState createState() => new _GamePageState();
}

class _GamePageState extends State<GamePage> {
  DrawPainter _painter;
  int _totalSeconds;
  int _currentSeconds;
  Timer _countdown;
  Stopwatch _stopwatch;
  List<Widget> _acceptButtons;
  Random _rnd = Random(DateTime.now().millisecondsSinceEpoch);


  void _startTimer(int total) {
    if ( total < 0 ) {
      _totalSeconds = 1;
      _currentSeconds = 1;
      return;
    }
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

  void _toolUpdated () {
    if (_painter.tool != null) {
      _painter.tool.floatActionButtonStateChanged = () {
        setState(() {});
      };
    }

  }

  @override
  void initState() {
    super.initState();
    _painter = DrawPainter();
    _stopwatch = Stopwatch();
    _totalSeconds = 0;
    _currentSeconds = 0;
    _startTimer(120);
    _toolUpdated();
  }

  @override
  void dispose() {
    _countdown.cancel();
    super.dispose();
  }


  void _finished(BuildContext context, Color color) async {
    Duration elapsed = _stopwatch.elapsed;
    _stopwatch.stop();
    Player p = Player.find(widget._game.players, color);

    if ( p != null ) {
      p.points++;
    }

    bool a = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PostGamePage(widget._game, p)));

    if ( a == null ) {
      if ( p != null ) {
        p.points--;
      }
      _stopwatch.start();
      _startTimer(120 - _currentSeconds);
    } else {
      if ( color != null ) {
        widget._words.solve(widget._game.word, elapsed);
      } else {
        widget._words.failToSolve(widget._game.word);
      }
      Navigator.pop(context, true);
    }

  }


  @override
  Widget build(BuildContext context) {

    if (_acceptButtons == null ) {
      _acceptButtons = [];
      widget._game.players.forEach((Player player) {
        if ( widget._game.drawer() != player ) {
        _acceptButtons.add(IconButton(
            icon: Icon(Icons.person),
            color: player.color,
            onPressed: () {
              _finished(context, player.color);
            }));
        }
      });
      _acceptButtons.add(IconButton(
          icon: Icon(Icons.thumb_down),
          color: Colors.black,
          onPressed: () {
            _finished(context, null);
          }));
    }

    return Scaffold(

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
            children: _acceptButtons),
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
