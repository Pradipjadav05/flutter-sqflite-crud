class User {
  int _id = 0;
  String _username = "";
  String _password = "";

  User(
    this._id,
    this._username,
    this._password,
  );

  User.map(dynamic obj) {
    _username = obj["username"];
    _password = obj["password"];
    _id = obj["id"];
  }

  String get userName => _username;
  String get password => _password;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["username"] = _username;
    map["password"] = _password;

    // ignore: unnecessary_null_comparison
    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    _username = map["username"];
    _password = map["password"];
    _id = map["id"];
  }
}
