import 'dart:core';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class Game {
  List<Player> players;
  int currentDrawer;
  String word;

  void nextDrawer() {
    currentDrawer++;
    if (currentDrawer >= players.length) {
      currentDrawer = 0;
    }
  }

  Player get drawer => players[currentDrawer];
}

class PlayerConfig {
  final int index;
  final Color color;
  final IconData iconData;
  final String name;

  PlayerConfig(this.index, this.color, this.iconData, this.name);

  factory PlayerConfig.create(int index, String name) {
    return PlayerConfig(index, colors[index], icons[index], name);
  }

  static List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.brown,
    Colors.purple,
    Colors.yellow
  ];

  static List<IconData> icons = [
    Icons.cake,
    Icons.directions_car,
    Icons.airplanemode_active,
    Icons.ac_unit,
    Icons.all_inclusive,
    Icons.access_alarm
  ];

  static List<PlayerConfig> players = [
    PlayerConfig.create(0, "cake"),
    PlayerConfig.create(1, "car"),
    PlayerConfig.create(2, "plane"),
    PlayerConfig.create(3, "snow"),
    PlayerConfig.create(4, "loop"),
    PlayerConfig.create(5, "alarm"),
  ];
}

class Player {
  final int index;
  final PlayerConfig config;
  int points;

  Color get color => config.color;
  IconData get iconData => config.iconData;

  Player(this.index, this.config, this.points);

  static Player find(List<Player> players, Color c) {
    if (c == null) {
      return null;
    }

    Player found;
    players.forEach((Player p) {
      if (p.color == c) {
        found = p;
      }
    });
    return found;
  }

  String toString() {
    return "Player index=$index, pts=$points";
  }
}
