// lib/models/product_model.dart
class CollectionSubProductModel {
  final String id;
  final String title;
  final  tags;
  final String handle;
  final  created_at;
  final String descriptionHtml;
  final String? imageSrc;
  final String variantId;
  final String variantTitle;
  final String variantPrice;

  CollectionSubProductModel({
    required this.id,
    required this.title,
    required this.created_at,
    required this.handle,
    required this.descriptionHtml,
    required this.tags,
    this.imageSrc,
    required this.variantId,
    required this.variantTitle,
    required this.variantPrice,
  });

  factory CollectionSubProductModel.fromJson(Map<String, dynamic> json) {
    final imageEdges = json['images']['edges'] as List<dynamic>;
    final variantEdges = json['variants']['edges'] as List<dynamic>;
    return CollectionSubProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      handle: json['handle'] as String,
      created_at: json['created_at'] ?? '',
      tags: json['tags'] ?? '',
      descriptionHtml: json['descriptionHtml'] as String,
      imageSrc:
          imageEdges.isNotEmpty
              ? imageEdges[0]['node']['src'] as String?
              : null,
      variantId:
          variantEdges.isNotEmpty
              ? variantEdges[0]['node']['id'] as String
              : '',
      variantTitle:
          variantEdges.isNotEmpty
              ? variantEdges[0]['node']['title'] as String
              : '',
      variantPrice:
          variantEdges.isNotEmpty
              ? variantEdges[0]['node']['price'] as String
              : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      // 'tags': tags,
      'created_at': created_at,
      'descriptionHtml': descriptionHtml,
      'images': {
        'edges': [
          if (imageSrc != null)
            {
              'node': {'src': imageSrc},
            },
        ],
      },
      'variants': {
        'edges': [
          {
            'node': {
              'id': variantId,
              'title': variantTitle,
              'price': variantPrice,
            },
          },
        ],
      },
    };
  }
}
