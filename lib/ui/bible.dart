import 'package:ccckmall/helpers/bibledb_helper.dart';
import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/values/bible_book.dart';
import 'package:ccckmall/values/bible_cahpter.dart';
import 'package:ccckmall/values/bible_name.dart';
import 'package:ccckmall/widgets/card_bible.dart';
import 'package:flutter/material.dart';

class Bible extends StatefulWidget {
  @override
  _BibleState createState() => _BibleState();
}

class _BibleState extends State<Bible> {
  final List<BibleCard> _bverse = <BibleCard>[];
  final List<BibleName> _bname = <BibleName>[];
  final List<BibleBook> _bbook = <BibleBook>[];
  final List<BibleChapter> _bchapters = <BibleChapter>[];
  List<DropdownMenuItem<BibleName>> _dropdownMenuItems;
  BibleName _selectedName;
  List<DropdownMenuItem<BibleBook>> _dropdownMenuItemsBooks;
  BibleBook _selectedBook;
  List<DropdownMenuItem<BibleChapter>> _dropdownMenuItemsChapters;
  BibleChapter _selectedChapter;
  bool loading = true;
  String bible = 't_kjv';
  int book = 1;
  int chapter = 1;
  var db = new BibleDatabaseHelper();
  List bList;
  var data;

  getBible() {
    _bname.clear();
    db.getAllBook().then((list) {
      setState(() {
        for (var list in list) {
          _bname.add((new BibleName(list['b'], list['n'])));
        }
        //loading = false;
        if (Helpers.enableDebug) print("Loaded");
        _dropdownMenuItems = buildDropdownMenuItems(_bname);
        _selectedName = _dropdownMenuItems[0].value;
        getBooksChapters(bible,book);
      });
    });
  }

  getBooks() {
    _bbook.clear();
    db.getAllBibles().then((list) {
      setState(() {
        for (var list in list) {
          _bbook.add((new BibleBook(list['id'], list['table'],list['abbreviation'], list['version'])));
        }
        //loading = false;
        if (Helpers.enableDebug) print("Loaded");
        _dropdownMenuItemsBooks = buildDropdownMenuItemsBook(_bbook);
        _selectedBook = _dropdownMenuItemsBooks[1].value;
        //getBibleVerse(bible,chapter,book);
      });
    });
  }

  getBooksChapters(String b,int bk) {
    _bchapters.clear();
    db.getAllBookChapters(b,bk).then((list) {
      setState(() {
        for (var list in list) {
          _bchapters.add((new BibleChapter(list['c'])));
        }
        //loading = false;
        if (Helpers.enableDebug) print("Loaded");
        _dropdownMenuItemsChapters = buildDropdownMenuItemsChapter(_bchapters);
        _selectedChapter = _dropdownMenuItemsChapters[0].value;
        getBibleVerse(bible,chapter,book);
      });
    });
  }

  getBibleVerse(String bible,int chapter,int book) {
    _bverse.clear();
    db.getAllBibleVerse(bible,chapter,book).then((list) {
      setState(() {
        for (var list in list) {
          _bverse.add((new BibleCard(list['id'], list['b'],list['c'], list['v'],list['t'])));
        }
        loading = false;
        if (Helpers.enableDebug) print("Loaded");
      });
    });
  }

  List<DropdownMenuItem<BibleName>> buildDropdownMenuItems(List books) {
    List<DropdownMenuItem<BibleName>> items = List();
    for (BibleName bible in books) {
      items.add(
        DropdownMenuItem(
          value: bible,
          child: Text(bible.title),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<BibleBook>> buildDropdownMenuItemsBook(List books) {
    List<DropdownMenuItem<BibleBook>> items = List();
    for (BibleBook bible in books) {
      items.add(
        DropdownMenuItem(
          value: bible,
          child: Text(bible.abb),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<BibleChapter>> buildDropdownMenuItemsChapter(List books) {
    List<DropdownMenuItem<BibleChapter>> items = List();
    for (BibleChapter bible in books) {
      items.add(
        DropdownMenuItem(
          value: bible,
          child: Text(bible.id.toString()),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    getBooks();
    getBible();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onChangeDropdownItem(BibleName selectedBook) {
    setState(() {
      _selectedName = selectedBook;
      book = selectedBook.id;
      getBibleVerse(bible,chapter,book);
    });
  }

  onChangeDropdownItemBook(BibleBook selectedBible) {
    setState(() {
      _selectedBook = selectedBible;
      bible = selectedBible.table;
      getBibleVerse(bible,chapter,book);
    });
  }
  onChangeDropdownItemChapter(BibleChapter selectedChapter) {
    setState(() {
      _selectedChapter = selectedChapter;
      chapter = selectedChapter.id;
      getBibleVerse(bible,chapter,book);
    });
  }

  Widget _body(BuildContext context) {
    return loading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : new Center(
      child: new Column(
        children: <Widget>[
          new Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton(
                  value: _selectedBook,
                  items: _dropdownMenuItemsBooks,
                  onChanged: onChangeDropdownItemBook,
                ),
                SizedBox(width: 10,),
                DropdownButton(
                  value: _selectedName,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
                SizedBox(width: 10,),
                DropdownButton(
                  value: _selectedChapter,
                  items: _dropdownMenuItemsChapters,
                  onChanged: onChangeDropdownItemChapter,
                ),
              ],
            )
          ),
          Divider(color: Colors.grey,height: 0.5,),
           new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemBuilder: (_, int index) => _bverse[index],
                itemCount: _bverse.length,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context)
    );
  }
}
