import 'package:ccckmall/values/colors.dart';
import 'package:flutter/material.dart';

class BibleCard extends StatelessWidget{
  final int id;
  final int b;
  final int c;
  final int v;
  final String t;

  BibleCard(this.id, this.b, this.c, this.v, this.t);

  @override
  Widget build(BuildContext context) {
    Widget body = new Container(
      color: new Color(0X00FFFFFF0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SelectableText.rich(
                     TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children:<TextSpan> [
                        TextSpan(text: 'Chapter '+ this.c.toString() + '  Verse ' + this.v.toString(),style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w800,fontSize: 14,fontStyle: FontStyle.italic)),
                        TextSpan(text: '\n'),
                        TextSpan(text: this.t.toString(),style: TextStyle(fontSize: 16)),
                      ]
                    ),
                  ),
                ),
                //new Expanded(child: viewIcon),
              ],
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: GestureDetector(
              child: body),
        );
      },
    );
  }
}