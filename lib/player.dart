import 'dart:core';
import 'package:flutter/painting.dart';

class Game {
  List<Player> players;
  int currentDrawer;
  String word;

  void nextDrawer() {
    currentDrawer++;
    if ( currentDrawer >= players.length ) {
      currentDrawer = 0;
    }
  }
  Player drawer( ) {
    return players[currentDrawer];
  }

}


class Player {
  int index;
  Color color;
  int points;

  Player(this.index, this.color, this.points);

  static Player find(List<Player> players, Color c ) {

    if ( c == null ) {
      return null;
    }

    Player found;
    players.forEach((Player p) {
      if ( p.color == c ) {
        found = p;
      }
    });
    return found;
  }

  String toString( ) {
    return "Player index=$index, pts=$points";
  }

}



