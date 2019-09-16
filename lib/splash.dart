import 'package:ccckmall/values/colors.dart';
import 'package:ccckmall/values/config.dart';
import 'package:ccckmall/values/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

String apiURL() {
  String url = Config.get_category + Config.API_KEY;
  return url;
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Values.app_name,
      theme: new ThemeData(
        primaryColorDark: const Color(0xFF2f3897),
        primaryColor: const Color(0xFFb82979),
        accentColor: const Color(0xFF2f3897),
      ),
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    loadData();
    //getCategory();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/splash.jpg'), fit: BoxFit.cover),
    ));
  }
}
