import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/cart_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:mushiya_beauty/utills/api_controller.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pCodeController = TextEditingController();
  final phoneNoController = TextEditingController();

  @override
  void onInit() {
    fetchCartData();
    super.onInit();
  }

  RxBool isCheckedSupport = false.obs;
  RxString isCheckedDelivery = ''.obs;

  final selectedPaymentMethod = ''.obs;
  final paymentMethods = [
    {'name': 'PayPal', 'icon': 'assets/icons_svg/PayPal.svg'},
    {'name': 'Stripe', 'icon': 'assets/icons_svg/PayPal.svg'},
    // {'name': 'Apple Pay', 'icon': 'assets/icons_svg/Group.svg'},
    // {'name': 'Google Pay', 'icon': 'assets/icons_svg/PayPal.svg'},
  ];

  Rx<CartModel?> cartModel = Rx<CartModel?>(null);
  RxList<CartItem> products = <CartItem>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  var cart = Rxn<CartModel>(); // Nullable reactive CartModel
  var error = ''.obs;

  Future<void> fetchCartData() async {
    isLoading.value = true;
    error.value = '';

    try {
      var headers = headerStoreApi;

      var request = http.Request('POST', Uri.parse(CART_URL));
      request.headers.addAll(headers);

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseStr = await streamedResponse.stream.bytesToString();
        final jsonData = jsonDecode(responseStr);
        print("Response is $responseStr");
        cart.value = CartModel.fromJson(jsonData);
      } else {
        error.value = 'Failed to load cart';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
