import 'package:ccckmall/helpers/database_helper.dart';
import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/values/article.dart';
import 'package:ccckmall/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ccckmall/values/config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ccckmall/widgets/card_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';


String apiURL(String value) {
  String url = Config.articleBy_end_point + value + '/' + Config.API_KEY;
  return url;
}

class ArticlesById extends StatefulWidget {
  final String value;

  ArticlesById({Key key, this.value}) : super(key: key);

  @override
  _AllArticlesState createState() => _AllArticlesState(this.value);
}

class _AllArticlesState extends State<ArticlesById> {
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final List<ArticleCard> _news = <ArticleCard>[];
  var resBody;
  var db = new DatabaseHelper();
  bool loading = true;
  final String value;
  var data;
  bool isloadingMore = false;
  SharedPreferences prefs;

  Map<String, String> body = {
    'track': 'true',
  };

  _AllArticlesState(this.value);

  getAllArticlesById() async {
      var res = await http
          .get(Uri.encodeFull(apiURL(value)),
          headers: {"Accept": "application/json"});
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
              type: data['type']));

         // nextArticleId = data['id'];

          _saveArticle(
              data['id'].toString(),
              data['title'],
              data['category'],
              data['short'],
              data['content'],
              data['video'],
              data['comment'],
              data['image'],
              data['created'],
              data['type']);
      }
      if (this.mounted) {
        setState(() {
          loading = false;
          prefs.setBool('isFirst', false);
          if (Helpers.enableDebug) print("Loaded Data");
        });
      }
  }

  _loadOfflineArticle(){
    loading = false;
    if (Helpers.enableDebug) print("Loaded Offline Data");
    db.getAllArticle(widget.value).then((list) {
      setState(() {
        if(list.isEmpty){
          getAllArticlesById();
        }else{
          list.forEach((list) {
            data = jsonDecode(list['content']);
            _news.add(new ArticleCard(
                id: int.parse(data['idArticle']),
                title: data['titleArticle'],
                image: data['imageArticle'],
                created: data['createdArticle'],
                content: data['contentArticle'],
                category: data['categoryArticle'],
                comment: data['commentArticle'],
                video: data['video'],
                type: data['type']));
          });
        }
      });
    });
  }

  _saveArticle(String id,String title,String category,String short,String content,String video,bool comment,String image,String created,String type){
    var resbody = jsonEncode({
      'idArticle': id,
      'titleArticle': title,
      'imageArticle': image,
      'createdArticle': created,
      'contentArticle': content,
      'categoryArticle': category,
      'commentArticle': comment,
      'video': video,
      'type': type
    });
    db.getArticle(id,widget.value).then((onValue){
      if(onValue){
        db.updateArticle(new Article(id, resbody,widget.value)).then((onValue){
          setState(() {
            if(onValue != null){
              if (Helpers.enableDebug) print("Article Updated ");
            }
          });
        });
      }else{
        db.saveArticle( new Article(id, resbody,widget.value)).then((response) {
          setState(() {
            if (response != null) {
              if (Helpers.enableDebug) print("Article Saved");
            }
          });
        });
      }
    });
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    bool isFirstLoad = prefs.getBool('isFirst') ?? true;
    print(isFirstLoad);
    setState(() {
      if(isFirstLoad) getAllArticlesById();
      else _loadOfflineArticle();
    });
  }

/*
  getNextArticles() async {
    isloadingMore = true;
    String url = Config.article_next_end_point +
        nextArticleId.toString() +
        "/" +
        Config.API_KEY;
    var res = await http
        .get(Uri.encodeFull(Config.appURL + "articles/next/"+ this.value +"/"+nextArticleId.toString()+"/"+Config.API_KEY), headers: {"Accept": "application/json"});
    resBody = jsonDecode(res.body);
    print(Config.appURL + "articles/next/"+ this.value +"/"+nextArticleId.toString()+"/"+Config.API_KEY);
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

       // nextArticleId = data['id'];

        _saveArticle(
            data['id'].toString(),
            data['title'],
            data['category'],
            data['short'],
            data['content'],
            data['video'],
            data['comment'],
            data['image'],
            data['created'],
            data['type']);
    }
    nextArticleId = _news[0].id;
    if (this.mounted) {
      setState(() {
        isloadingMore = false;
        if(Helpers.enableDebug) print("Loaded Data");
      });
    }
  }
*/


  Widget _buildBody() {
    if (loading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return  new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                //controller: controller,
            padding: new EdgeInsets.all(5.0),
            itemBuilder: (_, int index) => _news[index],
            itemCount: _news.length ,
          )),
        ],
      );
    }
  }

  Future<void> _refresh() async {
  setState(() {
    initConnectivity(true);
      loading = true;
      getAllArticlesById();
  });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //backgroundColor: Color(Values.backgroundColor),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        child: Center(
          child: _buildBody(),
        ),
        onRefresh: _refresh,
      ),
    );
  }

  @override
  void initState() {
    initConnectivity(false);
    //readLocal();
    //controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }


  @override
  void dispose() {
   // _connectivitySubscription.cancel();
    //controller.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> initConnectivity(bool refresh) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(refresh){
      if(connectivityResult == ConnectivityResult.none){
        _loadOfflineArticle();
      }else{
       isloadingMore = true;
       getAllArticlesById();
      }
    }else {
      if (connectivityResult == ConnectivityResult.none) {
        _loadOfflineArticle();
      } else {
        prefs = await SharedPreferences.getInstance();
        bool isFirstLoad = prefs.getBool('isFirst') ?? true;
        print(isFirstLoad);
        setState(() {
          if (isFirstLoad)
            getAllArticlesById();
          else
            _loadOfflineArticle();
        });
      }
    }

    /*if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    }*/
  }

}
