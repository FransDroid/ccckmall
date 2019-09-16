import 'dart:convert';
import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/values/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;


class LiveTv extends StatefulWidget {
  @override
  _LiveTvState createState() => _LiveTvState();
}

class _LiveTvState extends State<LiveTv> {
  bool isData = false;
  String id, tvUrl, status;

  getTV() async {
    isData = true;
    var res = await http.get(Uri.encodeFull(Config.tv_url),
        headers: {"Accept": "application/json"});
    if (res.statusCode == 200) {
      String responseBody = res.body;
      var responseJSON =
      json.decode(responseBody);
      id = responseJSON['id'];
      tvUrl = responseJSON['tv_url'];
      status = responseJSON['status'];

      setState(() {
        if (Helpers.enableDebug) print('UI Updated:' + responseBody);
        isData = false;
      });
    } else {
      if (Helpers.enableDebug)
        print('Something went wrong. \nResponse Code : ${res.statusCode}');
    }
  }

  @override
  void initState() {
    getTV();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _body(context)
    );
  }

  _youtubeVideoId(String url){
    String videoId;
    try{
      videoId = YoutubePlayer.convertUrlToId(url);
      return videoId;
    }
    catch(Exception){
    }
  }

  Widget _body(BuildContext context) {
    if (isData) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return Container(
          height: MediaQuery.of(context).size.height,
          child: YoutubePlayer(
            context: context,
            videoId: _youtubeVideoId(tvUrl),
            flags: YoutubePlayerFlags(
                isLive: true
            ),
            liveUIColor: Colors.red,
          )
      );
    }
  }
}
