class WholeSalePrroductModel {
  final String docId;
  final String name;
  final String desc;
  final String image;
  final String price;
  final String wholePrice;
  final String moq;
  final int minQuantity;
  final Map<String, String> units;

  WholeSalePrroductModel({
    required this.docId,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.wholePrice,
    required this.moq,
    required this.minQuantity,
    required this.units,
  });

  factory WholeSalePrroductModel.fromDocument(
    Map<String, dynamic> json,
    String docId,
  ) {
    return WholeSalePrroductModel(
      docId: docId,
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      wholePrice: json['wholePrice'] ?? '',
      moq: json['MOQ'] ?? '',
      minQuantity: json['min_quantity'] ?? 0,
      units: Map<String, String>.from(json['units'] ?? {}),
    );
  }
}
