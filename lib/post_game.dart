import 'package:flutter/material.dart';
import 'player.dart';

class PostGamePage extends StatefulWidget {

  final Game _game;
  final Player _winner;

  PostGamePage(this._game, this._winner);

  @override
  _PostGameState createState() => _PostGameState();

}

class _PostGameState extends State<PostGamePage> {

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if ( widget._winner != null ) {
      list.add(Text("Winner:",
          textAlign: TextAlign.center, style: Theme
              .of(context)
              .textTheme
              .title));
      list.add(Icon(Icons.person, color: widget._winner.color,size: 48));
    } else {
      list.add(Text("No winner!",
          textAlign: TextAlign.center, style: Theme
              .of(context)
              .textTheme
              .title));
    }

    list.add(Text("${widget._game.word}",
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
            Navigator.pop(context, true);
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


}