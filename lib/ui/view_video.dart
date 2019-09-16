import 'package:badges/badges.dart';
import 'package:ccckmall/ui/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ccckmall/helpers/database_helper.dart';
import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/values/colors.dart';
import 'package:ccckmall/values/config.dart';
import 'package:ccckmall/values/favorite.dart';
import 'package:ccckmall/widgets/comment_card.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as prefix0;
import 'dart:convert';
import 'package:flutter/foundation.dart' as foundation;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class VideoArticle extends StatefulWidget {
   String idArticle;
   String titleArticle;
   String imageArticle;
   String createdArticle;
   String contentArticle;
   String categoryArticle;
   String commentArticle;
   bool isVideo;
   String video;

  VideoArticle(
      {Key key,
      this.idArticle,
      this.titleArticle,
      this.imageArticle,
      this.createdArticle,
      this.contentArticle,
      this.categoryArticle,
      this.commentArticle,
      this.isVideo,
      this.video})
      : super(key: key);

  @override
  _ViewVideoArticleState createState() => _ViewVideoArticleState();
}

class _ViewVideoArticleState extends State<VideoArticle> {
  var db = new DatabaseHelper();
  final List<CommentCard> _comments = <CommentCard>[];
  bool loading = true;
  bool visibilityComments = false;
  bool isFavoriteSaved = false;
  final TextEditingController _textController = new TextEditingController();
  var resBody;
  SharedPreferences prefs;
  String msg, code;
  int _count = 0;
  bool isLogin = false;
  bool isLoading = false;
  final String header =
      "<style type=\"text/css\">img{max-width:100%  !important}</style>";

  void _changed(bool visibility) {
    setState(() {
      visibilityComments = visibility;
    });
  }

  getFavorite() {
    db.getFavorite("${widget.idArticle}").then((value) {
      setState(() {
        if (value) {
          isFavoriteSaved = true;
        }
      });
    });
  }

  getAllComments() async {
    String url = Config.get_comments_by_id +
        "${widget.idArticle}" +
        "/" +
        Config.API_KEY;
    if(Helpers.enableDebug) print("COMMENTS:" + url);
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    resBody = jsonDecode(res.body);
    if(Helpers.enableDebug) print(resBody);
    if (res == null || res.statusCode != 200)
      throw new Exception(
          'HTTP request failed, statusCode: ${res?.statusCode}, $res');
    _comments.clear();
    _count = 0;
    for (var data in resBody) {
      _comments.add(new CommentCard(
          author: data['author'],
          content: data['content'],
          enabled: data['enabled'],
          created: data['created']));
      _count++;
    }
    if (this.mounted) {
      setState(() {
        loading = false;
        if(Helpers.enableDebug) print("Loaded Data");
      });
    }
  }

  setContent()async{
      var res = await http.get(Uri.encodeFull(Config.appURL + "articles/get/"+widget.idArticle+"/"+Config.API_KEY), headers: {"Accept": "application/json"});
      resBody = jsonDecode(res.body);
      if (res == null || res.statusCode != 200)
        throw new Exception(
            'HTTP request failed, statusCode: ${res?.statusCode}, $res');
      if(widget.contentArticle == '' || null){
        setState(() {
          widget.contentArticle = resBody['content'];
        });
      }
  }

  @override
  void initState() {
    getAllComments();
    getFavorite();
    setContent();
    super.initState();
  }
  String getVideoID(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('isLogin') ?? false;
    setState(() {});
  }

  Future<Null> addComments(String comment) async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    var res = await http.get(
        Uri.encodeFull(Config.appURL +
            "comments/add/" +
            prefs.getInt("ID_USER").toString() +
            "/" +
            widget.idArticle +
            "/" +
            comment +
            "/" +
            Config.API_KEY),
        headers: {"Accept": "application/json"});
    String responseBody = res.body;
    var responseJSON = json.decode(responseBody);
    if (res.statusCode == 200) {
      code = responseJSON['code'];
      msg = responseJSON['message'];
      resBody = responseJSON['values'];
      if (code == '200') {
        Fluttertoast.showToast(msg: msg);
        setState(() {
          _textController.clear();
          isLoading = false;
          getAllComments();
        });
      } else {
        setState(() {
          isLoading = false;
          Fluttertoast.showToast(msg: msg);
        });
      }
    } else {
      if (Helpers.enableDebug)
        print('Something went wrong. \nResponse Code : ${res.statusCode}');
    }
  }

  Widget _body(BuildContext context){
    String vidId = getVideoID(widget.video);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: widget.isVideo ? new WebView(
                  //initialUrl: "${widget.video}",
                  //TODO: Find Function to extract youtube videoId
                    initialUrl: new Uri.dataFromString(
                        "<body style=\"margin: 0; padding: 0\"><iframe  allowfullscreen=\"allowfullscreen\" width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/" +
                            "$vidId" +
                            "\" frameborder=\"0\" allowfullscreen></iframe></body>",
                        mimeType: 'text/html')
                        .toString(),
                    javascriptMode: JavascriptMode.unrestricted)
                    :FadeInImage(
                  width: MediaQuery.of(context).size.width,
                  placeholder: new AssetImage("images/placeholder.png"),
                  image: AdvancedNetworkImage(
                    "${widget.imageArticle}",
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: const Duration(days: 10)),
                    fallbackAssetImage: 'images/placeholder.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              new Container(
                  padding: new EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 5),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${widget.titleArticle}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500,/*color: Color(Values.textColor)*/),
                          textAlign: TextAlign.start,
                        ),
                      )
                    ],
                  )),
              isIOS? new Container(
                  padding: new EdgeInsets.only(top: 10,left: 10),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CupertinoButton(
                            child: new Icon(
                              FontAwesomeIcons.facebookSquare,
                              //color: Color(0xFF3F51B5),
                              color: CupertinoColors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Share.share("${widget.titleArticle}" +
                                  " \n\n " +
                                  Values.share_text );
                            },
                          ),
                          CupertinoButton(
                            child: new Icon(
                              FontAwesomeIcons.twitter,
                              //color: Color(0xFF03A9F4),
                              color: CupertinoColors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Share.share("${widget.titleArticle}" +
                                  " \n\n " +
                                  Values.share_text);

                            },
                          ),
                          CupertinoButton(
                            child: new Icon(
                              FontAwesomeIcons.whatsapp,
                              //color: Color(0xFF40C351),
                              color: CupertinoColors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Share.share("${widget.titleArticle}" +
                                  " \n\n " +
                                  Values.share_text);

                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10,bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Icon(
                              Icons.access_alarm,
                              size: 24,
                              color: CupertinoColors.white,
                            ),
                            SizedBox(width: 5,),
                            new Text(
                              "${widget.createdArticle}",
                              textAlign: TextAlign.end,
                              style:TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
                  : new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.facebookSquare,
                          color: Color(0xFF3F51B5),
                          size: 28,
                        ),
                        onPressed: () {
                          Share.share("${widget.titleArticle}" +
                              " \n\n " +
                              Values.share_text);
                        },
                      ),
                      IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.twitter,
                          color: Color(0xFF03A9F4),
                          size: 28,
                        ),
                        onPressed: () {
                          Share.share("${widget.titleArticle}" +
                              " \n\n " +
                              Values.share_text);
                        },
                      ),
                      IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Color(0xFF40C351),
                          size: 28,
                        ),
                        onPressed: () {
                          Share.share("${widget.titleArticle}" +
                              " \n\n " +
                              Values.share_text);
                        },
                      ),
                      new Expanded(
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    new Icon(
                                      Icons.access_alarm,
                                      size: 24,
                                      color: Color(Values.primaryColor),
                                    ),
                                    new Text(
                                      "${widget.createdArticle}",
                                      textAlign: TextAlign.end,
                                      style:
                                      TextStyle(fontWeight: FontWeight.w600,/*color: Color(Values.textColor)*/),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  )),
                     Container(
                       //color: Color(Values.backgroundColor),
                       //height: MediaQuery.of(context).size.height/0.5,
                       child: prefix0.HtmlWidget(
                         widget.contentArticle,
                         webView: true,
                        // textStyle: TextStyle(color: Color(Values.textColor)),
                       )   ,
                     ),

            ],
          ),
        ),
        Visibility(
          visible: visibilityComments == false ? false : true,
          child: new Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              clipBehavior: Clip.hardEdge,
              child: new Scaffold(
                  body: Stack(
                    children: <Widget>[
                      new Container(
                          child: new Column(children: <Widget>[
                            new Flexible(
                                child: new ListView.builder(
                                  padding: new EdgeInsets.all(8.0),
                                  itemBuilder: (_, int index) => _comments[index],
                                  itemCount: _comments.length,
                                  reverse: false,
                                )),
                            new Divider(height: 1.0),
                            new Container(
                              decoration: new BoxDecoration(
                                  color: Theme.of(context).cardColor),
                              child: new IconTheme(
                                data: new IconThemeData(
                                    color: Theme.of(context).accentColor),
                                child: new Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: new Row(children: <Widget>[
                                      new Flexible(
                                        child: new TextField(
                                          controller: _textController,
                                          decoration:
                                          new InputDecoration.collapsed(
                                              hintText: "Post Comment"),
                                        ),
                                      ),
                                      new Container(
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: IconButton(
                                          icon: new Icon(
                                            FontAwesomeIcons.comments,
                                            color: Color(Values.primaryColor),
                                            size: 28,
                                          ),
                                          onPressed: () {
                                            if (!isLogin) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignIn()),
                                              );
                                            } else {
                                              if (_textController.text == '' ||
                                                  _textController.text ==
                                                      null) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    'Comments cannot be empty!');
                                              } else {
                                                addComments(
                                                    _textController.text);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ]),
                                    decoration: Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                        ? new BoxDecoration(
                                        border: new Border(
                                            top: new BorderSide(
                                                color: Colors.grey[200])))
                                        : null),
                              ),
                            ),
                          ]),
                          decoration:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? new BoxDecoration(
                              border: new Border(
                                  top: new BorderSide(
                                      color: Colors.grey[200])))
                              : null),
                      Positioned(
                        child: isLoading
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : Container(),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(Values.backgroundColor),
        appBar: AppBar(
          title: Text( "${widget.titleArticle}",
            overflow: TextOverflow.fade,
            //style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Visibility(
                visible: "${widget.commentArticle}" == "false" ? false : true,
                child: Badge(
                  position:
                  BadgePosition.topRight(top: 8, right: 8),
                  badgeContent: Text(_count.toString()),
                  child: IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      _changed(visibilityComments == true ? false : true);
                    },
                  ),
                )),
            IconButton(
              icon: Icon(
                isFavoriteSaved == true
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: Color(Values.textColor),
              ),
              tooltip: 'Add To Favorite',
              onPressed: () {
                if (!isFavoriteSaved) {
                  var resbody = jsonEncode({
                    'idArticle': "${widget.idArticle}",
                    'titleArticle': "${widget.titleArticle}",
                    'imageArticle': "${widget.imageArticle}",
                    'createdArticle': "${widget.createdArticle}",
                    'contentArticle': "${widget.contentArticle}",
                    'categoryArticle': "${widget.categoryArticle}",
                    'commentArticle': "${widget.commentArticle}",
                    'video': "${widget.video}",
                    'type': "video"
                  });
                  db
                      .saveFavorite(
                          new Favorite("${widget.idArticle}", resbody))
                      .then((response) {
                    setState(() {
                      if (response != null) {
                        isFavoriteSaved = true;
                        Helpers.showMessage("Article Saved To Favorites");
                      }
                    });
                  });
                } else {
                  db.deleteFavorite("${widget.idArticle}").then((value) {
                    setState(() {
                      isFavoriteSaved = false;
                    });
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: Color(Values.textColor),
              ),
              tooltip: 'Share',
              onPressed: () {
                Share.share(
                    "${widget.titleArticle}" + " \n\n " + Values.share_text);
              },
            ),
          ],
        ),
        body: _body(context)
    );
  }
}
