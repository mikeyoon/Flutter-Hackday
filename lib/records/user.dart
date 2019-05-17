class User {
  final String token;
  final int id;
  final String name;
  final String username;
  final String email;
  final String spaceCount;

  final Map<String, dynamic> forms;
  final Map<String, dynamic> links;

  User.fromJson(Map<String, dynamic> json)
    : token = json['token'],
      id = json['id'],
      name = json['name'],
      username = json['username'],
      email = json['email'],
      spaceCount = json['space_count'],

      forms = json['_forms'],
      links = json['_links'];
}