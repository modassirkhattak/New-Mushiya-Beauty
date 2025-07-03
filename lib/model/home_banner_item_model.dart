class BannerItemModel {
  final String title;
  final String description;
  final String image;

  BannerItemModel({
    required this.title,
    required this.description,
    required this.image,
  });

  factory BannerItemModel.fromJson(Map<String, dynamic> json) {
    return BannerItemModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
