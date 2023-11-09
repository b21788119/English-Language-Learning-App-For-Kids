class Pronunciation {
  int _ID = -1;
  int _wordID = -1;
  int _categoryID = -1;
  double _score = -1;
  DateTime _date = DateTime.now().toUtc();

  Pronunciation(
    this._ID,
    this._wordID,
    this._categoryID,
    this._score,
    this._date,
  );
  Pronunciation.withoutID(
    this._wordID,
    this._categoryID,
    this._score,
    this._date,
  );

  Pronunciation.fromJson(dynamic json) {
    _ID = json['ID'];
    _wordID = json['WordID'];
    _categoryID = json['CategoryID'];
    _score = json['Score'];
    _date = DateTime.parse(json['Date']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['WordID'] = _wordID;
    map['CategoryID'] = _categoryID;
    map['Score'] = _score;
    map['Date'] = _date.toIso8601String();

    return map;
  }

  int get ID => this._ID;
  set ID(int value) => this._ID = value;

  int get wordID => this._wordID;
  set wordID(int value) => this._wordID = value;

  int get categoryID => this._categoryID;
  set categoryID(int value) => this._categoryID = value;

  double get score => this._score;
  set score(double value) => this._score = value;

  DateTime get date => this._date;
  set date(DateTime value) => this._date = value;
}
