import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;

class Words {

  Database database;

  void _onCreateDB(Database db, int version) async {

    await db.execute(
        'CREATE TABLE words (id INTEGER PRIMARY KEY, word TEXT, accept_cnt INTEGER default 0, reject_cnt INTEGER default 0, solve_cnt INTEGER default 0, fail_cnt INTEGER default 0, last_offer DOUBLE)');

    await db.transaction((txn) async {

      String txt = await rootBundle.loadString('nounlist.txt');
      List<String> lines = txt.split("\n");

      print("got ${lines.length} characters.");
      lines.forEach((String line) {
        // db.insert(table, values)
        print(line);
        txn.execute("INSERT into words (word) VALUES (?)", [line]);
      });
    });
  }

  Future<void> _initialize() async {

    if (database!=null) {
      return;
    }

    var databasesPath = await getDatabasesPath();
    String path = databasesPath + '/imaginary.db';
    // deleteDatabase(path);

    database = await openDatabase(path, version: 1,
        onCreate: _onCreateDB );
  }

  Words();

  void dispose() {
    if ( database != null ) {
      database.close();
    }
  }

  Future<String> getWord() async {

    await _initialize();

    List<Map> wordList = await database.query('words', columns: ['word'], where: "(last_offer < julianday('now') - 1 or last_offer IS NULL)", orderBy: "RANDOM()", limit: 1);
    if (wordList.length > 0 ) {
      Map word = wordList.first;
      String wordStr = word["word"].toString();
      await _setLastOffer(wordStr);
      return wordStr;
    }
    return null;
  }

  Future<void> _setLastOffer(String word) async {
    await _initialize();
    String sql = "UPDATE words SET last_offer=julianday('now') WHERE word=?";
    await database.execute(sql, [word]);
  }


  Future<void> accept(String word) async {
    await _initialize();
    String sql = "UPDATE words SET accept_cnt=accept_cnt+1 WHERE word=?";
    await database.execute(sql, [word]);
  }

  Future<void> reject(String word) async {
    await _initialize();
    String sql = "UPDATE words SET reject_cnt=reject_cnt+1 WHERE word=?";
    await database.execute(sql, [word]);
  }

  Future<void> solve(String word, Duration duration) async {
    await _initialize();
    String sql = "UPDATE words SET solve_cnt=solve_cnt+1 WHERE word=?";
    await database.execute(sql, [word]);
  }

  Future<void> failToSolve(StringSink word) async {
    await _initialize();
    String sql = "UPDATE words SET fail_cnt=fail_cnt+1 WHERE word=?";
    await database.execute(sql, [word]);
  }
}