class BibleBook {
  int _id;
  String _table;
  String _abb;
  String _version;

  BibleBook(this._id, this._table,this._abb, this._version);

  BibleBook.map(dynamic obj) {
    this._id = obj['id'];
    this._table = obj['table'];
    this._abb = obj['abbreviation'];
    this._version = obj['version'];
  }

  int get id => _id;
  String get table => _table;
  String get abb => _abb;
  String get version => _version;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['table'] = _table;
    map['abbreviation'] = _abb;
    map['version'] = _version;

    return map;
  }

  BibleBook.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._table = map['table'];
    this._abb = map['abbreviation'];
    this._version = map['version'];
  }
}