import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopify_flutter/models/src/order/order.dart';
// import 'package:shopify_flutter/shopify_flutter.dart'; // adjust import as needed
import 'package:shopify_flutter/shopify_flutter.dart';

class ShopifyOrderController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final token = await sharedPreferences.getString('customer_access_token');
    try {
      isLoading.value = true;
      ShopifyOrder shopifyOrder = ShopifyOrder.instance;

      final fetchedOrders = await shopifyOrder.getAllOrders("$token");
      orders.value = fetchedOrders!; // set and trigger UI update
    } catch (e) {
      print("❌ Error fetching orders: $e");
      orders.clear(); // optionally clear
    } finally {
      isLoading.value = false;
    }
  }
}
