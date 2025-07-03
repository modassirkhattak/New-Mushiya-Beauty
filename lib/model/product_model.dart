class ProductModel {
  final int id;
  final String title;
  final String bodyHtml;
  final String vendor;
  final String handle;
  final createdAt;
  final String status;
  final List<VariantModel> variants;
  final List<OptionModel> options;
  final List<ImageModel> images;
  final ImageModel? mainImage;

  ProductModel({
    required this.id,
    required this.title,
    required this.bodyHtml,
    required this.vendor,
    required this.createdAt,
    required this.handle,
    required this.status,
    required this.variants,
    required this.options,
    required this.images,
    this.mainImage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      createdAt: json['created_at'] ?? '',
      bodyHtml: json['body_html'] ?? '',
      vendor: json['vendor'] ?? '',
      handle: json['handle'] ?? '',
      status: json['status'] ?? '',
      variants:
          (json['variants'] as List<dynamic>)
              .map((e) => VariantModel.fromJson(e))
              .toList(),
      options:
          (json['options'] as List<dynamic>)
              .map((e) => OptionModel.fromJson(e))
              .toList(),
      images:
          (json['images'] as List<dynamic>)
              .map((e) => ImageModel.fromJson(e))
              .toList(),
      mainImage:
          json['image'] != null
              ? ImageModel.fromJson(json['image'])
              : (json['images'] != null && (json['images'] as List).isNotEmpty
                  ? ImageModel.fromJson(json['images'][0])
                  : null),
    );
  }
}

class VariantModel {
  final int id;
  final int productId;
  final String title;
  final String price;
  final int? position;
  final String? sku;
  final double? weight;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? taxable;
  final String? barcode;
  final String? fulfillmentService;
  final int? inventoryQuantity;
  final String? inventoryPolicy;
  final String? inventoryManagement;
  final bool? requiresShipping;
  final String? weightUnit;
  final String? option1;
  final String? option2;
  final String? option3;
  final String? compareAtPrice;

  VariantModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    this.position,
    this.sku,
    this.weight,
    this.createdAt,
    this.updatedAt,
    this.taxable,
    this.option1,
    this.option2,
    this.option3,
    this.barcode,
    this.fulfillmentService,
    this.inventoryQuantity,
    this.inventoryPolicy,
    this.inventoryManagement,
    this.requiresShipping,
    this.weightUnit,
    this.compareAtPrice,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'],
      productId: json['product_id'],
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      position: json['position'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      sku: json['sku'],
      weight:
          (json['weight'] != null)
              ? double.tryParse(json['weight'].toString())
              : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      taxable: json['taxable'],
      barcode: json['barcode'],
      fulfillmentService: json['fulfillment_service'],
      inventoryQuantity: json['inventory_quantity'],
      inventoryPolicy: json['inventory_policy'],
      inventoryManagement: json['inventory_management'],
      requiresShipping: json['requires_shipping'],
      weightUnit: json['weight_unit'],
      compareAtPrice:
          json['compare_at_price'] == null
              ? ''
              : json['compare_at_price'].toString().isEmpty
              ? ''
              : json['compare_at_price'].toString(),
    );
  }
}

class OptionModel {
  final String name;
  final List<String> values;

  OptionModel({required this.name, required this.values});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json['name'],
      values: List<String>.from(json['values']),
    );
  }
}

class ImageModel {
  final int id;
  final String? alt;
  final String src;

  ImageModel({required this.id, this.alt, required this.src});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(id: json['id'], alt: json['alt'], src: json['src']);
  }
}

class ProductResponse {
  final List<ProductModel> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products:
          (json['products'] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList(),
    );
  }
}
