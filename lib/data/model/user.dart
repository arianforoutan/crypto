class User {
  String name;
  String username;
  String city;
  String phone;
  int id;

  User(this.name, this.username, this.city, this.phone, this.id);

  factory User.fromMapJson(Map<String, dynamic> jsonObject) {
    return User(
      jsonObject['name'],
      jsonObject['username'],
      jsonObject['address']['city'],
      jsonObject['phone'],
      jsonObject['id'],
    );
  }
}
