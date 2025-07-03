import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mushiya_beauty/model/side_menu_model.dart';
import 'package:mushiya_beauty/utills/services.dart';

import '../model/side_menu_collection_model.dart';

class SideMenuController extends GetxController {
  final ApiServices _menuService = ApiServices();

  final Rx<MenuResponse> _menuResponse = MenuResponse(menus: []).obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  MenuResponse get menuResponse => _menuResponse.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<void> fetchMenus() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final response = await _menuService.fetchMenus();
      _menuResponse.value = MenuResponse.fromJson(response);
      if (_menuResponse.value.error != null) {
        _errorMessage.value = _menuResponse.value.error!;
      }
    } catch (e) {
      _menuResponse.value = MenuResponse.withError(e.toString());
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  List<MenuModel> getMenusByHandle(String handle) {
    return _menuResponse.value.menus
        .where(
          (menu) => menu.handle.toLowerCase().contains(handle.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    fetchMenus();
    // fetchInitialProducts();
    super.onInit();
  }


  // side munu collection click
  RxBool isLoading2 = true.obs;
  RxList<ShopifyProduct> products = <ShopifyProduct>[].obs;
  String? endCursor;
  bool hasNextPage = true;
  bool isFetchingMore = false;


  void fetchInitialProducts({required String collectionId}) async {
    try {
      isLoading2(true);
      final result = await ApiServices.fetchBabyNapsProducts(collectionId: collectionId.toString());
      products.assignAll(result['products']);
      endCursor = result['endCursor'];
      hasNextPage = result['hasNextPage'];
    } finally {
      isLoading2(false);
    }
  }

  void loadMoreProducts({required String collectionId}) async {
    if (!hasNextPage || isFetchingMore) return;

    isFetchingMore = true;
    try {
      final result = await ApiServices.fetchBabyNapsProducts(cursor: endCursor, collectionId: collectionId.toString());
      products.addAll(result['products']);
      endCursor = result['endCursor'];
      hasNextPage = result['hasNextPage'];
    } finally {
      isFetchingMore = false;
    }
  }
}
