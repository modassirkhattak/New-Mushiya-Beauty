import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/view/language/controller/language_controller.dart';
import 'package:mushiya_beauty/view/language/controller/localization_controller.dart';
import 'package:mushiya_beauty/view/language/controller/theme_controller.dart';
import 'package:mushiya_beauty/view/language/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  // Get.lazyPut(() => ApiClient(
  //     appBaseUrl: AppConstants.baseUri, sharedPreferences: Get.find()));

  // Repository

  Get.lazyPut(() => LanguageRepo());

  // Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));

  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LanguageController(sharedPreferences: Get.find()));

  Get.lazyPut(
      () => LocalizationController(sharedPreferences: sharedPreferences));

  // Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> _languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = {};
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  return _languages;
}
