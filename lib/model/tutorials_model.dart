class TutorialModel {
  final String title;
  final String imageUrl;
  final String description;
  final String videoLink;
  final bool freeType;
  final String rating;
  Duration? videoDuration; // NEW

  TutorialModel({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.videoLink,
    required this.freeType,
    required this.rating,
    this.videoDuration,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['descriptions'] ?? '',
      videoLink: json['video_link'] ?? '',
      freeType: json['free_type'] ?? true,
      rating: json['rating'] ?? '0',
    );
  }
}
