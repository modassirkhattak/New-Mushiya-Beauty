class PolicyModel {
  final String body;
  final String createdAt;
  final String updatedAt;
  final String handle;
  final String title;
  final String url;

  PolicyModel({
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.handle,
    required this.title,
    required this.url,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      body: json['body'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      handle: json['handle'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class PolicyResponse {
  final List<PolicyModel> policies;

  PolicyResponse({required this.policies});

  factory PolicyResponse.fromJson(Map<String, dynamic> json) {
    var policyList = json['policies'] as List? ?? [];
    List<PolicyModel> policies =
        policyList.map((policy) => PolicyModel.fromJson(policy)).toList();
    return PolicyResponse(policies: policies);
  }
}

class ShopifyPageModel {
  final String id;
  final String title;
  final String body;

  ShopifyPageModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory ShopifyPageModel.fromJson(Map<String, dynamic> json) {
    return ShopifyPageModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
