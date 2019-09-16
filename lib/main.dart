import 'dart:convert';

import 'package:ccckmall/favorite.dart';
import 'package:ccckmall/splash.dart';
import 'package:ccckmall/ui/articles_all.dart';
import 'package:ccckmall/ui/bible.dart';
import 'package:ccckmall/ui/live_tv.dart';
import 'package:ccckmall/ui/load_next_article.dart';
import 'package:ccckmall/ui/view_video.dart';
import 'package:ccckmall/values/category.dart';
import 'package:ccckmall/values/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
import 'helpers/helpers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'values/config.dart';

void main() => runApp(MyApp());


String apiURL() {
  String url = Config.get_category + Config.API_KEY;
  return url;
}

class NavigationIconView {
  final String _title;
  final IconData _icon;
  final IconData _activeIcon;
  final BottomNavigationBarItem item;

  NavigationIconView(
      {Key key, String title, IconData icon, IconData activeIcon})
      : _title = title,
        _icon = icon,
        _activeIcon = activeIcon,
        item = new BottomNavigationBarItem(
            icon: Icon(icon),
            activeIcon: Icon(activeIcon),
            title: Text(title),
            backgroundColor: Colors.white);
}


class HomePage extends StatefulWidget {
  final titles = ['Sermon', 'Videos', 'Bible', 'Pictures', 'Live Tv'];
  HomePage({Key key}) : super(key: key);

  @override
  HomeMain createState() {
    return new HomeMain();
  }
}

class HomeMain extends State<HomePage> with SingleTickerProviderStateMixin {
  PageController _pageController;
  List<Widget> _pages;
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  bool userPageDragging = false;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final List<Category> _cat = <Category>[];
  SharedPreferences prefs;
  bool loading = true;
  String data = "";
  String oldToken = '';
  String newToken = '';
  var resBody;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
    // Or do other work.
  }

  @override
  void initState() {
    super.initState();
    //getCategory();
    _navigationViews = [
      NavigationIconView(
          title: 'Sermon',
          icon: CupertinoIcons.book,
          activeIcon: CupertinoIcons.book_solid),
      NavigationIconView(
          title: 'Videos',
          icon: CupertinoIcons.video_camera,
          activeIcon: CupertinoIcons.video_camera_solid),
      NavigationIconView(
          title: 'Bible',
          icon: FontAwesomeIcons.bible,
          activeIcon: FontAwesomeIcons.bible),
      NavigationIconView(
          title: 'Photos',
          icon:  CupertinoIcons.photo_camera,
          activeIcon:  CupertinoIcons.photo_camera_solid),
      NavigationIconView(
          title: 'Live TV',
          icon: CupertinoIcons.play_arrow,
          activeIcon: CupertinoIcons.play_arrow_solid),
    ];
    _pageController = PageController(initialPage: _currentIndex);
    _pages = [
      ArticlesById(
        value: '19',
      ),
      ArticlesById(
        value: '20',
      ),
      Bible(),
      ArticlesById(
        value: '21',
      ),
      LiveTv()
    ];
    myBackgroundMessageHandler;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        if(Helpers.enableDebug) print('on message $message');
        try {
          if(message['data']['type'] == 'article'){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext contxt) => new VideoArticle(
                  idArticle: message['data']['id'],
                  titleArticle: message['data']['title'],
                  imageArticle: message['data']['image'],
                  createdArticle: message['data']['time'],
                  contentArticle: '',
                  categoryArticle: message['data']['category'],
                  commentArticle:message['data']['comment'] == true ? "true" : "false",
                  isVideo :  false,
                  video: '',

                )));
          }else{
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext contxt) => new VideoArticle(
                  idArticle: message['data']['id'],
                  titleArticle: message['data']['title'],
                  imageArticle: message['data']['image'],
                  createdArticle: message['data']['time'],
                  contentArticle: '',
                  categoryArticle: message['data']['category'],
                  commentArticle:message['data']['comment'] == true ? "true" : "false",
                  isVideo :  true,
                  video: message['data']['video'],
                )));
          }
        } catch (e) {
          print(e);
        }
      },
      onResume: (Map<String, dynamic> message) async{
        if(Helpers.enableDebug) print('on resume $message');
        try {
          if(message['data']['type'] == 'article'){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext contxt) => new VideoArticle(
                  idArticle: message['data']['id'],
                  titleArticle: message['data']['title'],
                  imageArticle: message['data']['image'],
                  createdArticle: message['data']['time'],
                  categoryArticle: message['data']['category'],
                  commentArticle:message['data']['comment'] == true ? "true" : "false",
                  isVideo :  false,
                  video: '',
                )));
          }else{
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext contxt) => new VideoArticle(
                  idArticle: message['data']['id'],
                  titleArticle: message['data']['title'],
                  imageArticle: message['data']['image'],
                  createdArticle: message['data']['time'],
                  categoryArticle: message['data']['category'],
                  commentArticle:message['data']['comment'] == true ? "true" : "false",
                  isVideo :  true,
                  video: message['data']['video'],
                )));
          }
        } catch (e) {
          print(e);
        }
      },
      onLaunch: (Map<String, dynamic> message) async{
        if(Helpers.enableDebug)  print('on launch $message');
        try {
          if(message['data']['type'] == 'article'){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext contxt) => new VideoArticle(
                  idArticle: message['data']['id'],
                  titleArticle: message['data']['title'],
                  imageArticle: message['data']['image'],
                  createdArticle: message['data']['time'],
                  categoryArticle: message['data']['category'],
                  commentArticle:message['data']['comment'] == true ? "true" : "false",
                  isVideo :  false,
                  video: '',
                )));
          }else{
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext contxt) => new VideoArticle(
                  idArticle: message['data']['id'],
                  titleArticle: message['data']['title'],
                  imageArticle: message['data']['image'],
                  createdArticle: message['data']['time'],
                  categoryArticle: message['data']['category'],
                  commentArticle:message['data']['comment'] == true ? "true" : "false",
                  isVideo :  true,
                  video: message['data']['video'],
                )));
          }
        } catch (e) {
          print(e);
        }
      },
    );

    _Notification(Map<String, dynamic> message){
      try {
        if(message['data']['type'] == 'article'){
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext contxt) => new VideoArticle(
                idArticle: message['data']['id'],
                titleArticle: message['data']['title'],
                imageArticle: message['data']['image'],
                createdArticle: message['data']['time'],
                contentArticle: '',
                categoryArticle: message['data']['category'],
                commentArticle:message['data']['comment'] == true ? "true" : "false",
                isVideo :  false,
                video: '',
              )));
        }else{
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext contxt) => new VideoArticle(
                idArticle: message['data']['id'],
                titleArticle: message['data']['title'],
                imageArticle: message['data']['image'],
                createdArticle: message['data']['time'],
                contentArticle: '',
                categoryArticle: message['data']['category'],
                commentArticle:message['data']['comment'] == true ? "true" : "false",
                isVideo :  true,
                video: message['data']['video'],
              )));
        }
      } catch (e) {
        print(e);
      }
    }

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        if (Helpers.enableDebug) print(token);
        newToken = token;
        tokenCheck();
      });
    });
    _firebaseMessaging.subscribeToTopic('global').then((value) {
      setState(() {
        if (Helpers.enableDebug) print('Subscribed');
      });
    });
  }

  getCategory() async {
    var res = await http
        .get(Uri.encodeFull(apiURL()), headers: {"Accept": "application/json"});
    resBody = jsonDecode(res.body);
    if (res == null || res.statusCode != 200)
      throw new Exception('HTTP request failed, statusCode: ${res?.statusCode}, $res');
    _cat.clear();
    for (var data in resBody) {
      _cat.add(new Category(
          data['id'],
          data['title'],
          data['description']));
    }
    if (this.mounted) {
      setState(() {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        if (Helpers.enableDebug) print("Loaded Data");
      });
    }
  }

  void tokenCheck() async {
    prefs = await SharedPreferences.getInstance();
    oldToken = prefs.getString('token');
    bool isRegistered = prefs.getBool('isRegistered')?? false ;
    if (isRegistered == null) isRegistered = false;
    if(!isRegistered && newToken.isNotEmpty){
      addTokenTOServer(newToken);
    }
    if (oldToken != newToken) {
      await prefs.setString('token', newToken);
      addTokenTOServer(newToken);
    }
  }

  Future<Null> addTokenTOServer(String token) async {
    prefs = await SharedPreferences.getInstance();
    var res = await http
        .get(Uri.encodeFull(Config.appURL + "device/"+token+"/"+Config.API_KEY)
        , headers: {"Accept": "application/json"});
    String responseBody = res.body;
    print('HTTP: ' + Config.appURL + "device/"+token+"/"+Config.API_KEY);
    var responseJSON = json.decode(responseBody);
    if (res.statusCode == 200) {
      if(Helpers.enableDebug) print('Token Saved. \nResponse Code : ${res.statusCode}');
      await prefs.setBool('isRegistered',true);
    } else {
      if(Helpers.enableDebug) print('Something went wrong. \nResponse Code : ${res.statusCode}');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    prefs.setBool('isFirst',false);
    super.dispose();
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    data = prefs.getString('name') ?? '';
    setState(() {});
  }

  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews.map((NavigationIconView view) {
        return view.item;
      }).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: const Color(Values.primaryColor),
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(_currentIndex);
          // _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        });
      },
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.titles[_currentIndex]),
          actions: <Widget>[
            CupertinoButton(
              child: Icon(Icons.favorite,color: CupertinoColors.white,),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Favorite()),
                );
              },
            )
          ],
        ),
        backgroundColor: Color(Values.backgroundColor),
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _pages[index];
        },
        controller: _pageController,
        itemCount: _pages.length,
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: botNavBar,
    );
    }
}
