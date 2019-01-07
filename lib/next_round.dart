import 'package:flutter/material.dart';
import 'words.dart';
import 'player.dart';
import 'game_page.dart';

class NextRoundWidget extends StatefulWidget {
  final Words _words;
  final Game _game;

  NextRoundWidget(this._words, this._game);

  @override
  _NextRoundState createState() {
    return _NextRoundState();
  }
}

class _NextRoundState extends State<NextRoundWidget> {

  String _word = "Picking a word...";
  bool _newWordGenerated = false;

  void _initWord() {
    widget._words.getWord().then((String word) {
      setState(() {
        _newWordGenerated = true;
        _word = word;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initWord();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Next Round!"),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person, color: widget._game.drawer().color, size: 50.0,),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(

                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: Colors.black54,
                          width: 3.0
                        )
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 10.0, top:10.0, bottom:10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_word,
                                    style: Theme.of(context).textTheme.title.apply(color: Colors.white)),
                                FlatButton(
                                    child: Icon(Icons.refresh, size: 48, color: Colors.white),
                                    onPressed: () {
                                      _initWord();
                                    })
                              ]))),
                  SizedBox(height: 50.0),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                            child: Row(
                            children: [
                                Icon(Icons.check_circle,
                                size: 48, color: Colors.green),
                            SizedBox(
                              width: 10.0
                            ),
                            Text( _newWordGenerated ? "Lets go!" : "Pick new word")]),
                            onPressed: () async {

                              if ( !_newWordGenerated ) {
                                _initWord();
                                return;
                              }

                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GamePage(widget._words, _word, widget._game))
                              );

                              widget._game.nextDrawer();
                              _initWord();

                            }),
                      ])
                ])));
  }
}
