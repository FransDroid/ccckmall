class Category {
  int _id;
  String _title, _description;
  Category(this._id, this._title, this._description);

   Category.map(dynamic obj) {
     this._id = obj['id'];
     this._title = obj['title'];
     this._description = obj['description'];
   }

   int get id => _id;
   String get title => _title;
   String get description => _description;
   Map<String, dynamic> toMap() {
     var map = new Map<String, dynamic>();
     if (_id != null) {
       map['id'] = _id;
     }
     map['title'] = _title;
     map['description'] = _description;

     return map;
   }

   Category.fromMap(Map<String, dynamic> map) {
     this._id = map['id'];
     this._title = map['title'];
     this._description = map['description'];
   }

   void setFavoriteId(String id) {
     this._id = _id;
   }
}
