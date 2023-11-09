import 'word.dart';

class Category {
  int _ID = -1;
  String _name = "";
  String _pictureSrc = "";
  int _isCompleted = 0;
  int _reward = 50;
  bool _isNew = true;
  bool _isDeleted = false;
  List<Word>? _words;

  Category(this._ID, this._name, this._pictureSrc, this._isCompleted,
      this._reward, this._isNew, this._isDeleted,
      [this._words]);

  Category.withoutSettings([
    this._name = "",
    this._pictureSrc = "",
    this._isCompleted = 0,
    this._reward = 50,
    this._isDeleted = false,
    this._isNew = true,
  ]);

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        json["ID"],
        json["Name"],
        json["PictureSrc"],
        json["isCompleted"],
        json["Reward"],
        json["IsNew"] == 1,
        json["IsDeleted"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "Name": _name,
        "PictureSrc": _pictureSrc,
        "isCompleted": _isCompleted,
        "Reward": _reward,
        "IsNew": _isNew ? 1 : 0,
        "IsDeleted": _isDeleted ? 1 : 0,
      };

  int get ID => _ID;

  set ID(int value) {
    _ID = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get pictureSrc => _pictureSrc;

  set pictureSrc(String value) {
    _pictureSrc = value;
  }

  int get isCompleted => _isCompleted;

  set isCompleted(int value) {
    _isCompleted = value;
  }

  int get reward => _reward;

  set reward(int value) {
    _reward = value;
  }

  List<Word> get words => _words ?? [];

  set words(List<Word> value) {
    _words = value;
  }

  bool get isNew => _isNew;

  set isNew(bool value) => _isNew = value;

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) => _isDeleted = value;
}
