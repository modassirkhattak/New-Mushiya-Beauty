class BannerItemModel {
  final String title;
  final String description;
  final String image;
  final String collectionID;

  BannerItemModel({
    required this.title,
    required this.description,
    required this.image,
    required this.collectionID,
  });

  factory BannerItemModel.fromJson(Map<String, dynamic> json) {
    return BannerItemModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      collectionID: json['collectionID'] ?? '',
    );
  }
}

class BellowBannerItemModel {
  final String title;
  final String description;
  final String image;
  final String collectionID;
  final String button_text;

  BellowBannerItemModel({
    required this.title,
    required this.description,
    required this.image,
    required this.collectionID,
    required this.button_text,
  });

  factory BellowBannerItemModel.fromJson(Map<String, dynamic> json) {
    return BellowBannerItemModel(
      title: json['title'] ?? '',
      description: json['banner_desc'] ?? '',
      image: json['image'] ?? '',
      collectionID: json['collectionID'] ?? '',
      button_text: json['button_text'] ?? '',
    );
  }
}
