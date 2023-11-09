class User {
  int _userID = -1;
  String _name = "";
  String _surname = "";
  int _age = -1;
  int _coin = -1;

  User(
    this._userID,
    this._name,
    this._surname,
    this._age,
    this._coin,
  );

  User.fromJson(dynamic json) {
    _userID = json['UserID'];
    _name = json['Name'];
    _surname = json['Surname'];
    _age = json['Age'];
    _coin = json['Coin'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    map['Surname'] = _surname;
    map['Age'] = _age;
    map['Coin'] = _coin;
    return map;
  }

  int get userID => this._userID;

  set userID(int value) => this._userID = value;

  String get name => this._name;

  set name(String value) => this._name = value;

  String get surname => this._surname;

  set surname(String value) => this._surname = value;

  int get age => this._age;

  set age(int value) => this._age = value;

  int get coin => this._coin;

  set coin(int value) => this._coin = value;
}
