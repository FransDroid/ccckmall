import 'package:ccckmall/values/colors.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String author, content, created;
  final bool enabled;

  CommentCard({this.author, this.content, this.created, this.enabled});

  @override
  Widget build(BuildContext context) {
    return new  Card(
        elevation: 4.0,
        child: new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(right: 15.0),
                    child: new CircleAvatar(
                      child: new Text(author[0]),
                    )),
                new Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          child: new Text(
                            author,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w700),
                          ),
                          margin: EdgeInsets.only(bottom: 2.0,top: 2),
                        ),
                        new Text(content,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 11.0, fontWeight: FontWeight.w400))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: new Text(created,textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: Color(Values.primaryColor))))
              ],
            )),
      );
  }
}
