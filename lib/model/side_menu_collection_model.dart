class ShopifyProduct {
  final String id;
  final String title;
  final String handle;
  final String description;
  final String image;
  final String price;
  final String variantTitle;

  ShopifyProduct({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.image,
    required this.price,
    required this.variantTitle,
  });

  factory ShopifyProduct.fromJson(Map<String, dynamic> json) {
    final variant = json['variants']['edges'][0]['node'];
    final image = json['images']['edges'].isNotEmpty
        ? json['images']['edges'][0]['node']['src']
        : '';

    return ShopifyProduct(
      id: json['id'],
      title: json['title'],
      handle: json['handle'],
      description: json['description'],
      image: image,
      price: variant['price'],
      variantTitle: variant['title'],
    );
  }
}
