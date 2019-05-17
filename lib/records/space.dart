class Space {
  final String token;
  final int id;
  final String name;
  final String description;
  final String state;
  final String type;
  final bool restricted;

  final Map<String, dynamic> forms;
  final Map<String, dynamic> links;

  Space.fromJson(Map<String, dynamic> json)
    : token = json['token'],
      id = json['id'],
      name = json['name'],
      description = json['description'],
      state = json['state'],
      type = json['space_type'],
      restricted = json['restricted'],
      forms = json['_forms'],
      links = json['_links'];
}