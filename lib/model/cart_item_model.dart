class CartModel {
  final String token;
  final String? note;
  final Map<String, String>? attributes;
  final int originalTotalPrice;
  final int totalPrice;
  final int totalDiscount;
  final double totalWeight;
  final int itemCount;
  final List<CartItem> items;
  final bool requiresShipping;
  final String currency;
  final int itemsSubtotalPrice;

  CartModel({
    required this.token,
    this.note,
    this.attributes,
    required this.originalTotalPrice,
    required this.totalPrice,
    required this.totalDiscount,
    required this.totalWeight,
    required this.itemCount,
    required this.items,
    required this.requiresShipping,
    required this.currency,
    required this.itemsSubtotalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      token: json['token'],
      note: json['note'],
      attributes: (json['attributes'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      originalTotalPrice: json['original_total_price'],
      totalPrice: json['total_price'],
      totalDiscount: json['total_discount'],
      totalWeight: json['total_weight'].toDouble(),
      itemCount: json['item_count'],
      items:
          (json['items'] as List<dynamic>)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      requiresShipping: json['requires_shipping'],
      currency: json['currency'],
      itemsSubtotalPrice: json['items_subtotal_price'],
    );
  }
}

class CartItem {
  final int id;
  final Map<String, dynamic> properties;
  final int quantity;
  final int variantId;
  final String key;
  final String title;
  final int price;
  final int originalPrice;
  final double presentmentPrice;
  final int discountedPrice;
  final int linePrice;
  final int originalLinePrice;
  final int totalDiscount;
  final List<dynamic> discounts;
  final String sku;
  final int grams;
  final String vendor;
  final bool taxable;
  final int productId;
  final bool productHasOnlyDefaultVariant;
  final bool giftCard;
  final int finalPrice;
  final int finalLinePrice;
  final String url;
  final String image;
  final String handle;
  final bool requiresShipping;
  final String productType;
  final String productTitle;
  final String productDescription;
  final String variantTitle;
  final List<String> variantOptions;
  final List<OptionsWithValues> optionsWithValues;
  final List<dynamic> lineLevelDiscountAllocations;
  final int lineLevelTotalDiscount;
  final bool hasComponents;
  final FeaturedImage? featuredImage;

  CartItem({
    required this.id,
    required this.properties,
    required this.quantity,
    required this.variantId,
    required this.key,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.presentmentPrice,
    required this.discountedPrice,
    required this.linePrice,
    required this.originalLinePrice,
    required this.totalDiscount,
    required this.discounts,
    required this.sku,
    required this.grams,
    required this.vendor,
    required this.taxable,
    required this.productId,
    required this.productHasOnlyDefaultVariant,
    required this.giftCard,
    required this.finalPrice,
    required this.finalLinePrice,
    required this.url,
    required this.image,
    required this.handle,
    required this.requiresShipping,
    required this.productType,
    required this.productTitle,
    required this.productDescription,
    required this.variantTitle,
    required this.variantOptions,
    required this.optionsWithValues,
    required this.lineLevelDiscountAllocations,
    required this.lineLevelTotalDiscount,
    required this.hasComponents,
    this.featuredImage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      properties: json['properties'] ?? {},
      quantity: json['quantity'],
      variantId: json['variant_id'],
      key: json['key'],
      title: json['title'],
      price: json['price'],
      originalPrice: json['original_price'],
      presentmentPrice: (json['presentment_price'] as num).toDouble(),
      discountedPrice: json['discounted_price'],
      linePrice: json['line_price'],
      originalLinePrice: json['original_line_price'],
      totalDiscount: json['total_discount'],
      discounts: json['discounts'],
      sku: json['sku'],
      grams: json['grams'],
      vendor: json['vendor'],
      taxable: json['taxable'],
      productId: json['product_id'],
      productHasOnlyDefaultVariant: json['product_has_only_default_variant'],
      giftCard: json['gift_card'],
      finalPrice: json['final_price'],
      finalLinePrice: json['final_line_price'],
      url: json['url'],
      image: json['image'],
      handle: json['handle'],
      requiresShipping: json['requires_shipping'],
      productType: json['product_type'],
      productTitle: json['product_title'],
      productDescription: json['product_description'],
      variantTitle: json['variant_title'],
      variantOptions:
          (json['variant_options'] as List).map((e) => e.toString()).toList(),
      optionsWithValues:
          (json['options_with_values'] as List)
              .map((e) => OptionsWithValues.fromJson(e))
              .toList(),
      lineLevelDiscountAllocations: json['line_level_discount_allocations'],
      lineLevelTotalDiscount: json['line_level_total_discount'],
      hasComponents: json['has_components'],
      featuredImage:
          json['featured_image'] != null
              ? FeaturedImage.fromJson(json['featured_image'])
              : null,
    );
  }
}

class FeaturedImage {
  final double aspectRatio;
  final String alt;
  final int height;
  final String url;
  final int width;

  FeaturedImage({
    required this.aspectRatio,
    required this.alt,
    required this.height,
    required this.url,
    required this.width,
  });

  factory FeaturedImage.fromJson(Map<String, dynamic> json) {
    return FeaturedImage(
      aspectRatio: json['aspect_ratio'].toDouble(),
      alt: json['alt'],
      height: json['height'],
      url: json['url'],
      width: json['width'],
    );
  }
}

class OptionsWithValues {
  final String name;
  final String value;

  OptionsWithValues({required this.name, required this.value});

  factory OptionsWithValues.fromJson(Map<String, dynamic> json) {
    return OptionsWithValues(name: json['name'], value: json['value']);
  }
}
