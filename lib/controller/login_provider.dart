import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mushiya_beauty/controller/profile_controller.dart';
import 'package:mushiya_beauty/utills/api_controller.dart';
import 'package:mushiya_beauty/view/auth/stated_page.dart';
import 'package:mushiya_beauty/view/bottom_bar/bottom_bar_page.dart';
import 'package:mushiya_beauty/widget/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopifyAuthService extends GetxService {
  final RxBool isLoggedIn = false.obs;
  final RxMap<String, dynamic> customer = <String, dynamic>{}.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // final _storage = const FlutterSecureStorage();

  final String storefrontToken = STORE_TOKEN;
  final String apiUrl =
      'https://runwaycurls.myshopify.com/api/2023-10/graphql.json';

  // @override
  // void onInit() {
  //   checkLoginStatus();
  //   super.onInit();
  // }

  Future<void> checkLoginStatus() async {
    // final token = await _storage.read(key: 'customer_access_token');
    // if (token != null) {
    //   isLoggedIn.value = true;
    //   await fetchCustomerDetails(token);
    // }
  }

  Future<void> login(String email, String password) async {
    loadingDialog(message: "Signing in ...".tr, loading: true);
    isLoading.value = true;
    errorMessage.value = '';

    final mutation = '''
      mutation customerAccessTokenCreate(\$input: CustomerAccessTokenCreateInput!) {
        customerAccessTokenCreate(input: \$input) {
          customerAccessToken {
            accessToken
            expiresAt
          }
          customerUserErrors {
            code
            message
            field
          }
        }
      }
    ''';

    final body = jsonEncode({
      'query': mutation,
      'variables': {
        'input': {'email': email, 'password': password},
      },
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headerStoreApi,
      body: body,
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      final userErrors =
          responseBody['data']?['customerAccessTokenCreate']?['customerUserErrors'] ??
          [];

      if (userErrors.isNotEmpty) {
        final message = userErrors.first['message'] ?? 'Login failed';
        errorMessage.value = message;
        print('User error: $message');
        Get.back();
        Get.snackbar(
          'Login Failed',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final accessToken =
          responseBody['data']?['customerAccessTokenCreate']?['customerAccessToken']?['accessToken']
              ?.toString();

      if (accessToken != null && accessToken.isNotEmpty) {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('customer_access_token', accessToken);
        // await _storage.write(key: 'customer_access_token', value: accessToken);
        isLoggedIn.value = true;

        print('Login successful. Access token: $accessToken');
        FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.back();
        await fetchCustomerDetails(accessToken);

        Get.snackbar(
          'Success',
          'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = 'Access token not received.';
        print('Login failed. No access token.');
        Get.back();
        Get.snackbar(
          'Login Failed',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      errorMessage.value = 'Login failed: ${response.reasonPhrase}';
      print('Login request failed: ${response.body}');
      Get.back();
      Get.snackbar(
        'Login Failed',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchCustomerDetails(String token) async {
    const query = '''
      query GetCustomer(\$accessToken: String!) {
        customer(customerAccessToken: \$accessToken) {
          id
          firstName
          lastName
          email
          phone
        }
      }
    ''';

    final body = jsonEncode({
      'query': query,
      'variables': {'accessToken': token},
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headerStoreApi,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final customerData = data['data']?['customer'];
      print('Customer data: $customerData');

      if (customerData != null) {
        customer.value = customerData;
        print('Customer fetched: ${customerData['email']}');
        // Get.snackbar(
        //   'Success',
        //   'Customer data fetched',
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        final accessUserID = customerData['id'];

        // await _storage.write(key: 'customer_ID', value: accessUserID);
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('customer_ID', accessUserID);
        int customerIdInt = int.parse(customerData['id'].split('/').last);

        sharedPreferences.setInt('customer_ID', customerIdInt);
        print(
          '.................. ,,,, .............${sharedPreferences.getInt('customer_ID')}',
        );
        print('...........................');
        print(await sharedPreferences.setString('customer_ID', accessUserID));
        print('...........................');
        Get.put(ProfileController()).fetchCustomer();

        Get.offAll(() => BottomBarPage());
      } else {
        errorMessage.value = 'Unidentified customer or expired token.';
        print('Customer not found.');
        // Get.snackbar(
        //   'Error',
        //   errorMessage.value,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    } else {
      errorMessage.value = 'Failed to fetch customer details.';
      print('Customer fetch error: ${response.body}');
      // Get.snackbar(
      //   'Error',
      //   errorMessage.value,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    await sharedPreferences.remove('customer_access_token');

    // await _storage.delete(key: 'customer_access_token');
    isLoggedIn.value = false;
    customer.clear();

    Get.snackbar(
      'Logged out',
      'You have been logged out successfully.',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    FirebaseAuth.instance.signOut();
    Get.offAll(() => StatedPage());
    print('User logged out');
  }
}
