import 'package:get/get.dart';

class AppConstants {
  static const String sam_base_url = 'http://3.140.41.163:8086/api/';

  static const String appName = 'Digital Faciliter';
  static const String app_version = '2.2.0';
  // static const String baseUri = 'https://6valley.6amtech.com';
  static const String profileUri = '/api/v2/delivery-man/info';
  static const String configUri = '/api/v1/config';
  static const String loginUri = '/api/v2/delivery-man/auth/login';
  static const String notificationUri = '/api/v1/notifications';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String currentOrderUri = '/api/v2/delivery-man/current-orders';
  static const String orderDetailsUri =
      '/api/v2/delivery-man/order-details?order_id=';
  static const String allOrderHistoryUri = '/api/v2/delivery-man/all-orders';
  static const String recordLocationUri =
      '/api/v2/delivery-man/record-location-data';
  static const String updateOrderStatusUri =
      '/api/v2/delivery-man/update-order-status';
  static const String updatePaymentStatusUri =
      '/api/v2/delivery-man/update-payment-status';
  static const String tokenUri = '/api/v2/delivery-man/update-fcm-token';

  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userEmail = 'user_email';
  static const String currency = 'currency';
  static const String topic = 'six_valley_delivery';

  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(
        languageName: 'Arabic', countryCode: 'AR', languageCode: 'ar'),

  ];
}

class LanguageModel {
  String languageName;
  String languageCode;
  String countryCode;

  LanguageModel(
      {required this.languageName,
      required this.countryCode,
      required this.languageCode});
}

class Messages extends Translations {
  final Map<String, Map<String, String>> languages;
  Messages({required this.languages});

  @override
  Map<String, Map<String, String>> get keys {
    return languages;
  }
}
