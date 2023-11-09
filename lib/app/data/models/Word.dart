class Word {
  int _wordID = -1;
  String _name = "";
  String _pictureSrc = "";
  String _audioSrc = "";
  int _isPronounced = 0;
  int _pronunciationScore = -1;
  int _reward = 50;
  int _moduleID = -1;
  bool _isNew = true;
  bool _isDeleted = false;

  Word(
    this._wordID,
    this._name,
    this._pictureSrc,
    this._audioSrc,
    this._isPronounced,
    this._pronunciationScore,
    this._reward,
    this._moduleID,
    this._isNew,
    this._isDeleted,
  );
  Word.withoutID(
    this._name,
    this._pictureSrc,
    this._audioSrc,
    this._isPronounced,
    this._pronunciationScore,
    this._reward,
    this._moduleID,
    this._isNew,
    this._isDeleted,
  );
  Word.fromJson(dynamic json) {
    _wordID = json['wordID'];
    _name = json['Name'];
    _pictureSrc = json['PictureSrc'];
    _audioSrc = json['AudioSrc'];
    _isPronounced = json['isPronounced'];
    _pronunciationScore = json['PronunciationScore'];
    _reward = json['Reward'];
    _moduleID = json['categoryID'];
    _isNew = json['IsNew'] == 1;
    _isDeleted = json['IsDeleted'] == 1;
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    map['PictureSrc'] = _pictureSrc;
    map['AudioSrc'] = _audioSrc;
    map['isPronounced'] = _isPronounced;
    map['PronunciationScore'] = _pronunciationScore;
    map['Reward'] = _reward;
    map['categoryID'] = _moduleID;
    map['IsNew'] = _isNew ? 1 : 0;
    map['IsDeleted'] = _isDeleted ? 1 : 0;
    return map;
  }

  int get wordID => _wordID;

  set wordID(int value) {
    _wordID = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get pictureSrc => _pictureSrc;

  set pictureSrc(String value) {
    _pictureSrc = value;
  }

  String get audioSrc => _audioSrc;

  set audioSrc(String value) {
    _audioSrc = value;
  }

  int get isPronounced => _isPronounced;

  set isPronounced(int value) {
    _isPronounced = value;
  }

  int get pronunciationScore => _pronunciationScore;

  set pronunciationScore(int value) {
    _pronunciationScore = value;
  }

  int get reward => _reward;

  set reward(int value) {
    _reward = value;
  }

  int get moduleID => _moduleID;

  set moduleID(int value) {
    _moduleID = value;
  }

  bool get isNew => _isNew;

  set isNew(bool value) => _isNew = value;

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) => _isDeleted = value;
}
