class BibleName {
   int _id;
   String _title;

  BibleName(this._id, this._title);

  BibleName.map(dynamic obj) {
    this._id = obj['b'];
    this._title = obj['n'];
  }

  int get id => _id;
  String get title => _title;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['b'] = _id;
    }
    map['n'] = _title;

    return map;
  }

   BibleName.fromMap(Map<String, dynamic> map) {
    this._id = map['b'];
    this._title = map['n'];
  }
}