import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class RadioCard extends StatelessWidget {
  final String id, url, name, frequency, pic;

  RadioCard({
    this.id,
    this.url,
    this.name,
    this.frequency,
    this.pic,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
      },
      child: Card(
        elevation: 4.0,
        child: new Container(
            padding: new EdgeInsets.all(12.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: new AdvancedNetworkImage(
                            this.pic,
                            useDiskCache: true,retryLimit: 10,
                            cacheRule:
                                CacheRule(maxAge: const Duration(days: 10)),
                            fallbackAssetImage: 'images/donate.jpg',
                          ),
                          fit: BoxFit.fill)),
                ),
                new Expanded(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        name,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      margin: EdgeInsets.only(bottom: 14.0, top: 14),
                    ),
                    new Text(name, style: TextStyle(fontSize: 14)),
                    new Visibility(
                      child: new Text(id),
                      visible: false,
                    )
                  ],
                ))
              ],
            )
        ),
      ),
    );
  }
}
