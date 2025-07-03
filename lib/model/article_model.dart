// import 'material';

class ArticleModel {
  final int id;
  final String title;
  final String createdAt;
  final String bodyHtml;
  final int blogId;
  final String author;
  final int userId;
  final String publishedAt;
  final String updatedAt;
  final String summaryHtml;
  final String templateSuffix;
  final String handle;
  final String tags;
  final String adminGraphqlApiId;
  final ImageModel? image;

  ArticleModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.bodyHtml,
    required this.blogId,
    required this.author,
    required this.userId,
    required this.publishedAt,
    required this.updatedAt,
    required this.summaryHtml,
    required this.templateSuffix,
    required this.handle,
    required this.tags,
    required this.adminGraphqlApiId,
    this.image,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      createdAt: json['created_at'] ?? '',
      bodyHtml: json['body_html'] ?? '',
      blogId: json['blog_id'] ?? 0,
      author: json['author'] ?? '',
      userId: json['user_id'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      summaryHtml: json['summary_html'] ?? '',
      templateSuffix: json['template_suffix'] ?? '',
      handle: json['handle'] ?? '',
      tags: json['tags'] ?? '',
      adminGraphqlApiId: json['admin_graphql_api_id'] ?? '',
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
    );
  }
}

class ImageModel {
  final String createdAt;
  final String alt;
  final int width;
  final int height;
  final String src;

  ImageModel({
    required this.createdAt,
    required this.alt,
    required this.width,
    required this.height,
    required this.src,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      createdAt: json['created_at'] ?? '',
      alt: json['alt'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      src: json['src'] ?? '',
    );
  }
}

class ArticleResponse {
  final List<ArticleModel> articles;

  ArticleResponse({required this.articles});

  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    var articleList = json['articles'] as List? ?? [];
    List<ArticleModel> articles =
        articleList.map((article) => ArticleModel.fromJson(article)).toList();
    return ArticleResponse(articles: articles);
  }
}
