// lib/models/collection_model.dart
class CollectionModel {
  final int id;
  final String handle;
  final String title;
  final String updatedAt;
  final String? bodyHtml;
  final String? publishedAt;
  final String sortOrder;
  final String templateSuffix;
  final String publishedScope;
  final String adminGraphqlApiId;
  final ImageModel? image;

  CollectionModel({
    required this.id,
    required this.handle,
    required this.title,
    required this.updatedAt,
    this.bodyHtml,
    this.publishedAt,
    required this.sortOrder,
    required this.templateSuffix,
    required this.publishedScope,
    required this.adminGraphqlApiId,
    this.image,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] as int,
      handle: json['handle'] as String,
      title: json['title'] as String,
      updatedAt: json['updated_at'] as String,
      bodyHtml: json['body_html'] as String?,
      publishedAt: json['published_at'] as String?,
      sortOrder: json['sort_order'] as String,
      templateSuffix: json['template_suffix'] as String,
      publishedScope: json['published_scope'] as String,
      adminGraphqlApiId: json['admin_graphql_api_id'] as String,
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handle': handle,
      'title': title,
      'updated_at': updatedAt,
      'body_html': bodyHtml,
      'published_at': publishedAt,
      'sort_order': sortOrder,
      'template_suffix': templateSuffix,
      'published_scope': publishedScope,
      'admin_graphql_api_id': adminGraphqlApiId,
      'image': image?.toJson(),
    };
  }
}

class ImageModel {
  final String createdAt;
  final String? alt;
  final int width;
  final int height;
  final String src;

  ImageModel({
    required this.createdAt,
    this.alt,
    required this.width,
    required this.height,
    required this.src,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      createdAt: json['created_at'] as String,
      alt: json['alt'] as String?,
      width: json['width'] as int,
      height: json['height'] as int,
      src: json['src'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'alt': alt,
      'width': width,
      'height': height,
      'src': src,
    };
  }
}
