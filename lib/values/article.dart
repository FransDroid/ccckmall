class Article {
  String _id;
  String _content;
  String _cid;

  Article(this._id,this._content,this._cid);

  Article.map(dynamic obj) {
    this._id = obj['id'];
    this._content = obj['content'];
    this._cid = obj['cid'];
  }

  String get id => _id;
  String get description => _content;
  String get category => _cid;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['content'] = _content;
    map['cid'] = _cid;

    return map;
  }

  Article.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._content = map['content'];
    this._cid = map['cid'];
  }

  void setFavoriteId(String id) {
    this._id = _id;
  }
}