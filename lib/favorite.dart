import 'dart:convert';
import 'package:ccckmall/helpers/database_helper.dart';
import 'package:ccckmall/widgets/favorite_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'helpers/helpers.dart';
import 'package:flutter/foundation.dart' as foundation;
bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
   String id,views,  likes,  title, content, category,image,created,comment,type,video;
  final List<FavoriteCard> _fav = <FavoriteCard>[];
  bool loading = true;
  var db = new DatabaseHelper();
  List favList;
  var data;

  getFavorite()  {
    _fav.clear();
     db.getAllFavorite().then((list) {
      setState(() {
        list.forEach((list) {
          data = jsonDecode(list['content']);
          if(Helpers.enableDebug) print(data);
      _fav.add(new FavoriteCard(
          id: data['idArticle'],
          views: data['views'],
          likes: data['likes'],
          title: data['titleArticle'],
          image: data['imageArticle'],
          created: data['createdArticle'],
          content: data['contentArticle'],
          category: data['categoryArticle'],
          comment: data['commentArticle'],
          video: data['video'],
          type: data['type']));
        });
         loading = false;
        if(Helpers.enableDebug) print("Loaded");
      });
    });
  }

  Widget _body(BuildContext context){
    return new Center(
      child: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemBuilder: (_, int index) => _fav[index],
                itemCount: _fav.length,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isIOS? CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.back),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        middle: Text('Favortite'),
      ), child: SafeArea(child: _body(context)),)
        :new Scaffold(
      appBar: AppBar(
        title: Text("Favortite"),
      ),
      body: _body(context),
    );
  }

  @override
  void initState() {
    getFavorite();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
