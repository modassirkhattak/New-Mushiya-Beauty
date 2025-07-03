// lib/models/product_model.dart
class BestSellingProductModel {
  final String id;
  final String title;
  final String handle;
  final String description;
  final String? imageSrc;
  final String variantId;
  final String variantTitle;
  final String variantPrice;

  BestSellingProductModel({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    this.imageSrc,
    required this.variantId,
    required this.variantTitle,
    required this.variantPrice,
  });

  factory BestSellingProductModel.fromJson(Map<String, dynamic> json) {
    final imageEdges = json['images']['edges'] as List<dynamic>;
    final variantEdges = json['variants']['edges'] as List<dynamic>;
    return BestSellingProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      handle: json['handle'] as String,
      description: json['description'] as String,
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
      'description': description,
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
