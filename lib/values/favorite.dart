class Favorite {
  String _id;
  String _aid;
  String _content;
 
  Favorite(this._aid, this._content);
 
  Favorite.map(dynamic obj) {
    this._id = obj['id'];
    this._content = obj['content'];
  }
 
  String get id => _id;
  String get title => _aid;
  String get description => _content;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['aid'] = _aid;
    map['content'] = _content;
 
    return map;
  }
 
  Favorite.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._aid = map['aid'];
    this._content = map['content'];
  }

   void setFavoriteId(String id) {
    this._id = _id;
  }
}