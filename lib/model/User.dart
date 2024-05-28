class User {
  final int? id;
  final String? name;
  final String? auth;
  final int? weight;
  final int? calories;

  User({this.id, this.name, this.auth, this.weight, this.calories});

  factory User.formJson(Map<String, dynamic> json) {
    return User(
      id: json['id_local'],
      name: json['name'].toString(),
      auth: json['auth'].toString(),
      weight: json['weight'],
      calories: json['calories'],
    );
  }
  static List<User> UserFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return User.formJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'User {id = $id},{name = $name},{auth = $auth},{weight = $weight},{calories = $calories}';
  }

  static List<User> UsersDetailsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return User.formJson(data);
    }).toList();
  }
}
