import 'package:ccckmall/ui/view_video.dart';
import 'package:ccckmall/values/colors.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class FavoriteCard extends StatelessWidget {
  final String id;
  final String views;
  final String likes;
  final String title;
  final String image;
  final String created;
  final String content;
  final String category;
  final String comment;
  final String video;
  final String type;

  const FavoriteCard({ this.id, this.views, this.likes, this.title, this.image, this.created, this.content, this.category, this.comment, this.video, this.type});


  @override
  Widget build(BuildContext context) {
    /*navigate() {
      final route = MaterialPageRoute(builder: (_) => this.page);
      Navigator.of(context).push(route);
    }
*/
    Widget _buildBody() {
      return new Container(
          constraints: new BoxConstraints(),
          child: new Stack(
            children: <Widget>[
              FadeInImage(
                width: MediaQuery.of(context).size.width,
                placeholder: new AssetImage("images/placeholder.png"),
                image: AdvancedNetworkImage(
                  this.image,
                  useDiskCache: true,retryLimit: 10,
                  cacheRule: CacheRule(maxAge: const Duration(days: 10)),
                  fallbackAssetImage: 'images/placeholder.png',
                ),
                fit: BoxFit.cover,
              ),
              new Positioned(
                left: 10.0,
                top: 5.0,
                child: new Container(
                    child: Text(this.category,
                        style: new TextStyle(
                          color: const Color(Values.textColor),
                          fontSize: 14.0,
                        )),
                    color: const Color(Values.transparentColor),
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.center),
              ),
              new Positioned(
                right: 10.0,
                top: 5.0,
                child: new Container(
                    child: Text(this.created,
                        style: new TextStyle(
                          color: const Color(Values.textColor),
                          fontSize: 14.0,
                        )),
                    color: const Color(Values.transparentColor),
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.center),
              ),
              new Positioned(
                  right: 10.0,
                  bottom: 5.0,
                  child: new Visibility(
                    child: Icon(Icons.play_arrow,
                        size: 64, color: Theme.of(context).accentColor),
                    visible: this.type == 'article' ? false : true,
                  )),
            ],
          ));
    }

    Widget viewIcon = new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(Icons.bookmark, color: Theme.of(context).primaryColor),
        ],
      ),
    );
    Widget body = new Container(
      color: new Color(0X00FFFFFF0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildBody(),
          Container(
            padding: EdgeInsets.all(10),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(this.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                ),
                //new Expanded(child: viewIcon),
              ],
            ),
          )
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 5.0,
          child: GestureDetector(
              onTap: () {Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext contxt) => new VideoArticle(
                            idArticle: this.id.toString(),
                            titleArticle: this.title,
                            imageArticle: image,
                            createdArticle: created,
                            contentArticle: content,
                            categoryArticle: category,
                            commentArticle:this.comment == 'true' ? "true" : "false",
                            isVideo : this.type == 'video' ? true : false,
                            video: this.video ?? '',
                          )));
              },
              child: body),
        );
      },
    );
  }
}
