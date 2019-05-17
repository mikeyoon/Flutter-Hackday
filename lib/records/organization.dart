class Organization {
  final String token;
  final int id;
  final String name;
  final String username;
  final int spaceCount;

  final Map<String, dynamic> forms;
  final Map<String, dynamic> links;

  Organization.fromJson(Map<String, dynamic> json)
    : token = json['token'],
      id = json['id'],
      name = json['name'],
      username = json['username'],
      spaceCount = json['space_count'],

      forms = json['_forms'],
      links = json['_links'];
}