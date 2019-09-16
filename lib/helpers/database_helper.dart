import 'dart:async';
import 'dart:io' as io;
import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/values/article.dart';
import 'package:ccckmall/values/favorite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ccckmall.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE favTable(id TEXT PRIMARY KEY, aid TEXT, content TEXT)");
    await db.execute("CREATE TABLE Article(id TEXT PRIMARY KEY, content TEXT ,cid TEXT)");
  }

  Future<int> saveFavorite(Favorite fav) async {
    int res;
    try{
     var dbClient = await db;
     res = await dbClient.insert("favTable", fav.toMap());
   }catch(e){
    print(e);
    return -1;
   }
    return res;
  }

  Future<List> getAllFavorite() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM favTable');
    return result.toList();
  }

  Future<List<Favorite>> getFavorites() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM favTable');
    List<Favorite> favorite = new List();
    for (int i = 0; i < list.length; i++) {
      var fav =
      new Favorite(list[i]["aid"], list[i]["content"]);
      fav.setFavoriteId(list[i]["id"]);
      favorite.add(fav);
    }
    if(Helpers.enableDebug) print(favorite.length);
    return favorite;
  }

  Future<bool> getFavorite(String id) async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM favTable WHERE aid = $id');
      if (result.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }


 /* Future<int> deleteFavorite(Favorite fav) async {
    var dbClient = await db;
    int res =
    await dbClient.rawDelete('DELETE FROM favTable WHERE id = ?', [fav.id]);
    return res;
  }*/

  Future<int> deleteFavorite(String id) async {
    try {
      var dbClient = await db;
      await dbClient.delete('favTable', where: 'aid = ?', whereArgs: [id]);
      return 1;
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  Future<bool> update(Favorite fav) async {
    var dbClient = await db;
    int res =   await dbClient.update("favTable", fav.toMap(),
        where: "id = ?", whereArgs: <String>[fav.id]);
    return res > 0 ? true : false;
  }

  // Save Articles
  Future<int> saveArticle(Article article) async {
    int res;
    try{
      var dbClient = await db;
      res = await dbClient.insert("Article", article.toMap());
    }catch(e){
      print(e);
      return -1;
    }
    return res;
  }

  Future<bool> getArticle(String id, String cid) async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM Article WHERE id = $id AND cid = $cid');
      if (result.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> updateArticle(Article article) async {
    var dbClient = await db;
    int res =   await dbClient.update("Article", article.toMap(),
        where: "id = ?", whereArgs: <String>[article.id]);
    return res > 0 ? true : false;
  }

  Future<List> getAllArticle(String cid) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM Article WHERE cid = $cid');
    return result.toList();
  }

}