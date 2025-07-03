import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:mushiya_beauty/model/cart_item_model.dart';

import 'package:mushiya_beauty/model/order_model.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiServicesCheckout {
  // final _storage = FlutterSecureStorage();
  static const String _adminTokenKey = 'shopify_admin_token';

  // Initialize admin access token
  Future<void> initAdminToken() async {
    final sharedpref = await SharedPreferences.getInstance();
    // Store token securely (replace with your token or fetch dynamically)
    await sharedpref.setString(
      _adminTokenKey,
      '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',
      // key: _adminTokenKey,
      // value: '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',
    );
  }

  Future<String?> _getAdminToken() async {
    final sharedpref = await SharedPreferences.getInstance();
    return sharedpref.getString(_adminTokenKey);
    // return await _storage.read(key: _adminTokenKey);
  }

  // Common headers for Ajax API
  Map<String, String> get _ajaxHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Cookie':
        '_landing_page=%2Faccount%2Flogin; _orig_referrer=; _shopify_essential=:AZdnpi4GAAEAKwUY_Hv8SOJ07Q1HIVm2VovPXr-_EoL50cY6MEJwYuENpNOz0tOi52T-SPnrP7hfwxM-g8pVrq7TtndiIAGBId0XaRJ67kOqmsrTLWu8_j8v8b0XF25lkW3eKFWQgxDqRWTvbvl_-q0ma0lnpOODGlmhjS2L3z1XU55yVljwpmduU0Lihma4HieuP59uarUumg1-ynZsRheWZh-mzSzen8YhfR8AyD6TWJ2gXQVckHEtz-QZd-z-v0q7UbW-oVvgiUEQe8HraP1Vhpbw_0U81-qMj1oh7x64YiGGYv93ZpclxjYEagsTvp1Stm7m:; _shopify_s=866d15e3-091b-43b9-aad2-2a72dd3bacac; _shopify_y=95777da9-a312-47fb-bdd7-bd27eed5698e; _tracking_consent=3.AMPS_USVA_f_f_-DlBBsijT9252dNjR-wT4w; cart=Z2NwLXVzLWVhc3QxOjAxSlhLSlo2Mk5TS0VWRFRINldaRFAwWTc4%3Fkey%3D87b9ebd20dd6af1e7e1eb70caa8aed85; cart_currency=USD; cart_sig=3dec1494f68ed91d5b0f87e4cf36e81f; checkout_session_lookup=%7B%22version%22%3A1%2C%22keys%22%3A%5B%7B%22source_id%22%3A%22Z2NwLXVzLWVhc3QxOjAxSlhLSlo2Mk5TS0VWRFRINldaRFAwWTc4%22%2C%22checkout_session_identifier%22%3A%22e110f8a6d69ac6468b428c8ff60e1b99%22%2C%22source_type_abbrev%22%3A%22cn%22%2C%22updated_at%22%3A%222025-06-13T04%3A57%3A13.410Z%22%7D%5D%7D; checkout_session_token__cn__Z2NwLXVzLWVhc3QxOjAxSlhLSlo2Mk5TS0VWRFRINldaRFAwWTc4=%7B%22token%22%3A%22AAEBqR4pO-36QjpuNwKERTCHejzgxzPIMoo7C-hEG-lDZPC-7NaQqcllUR1BuyV6MhZrlMAMc2BYhx8eQFMt3RtwPAdwfZ0D0rx9UZJnJVe6-iOMg1hdFy6iGlLO-WNzQ00A8GHH1QoufLM8ckYrSMhVnCMvu3iGRLZm8rNDiMoks2NWmZFUyF9d9E2_RfUX-0w_06RxcpzwsXB1KfMpr35evBebhUmwyNr9bfK3vGLbxwwd0jTc5RAOHwwEx5BMgNOqGjc%22%2C%22locale%22%3A%22en-US%22%2C%22checkout_session_identifier%22%3A%22e110f8a6d69ac6468b428c8ff60e1b99%22%7D; localization=US; shop_pay_accelerated=%7B%22universal_redirect%22%3A1749790634%7D',
  };

  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Fetch Cart
  fetchCart() async {
    var headers = _ajaxHeaders;
    var request = http.Request(
      'GET',
      Uri.parse('https://runwaycurls.myshopify.com/cart.js'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  // Add to Cart
  Future addToCartApi({required int variantId, required int quantity}) async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    try {
      final response = await http
          .post(
            Uri.parse('https://runwaycurls.myshopify.com/cart/add.js'),
            headers: _ajaxHeaders,
            body: jsonEncode({'id': variantId, 'quantity': quantity}),
          )
          .timeout(Duration(minutes: 1));
      print("Add to Cart Status: ${response.statusCode}");
      print("Add to Cart Response: ${response.body}");
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Item Added to Cart");
        // return await fetchCart();
      } else {
        throw HttpException(
          'Failed to add to cart: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e, stackTrace) {
      print('Error adding to cart: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Change Cart Item Quantity (Increment/Decrement)
  Future<CartModel> changeCartItemQuantity({
    required int variantId,
    required int quantity,
  }) async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    try {
      final response = await http
          .post(
            Uri.parse('https://runwaycurls.myshopify.com/cart/change.js'),
            headers: _ajaxHeaders,
            body: jsonEncode({'id': variantId, 'quantity': quantity}),
          )
          .timeout(Duration(minutes: 1));
      print("Change Quantity Status: ${response.statusCode}");
      print("Change Quantity Response: ${response.body}");
      if (response.statusCode == 200) {
        return await fetchCart();
      } else {
        throw HttpException(
          'Failed to change quantity: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e, stackTrace) {
      print('Error changing quantity: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Remove Cart Item
  Future<CartModel> removeCartItem({required int variantId}) async {
    return await changeCartItemQuantity(variantId: variantId, quantity: 0);
  }

  // Update Cart Attributes
  Future<CartModel> updateCartAttributes({
    required Map<String, String> attributes,
  }) async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    try {
      final response = await http
          .post(
            Uri.parse('https://runwaycurls.myshopify.com/cart/update.js'),
            headers: _ajaxHeaders,
            body: jsonEncode({'attributes': attributes}),
          )
          .timeout(Duration(minutes: 1));
      print("Update Attributes Status: ${response.statusCode}");
      print("Update Attributes Response: ${response.body}");
      if (response.statusCode == 200) {
        return await fetchCart();
      } else {
        throw HttpException(
          'Failed to update attributes: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e, stackTrace) {
      print('Error updating attributes: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Clear Cart
  Future<CartModel> clearCart() async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    try {
      final response = await http
          .post(
            Uri.parse('https://runwaycurls.myshopify.com/cart/clear.js'),
            headers: _ajaxHeaders,
            body: jsonEncode({}),
          )
          .timeout(Duration(minutes: 1));
      print("Clear Cart Status: ${response.statusCode}");
      print("Clear Cart Response: ${response.body}");
      if (response.statusCode == 200) {
        return await fetchCart();
      } else {
        throw HttpException(
          'Failed to clear cart: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e, stackTrace) {
      print('Error clearing cart: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Initiate Checkout
  Future<String> initiateCheckout() async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    try {
      final response = await http
          .post(
            Uri.parse('https://runwaycurls.myshopify.com/cart'),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Cookie': _ajaxHeaders['Cookie']!,
            },
            body: {'checkout': 'Checkout'},
          )
          .timeout(Duration(minutes: 1));
      print("Initiate Checkout Status: ${response.statusCode}");
      print("Initiate Checkout Headers: ${response.headers}");
      if (response.statusCode == 302) {
        final location = response.headers['location'];
        if (location != null && location.contains('/checkout')) {
          return location;
        } else {
          throw Exception('Invalid checkout redirect URL');
        }
      } else {
        throw HttpException(
          'Failed to initiate checkout: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e, stackTrace) {
      print('Error initiating checkout: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Create Order (Admin API)
  Future<OrderModel> createOrder({
    required int variantId,
    required int quantity,
    required String customerEmail,
  }) async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    final adminToken = await _getAdminToken();
    if (adminToken == null) {
      throw Exception('Admin access token not configured');
    }
    try {
      final response = await http
          .post(
            Uri.parse(
              'https://runwaycurls.myshopify.com/admin/api/2025-04/orders.json',
            ),
            headers: {
              'Content-Type': 'application/json',
              'X-Shopify-Access-Token': adminToken,
            },
            body: jsonEncode({
              'order': {
                'line_items': [
                  {'variant_id': variantId, 'quantity': quantity},
                ],
                'customer': {'email': customerEmail},
                'financial_status': 'pending',
              },
            }),
          )
          .timeout(Duration(minutes: 1));
      print("Create Order Status: ${response.statusCode}");
      print("Create Order Response: ${response.body}");
      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return OrderModel.fromJson(jsonData['order']);
      } else {
        throw HttpException(
          'Failed to create order: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e, stackTrace) {
      print('Error creating order: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Fetch Orders
  Future<OrderResponse> fetchOrders() async {
    if (!(await _isConnected())) {
      throw Exception('No internet connection');
    }
    final adminToken = await _getAdminToken();
    if (adminToken == null) {
      throw Exception('Admin access token not configured');
    }
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://runwaycurls.myshopify.com/admin/api/2025-04/orders.json',
            ),
            headers: {
              'Content-Type': 'application/json',
              'X-Shopify-Access-Token': adminToken,
            },
          )
          .timeout(Duration(minutes: 1));
      print("Fetch Orders Status: ${response.statusCode}");
      print("Fetch Orders Response: ${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return OrderResponse.fromJson(jsonData);
        } else {
          throw FormatException('Expected a JSON object, received: $jsonData');
        }
      } else {
        throw HttpException(
          'Failed to fetch orders: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e, stackTrace) {
      print('Error parsing orders: $e\nStackTrace: $stackTrace');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
