class BibleVerse {
   int _id;
   int _book;
   int _chapter;
   int _verse;
   String _text;

  BibleVerse(this._id, this._book, this._chapter, this._verse, this._text);

  BibleVerse.map(dynamic obj) {
    this._id = obj['id'];
    this._book = obj['b'];
    this._chapter = obj['c'];
    this._verse = obj['v'];
    this._text = obj['t'];
  }

  int get id => _id;
  int get book => _book;
  int get chapter => _chapter;
  int get verse => _verse;
  String get text => _text;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['b'] = _book;
    map['c'] = _chapter;
    map['v'] = _verse;
    map['t'] = _text;

    return map;
  }

   BibleVerse.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._book = map['b'];
    this._chapter = map['c'];
    this._verse = map['v'];
    this._text = map['t'];
  }
}