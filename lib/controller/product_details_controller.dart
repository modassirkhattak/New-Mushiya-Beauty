import 'package:get/get.dart';

import '../model/product_model.dart';
import '../utills/services.dart';

class ProductDetailsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  RxList<String> sizeList = <String>['Small', 'Medium', 'Large'].obs;
  RxList<String> fullnessList =
      <String>[
        'Regular Fullness',
        'Light Fullness',
        'High Fullness\t\t\t\t\t\t\t\t\t\t\t\t\t +\$100',
      ].obs;
  RxList<String> colorsList =
      <String>['Blue', 'Black', 'White', 'Yellow', 'Orange', 'Red'].obs;
  RxString selecctSize = 'Small'.obs;
  RxString selecctColor = 'Blue'.obs;
  RxString selecctFullness = ''.obs;

  // single product api
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<ProductModel?> product = Rx<ProductModel?>(null);
  RxInt selectedVariantIndex = 0.obs;

  Future<void> fetchProduct(int productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      product.value = await ApiServices().fetchProductDetails(productId);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }
}
