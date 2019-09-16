class BibleChapter {
  int _id;

  BibleChapter(this._id);

  BibleChapter.map(dynamic obj) {
    this._id = obj['c'];
  }

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['c'] = _id;
    }

    return map;
  }

  BibleChapter.fromMap(Map<String, dynamic> map) {
    this._id = map['c'];
  }
}