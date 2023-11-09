class Game {
  int _gameID = -1;
  String _name = "";
  int _type = -1;
  int _reward = 50;
  String _pictureSrc = "";

  get reward => this._reward;

  set reward(value) => this._reward = value;

  String get pictureSrc => this._pictureSrc;

  set pictureSrc(String value) => this._pictureSrc = value;

  get type => this._type;

  set type(value) => this._type = value;

  String get name => this._name;

  set name(String value) => this._name = value;

  int get gameID => this._gameID;

  set gameID(int value) => this._gameID = value;

  Game(
    this._gameID,
    this._name,
    this._reward,
  );

  Game.fromJson(dynamic json) {
    _gameID = json['GameID'];
    _type = json['Type'];
    _name = json['Name'];
    _reward = json['Reward'];
    _pictureSrc = json['PictureSrc'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    map['Reward'] = _reward;
    map['Type'] = _type;
    map['PictureSrc'] = _pictureSrc;
    return map;
  }
}
