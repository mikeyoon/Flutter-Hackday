class Report {
  final String token;
  final int id;
  final String _name;
  final String description;
  final DateTime createdDate;
  final DateTime modifiedDate;
  final DateTime lastRunDate;
  final DateTime lastSuccessRunDate;
  final bool shared;
  final int queryCount;
  final int chartCount;
  final int schedulesCount;
  final bool manualRunDisabled;
  final String webPreviewImage;

  get name => _name != null ? _name : 'Untitled Report';

  final Map<String, dynamic> forms;
  final Map<String, dynamic> links;

  Report.fromJson(Map<String, dynamic> json)
    : token = json['token'],
      id = json['id'],
      _name = json['name'],
      description = json['description'],
      createdDate = DateTime.parse(json['created_at']),
      modifiedDate = DateTime.parse(json['edited_at']),
      lastRunDate = DateTime.parse(json['last_run_at']),
      lastSuccessRunDate = DateTime.parse(json['last_successfully_run_at']),
      shared = json['shared'],
      queryCount = json['query_count'],
      chartCount = json['chart_count'],
      schedulesCount = json['schedules_count'],
      manualRunDisabled = json['manual_run_disabled'],
      webPreviewImage = json['web_preview_image'],
      forms = json['_forms'],
      links = json['_links'];
}