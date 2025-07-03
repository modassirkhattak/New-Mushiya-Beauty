class BlogModel {
  final int id;
  final String handle;
  final String title;
  final DateTime updatedAt;
  final String commentable;
  final String? feedburner;
  final String? feedburnerLocation;
  final DateTime createdAt;
  final String? templateSuffix;
  final String tags;
  final String adminGraphqlApiId;

  BlogModel({
    required this.id,
    required this.handle,
    required this.title,
    required this.updatedAt,
    required this.commentable,
    this.feedburner,
    this.feedburnerLocation,
    required this.createdAt,
    this.templateSuffix,
    required this.tags,
    required this.adminGraphqlApiId,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      handle: json['handle'],
      title: json['title'],
      updatedAt: DateTime.parse(json['updated_at']),
      commentable: json['commentable'],
      feedburner: json['feedburner'],
      feedburnerLocation: json['feedburner_location'],
      createdAt: DateTime.parse(json['created_at']),
      templateSuffix: json['template_suffix'],
      tags: json['tags'] ?? '',
      adminGraphqlApiId: json['admin_graphql_api_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handle': handle,
      'title': title,
      'updated_at': updatedAt.toIso8601String(),
      'commentable': commentable,
      'feedburner': feedburner,
      'feedburner_location': feedburnerLocation,
      'created_at': createdAt.toIso8601String(),
      'template_suffix': templateSuffix,
      'tags': tags,
      'admin_graphql_api_id': adminGraphqlApiId,
    };
  }
}
