import 'package:ccckmall/ui/view_video.dart';
import 'package:ccckmall/values/colors.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class ArticleCard extends StatelessWidget {
  final int id;
  final String title;
  final String category;
  final String short;
  final String content;
  final String video;
  final bool comment;
  final String image;
  final String created;
  final String type;

  ArticleCard(
      {this.id,
      this.title,
      this.category,
      this.short,
      this.content,
      this.video,
      this.comment,
      this.image,
      this.created,
      this.type});

  @override
  Widget build(BuildContext context) {
    /*navigate() {
      final route = MaterialPageRoute(builder: (_) => this.page);
      Navigator.of(context).push(route);
    }
*/
    Widget _buildBody() {
      return new Container(

            child: Stack(
              children: <Widget>[
                FadeInImage(
                  width: MediaQuery.of(context).size.width,
                  placeholder: new AssetImage("images/placeholder.png"),
                  image: AdvancedNetworkImage(
                    this.image,
                    useDiskCache: true,
                    retryLimit: 10,
                    cacheRule: CacheRule(maxAge: const Duration(days: 10)),
                    fallbackAssetImage: 'images/placeholder.png',
                  ),
                  fit: BoxFit.fill,
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
                      visible: this.type == 'video' ? true : false,
                    )),
              ],
            ),
      );
    }

    Widget viewIcon = new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(Icons.bookmark_border,
              color: Theme.of(context).primaryColor),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
            child: FlatButton(
              padding: EdgeInsets.all(10),
          color: Color(Values.cardBackground),
          child:   Container(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  child: FadeInImage(
                    width: 50,
                    height: 50,
                    placeholder: new AssetImage("images/placeholder.png"),
                    image: AdvancedNetworkImage(
                      this.image,
                      useDiskCache: true,
                      retryLimit: 10,
                      cacheRule: CacheRule(maxAge: const Duration(days: 10)),
                      fallbackAssetImage: 'images/placeholder.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                SizedBox(width: 10),
                Flexible(
                    fit: FlexFit.tight,
                    child: new Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  this.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    1.0, 0.0, 0.0, 5.0),
                              ),
                            )
                            ,
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(this.created,
                                style: TextStyle(
                                    color: Color(Values.greyColor),
                                    fontSize: 11.0,
                                    fontStyle: FontStyle.normal),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(top: 3),
                                child: Text(this.category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12),
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    1.0, 0.0, 0.0, 0.0),
                              ),
                            ),
                            Visibility(
                                visible: this.type == 'video' ? true : false,
                              child: Container(
                                  child: Icon(Icons.play_arrow,
                                      size: 18, color: Theme.of(context).accentColor),
                               ),
                            )
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ), onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext contxt) => new VideoArticle(
                idArticle: this.id.toString(),
                titleArticle: this.title,
                imageArticle: image,
                createdArticle: created,
                contentArticle: content,
                categoryArticle: category,
                commentArticle:this.comment == true ? "true" : "false",
                isVideo : this.type == 'video' ? true : false,
                video: this.video ?? '',
              )));
        },
        ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );/*Card(
          elevation: 5.0,
          child: GestureDetector(
              onTap: () { Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext contxt) => new VideoArticle(
                            idArticle: this.id.toString(),
                            titleArticle: this.title,
                            imageArticle: image,
                            createdArticle: created,
                            contentArticle: content,
                            categoryArticle: category,
                            commentArticle:this.comment == true ? "true" : "false",
                            isVideo : this.type == 'video' ? true : false,
                            video: this.video ?? '',
                          )));
              },
              child: ListT
              ),
        );*/
      },
    );
  }
}
