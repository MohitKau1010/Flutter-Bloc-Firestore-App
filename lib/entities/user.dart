class User{
  static final String tableName = 'user';
  static String columnId = 'id';
  static String columnEmailName = 'email';
  static String columnTokenName = 'token';

  int id;
  String email, token;

  ///constructure
  User({this.token, this.email});

  ///toMap  <--- is used for putting the value from DB.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnEmailName: email,
      columnTokenName: token,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }


  ///fromMap  <--- is used for getting the value from DB.
  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    email = map[columnEmailName];
    token = map[columnTokenName];
  }

  /// for return value
  @override
  String toString() {
    return "{id: $id, Token: $token, email: $email}";
  }
}