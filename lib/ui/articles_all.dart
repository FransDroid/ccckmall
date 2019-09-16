import 'package:ccckmall/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ccckmall/values/config.dart';
import 'dart:convert';

import 'package:ccckmall/widgets/card_home.dart';

String apiURL() {
  String url = Config.article_end_point + Config.API_KEY;
  return url;
}

class AllArticles extends StatefulWidget {
  @override
  State<AllArticles> createState() {
    return new _AllArticlesState();
  }
}

class _AllArticlesState extends State<AllArticles> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final List<ArticleCard> _news = <ArticleCard>[];
  var resBody;
  bool loading = true;
  bool isloadingMore = false;
  ScrollController controller;
  int nextArticleId = -1;

  Map<String, String> body = {
    'track': 'true',
  };

  getAllArticles() async {
    var res = await http
        .get(Uri.encodeFull(apiURL()), headers: {"Accept": "application/json"});
    resBody = jsonDecode(res.body);
    if (res == null || res.statusCode != 200)
      throw new Exception(
          'HTTP request failed, statusCode: ${res?.statusCode}, $res');
    _news.clear();
    for (var data in resBody) {
      _news.add(new ArticleCard(
          id: data['id'],
          title: data['title'],
          category: data['category'],
          short: data['short'],
          content: data['content'],
          video: data['video'],
          comment: data['comment'],
          image: data['image'],
          created: data['created'],
          type: data['type'] ));

          nextArticleId = data['id'];
    }
    if (this.mounted) {
      setState(() {
        loading = false;
        if(Helpers.enableDebug) print("Loaded Data");
      });
    }
  }

  getNextArticles() async {
   isloadingMore = true;
    String url = Config.article_next_end_point +
        nextArticleId.toString() +
        "/" +
        Config.API_KEY;
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    resBody = jsonDecode(res.body);
    if (res == null || res.statusCode != 200)
      throw new Exception(
          'HTTP request failed, statusCode: ${res?.statusCode}, $res');
    for (var data in resBody) {
      _news.add(new ArticleCard(
          id: data['id'],
          title: data['title'],
          category: data['category'],
          short: data['short'],
          content: data['content'],
          video: data['video'],
          comment: data['comment'],
          image: data['image'],
          created: data['created'],
          type: data['type']));

      nextArticleId = data['id'];
    }
    if (this.mounted) {
      setState(() {
        isloadingMore = false;
        if(Helpers.enableDebug) print("Loaded Data");
      });
    }
  }

  Widget _buildBody() {
    if (loading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
            controller: controller,
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (_, int index) => _news[index],
            itemCount: _news.length,
          )),
          new Divider(color: Colors.transparent,height: 10,),
          new Visibility(
            visible: isloadingMore == true ? true : false,
            child: const  CircularProgressIndicator(),
          )
        ],
      );
    }
  }

  void _scrollListener() {
    //print(controller.position.extentAfter);
    if (controller.position.extentAfter == 0) {
      setState(() {
        //Helpers.showMessage(nextArticleId.toString());
        getNextArticles();
      });
    }
  }

  Future<Null> _refresh() {
   setState(() {
     _news.clear();
     getAllArticles();
   });
   return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: new Center(
        child: _buildBody(),
      )),
    );
  }

  @override
  void initState() {
    getAllArticles();
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }
}
