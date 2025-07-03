class TeethApiServiceModel {
  final List<TeethServiceProductModel> products;
  final bool hasNextPage;
  final String? endCursor;

  TeethApiServiceModel({
    required this.products,
    required this.hasNextPage,
    this.endCursor,
  });
}

class TeethServiceProductModel {
  final String id;
  final String title;
  final String handle;
  final String descriptionHtml;
  final ProductImage? mainImage;
  final List<ProductVariant> variants;
  final String createdAt;
  final String status;

  TeethServiceProductModel({
    required this.id,
    required this.title,
    required this.handle,
    required this.descriptionHtml,
    this.mainImage,
    required this.variants,
    required this.createdAt,
    required this.status,
  });

  factory TeethServiceProductModel.fromJson(Map<String, dynamic> json) {
    return TeethServiceProductModel(
      id: json['id'],
      title: json['title'],
      handle: json['handle'],
      descriptionHtml: json['descriptionHtml'],
      mainImage:
          json['images']['edges'].isNotEmpty
              ? ProductImage.fromJson(json['images']['edges'][0]['node'])
              : null,
      variants:
          (json['variants']['edges'] as List)
              .map((e) => ProductVariant.fromJson(e['node']))
              .toList(),
      createdAt: json['variants']['edges'][0]['node']['createdAt'],
      status:
          json['variants']['edges'][0]['node']['availableForSale']
              ? 'active'
              : 'sold out',
    );
  }
}

class ProductImage {
  final String src;

  ProductImage({required this.src});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(src: json['src']);
  }
}

class ProductVariant {
  final String id;
  final String title;
  final String price;
  final bool availableForSale;
  final int inventoryQuantity;
  final String createdAt;

  ProductVariant({
    required this.id,
    required this.title,
    required this.price,
    required this.availableForSale,
    required this.inventoryQuantity,
    required this.createdAt,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      availableForSale: json['availableForSale'],
      inventoryQuantity: json['inventoryQuantity'],
      createdAt: json['createdAt'],
    );
  }
}
