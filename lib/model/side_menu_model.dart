class MenuModel {
  final String id;
  final String handle;
  final String title;
  final List<MenuItem> items;

  MenuModel({
    required this.id,
    required this.handle,
    required this.title,
    required this.items,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      handle: json['handle'],
      title: json['title'],
      items:
          (json['items'] as List)
              .map((item) => MenuItem.fromJson(item))
              .toList(),
    );
  }
}

class MenuItem {
  final String id;
  final String title;
  final String type;
  final String url;
  final List<MenuItem> items;

  MenuItem({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    required this.items,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      url: json['url'],
      items:
          (json['items'] as List? ?? [])
              .map((item) => MenuItem.fromJson(item))
              .toList(),
    );
  }
}

class MenuResponse {
  final List<MenuModel> menus;
  final String? error;

  MenuResponse({required this.menus, this.error});

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    try {
      final edges = json['data']['menus']['edges'] as List;
      return MenuResponse(
        menus: edges.map((e) => MenuModel.fromJson(e['node'])).toList(),
      );
    } catch (e) {
      return MenuResponse(menus: [], error: 'Failed to parse response: $e');
    }
  }

  factory MenuResponse.withError(String error) {
    return MenuResponse(menus: [], error: error);
  }
}
