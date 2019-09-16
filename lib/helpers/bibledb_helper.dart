import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';
import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/values/bible_name.dart';
import 'package:ccckmall/values/favorite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BibleDatabaseHelper {
  static final BibleDatabaseHelper _instance = new BibleDatabaseHelper.internal();

  factory BibleDatabaseHelper() => _instance;

  final String tableBook = 'key_english';
  final String tableBible = 'bible_version_key';
  final String columnId = 'b';
  final String columnTitle = 'n';
  final String columnBibleId = 'id';
  final String columnBibleTable = 'table';
  final String columnBibleAbb = 'abbreviation';
  final String columnBibleVersion = 'version';


  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  BibleDatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "bible.db");
// Check if the database exists
    var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "bible.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    var theDb = await openDatabase(path, readOnly: true);
    return theDb;
  }

  Future<List> getAllBook() async {
    var dbClient = await db;
    var result = await dbClient.query(tableBook, columns: [columnId, columnTitle]);
    //var result = await dbClient.rawQuery('SELECT * FROM $tableNote');
    return result.toList();
  }

  Future<List> getAllBibles() async {
    var dbClient = await db;
    var result = await dbClient.query(tableBible, columns: [columnBibleId, columnBibleTable,columnBibleAbb,columnBibleVersion]);
   // var result = await dbClient.rawQuery('SELECT * FROM $tableNote');
    return result.toList();
  }

  Future<List> getAllBookChapters(String bible,int book) async {
    var dbClient = await db;
    //var result = await dbClient.query(tableBible, columns: [columnBibleId, columnBibleTable,columnBibleAbb,columnBibleVersion]);
     var result = await dbClient.rawQuery('SELECT c FROM $bible WHERE $book = 1 GROUP BY c');
    return result.toList();
  }

  Future<List> getAllBibleVerse(String bible , int chapter ,int book ) async {
    var dbClient = await db;
    //var result = await dbClient.query(tableBible, columns: [columnBibleId, columnBibleTable,columnBibleAbb,columnBibleVersion]);
     var result = await dbClient.rawQuery('SELECT * FROM $bible WHERE b = $book AND c = $chapter');
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableBook'));
  }

  Future<BibleName> getNote(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableBook,
        columns: [columnId, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new BibleName.fromMap(result.first);
    }

    return null;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
