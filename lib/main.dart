// // import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// // import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:mushiya_beauty/view/try_on/face_detector_painter.dart';
// import 'package:mushiya_beauty/view/try_on/detector_view.dart';
// import 'package:mushiya_beauty/utills/app_colors.dart';
// import 'package:camera/camera.dart';
// import 'dart:math';
// import 'dart:math';
// import 'package:camera/camera.dart';
// import 'package:mushiya_beauty/view/try_on/main.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// // import 'coordinates_translator.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:mushiya_beauty/view/bottom_bar/bottom_bar_page.dart';
// // import 'face_detector_painter.dart';
// import 'package:mushiya_beauty/view/language/controller/localization_controller.dart';
// import 'package:mushiya_beauty/view/language/utils/constant.dart';
// import 'package:screen_recorder/screen_recorder.dart';
// import 'package:shopify_flutter/shopify_config.dart';
// import 'dart:ui' as ui;
// import 'package:mushiya_beauty/view/language/utils/get_di.dart' as di;
//
//
//
// late ui.Image goggleImage;
// late ui.Image helmetImage;
// int filterNum = 0;
// final FaceDetector faceDetector = FaceDetector(
//   options: FaceDetectorOptions(
//     enableContours: true,
//     enableLandmarks: true,
//   ),
// );
// ScreenRecorderController screenController = ScreenRecorderController(
//   pixelRatio: 0.5,
//   skipFramesBetweenCaptures: 2,
// );
//
// // final _storage = const FlutterSecureStorage();
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Load all images before app starts
//   goggleImage = await loadImage('goggles.png');
//   helmetImage = await loadImage('helmet.png');
//
//   await Firebase.initializeApp();
//   Stripe.publishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';
//   await Stripe.instance.applySettings();
//   await availableCameras();
//   Map<String, Map<String, String>> _languages = await di.init();
//
//   ShopifyConfig.setConfig(
//     storefrontAccessToken: '7b7ff363f445082993d4a173de185fed',
//     storeUrl: 'https://runwaycurls.myshopify.com',
//     adminAccessToken: "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",
//     storefrontApiVersion: '2023-10',
//     cachePolicy: CachePolicy.cacheAndNetwork,
//     language: 'en',
//   );
//
//   initializeDateFormatting();
//   runApp(MyApp(languages: _languages));
// }
//
//
// Future<void> initializeImages() async {
//   goggleImage = await loadImage('goggles.png');
//   helmetImage = await loadImage('helmet.png');
// }
//
// class MyApp extends StatelessWidget {
//   final Map<String, Map<String, String>> languages;
//
//   MyApp({super.key, required this.languages});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LocalizationController>(
//       builder: (localizeController) {
//         return GestureDetector(
//           onTap: (){
//             FocusScope.of(context).unfocus();
//           },
//           behavior: HitTestBehavior.translucent,
//           child: GetMaterialApp(
//             title: 'Mushiya Beauty',
//             locale: localizeController.locale,
//             translations: Messages(languages: languages),
//             fallbackLocale: Locale(
//               AppConstants.languages[0].languageCode,
//               AppConstants.languages[0].countryCode,
//             ),
//             themeMode: ThemeMode.dark,
//             debugShowCheckedModeBanner: false,
//             color: primaryBlackColor,
//             theme: ThemeData(
//               brightness: Brightness.light,
//               colorScheme: ColorScheme.fromSeed(seedColor: primaryBlackColor),
//             ),
//
//             darkTheme: ThemeData(
//               brightness: Brightness.dark,
//               scaffoldBackgroundColor: primaryBlackColor,
//               primaryColor: primaryBlackColor,
//               appBarTheme: const AppBarTheme(
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//               ),
//               textTheme: const TextTheme(
//                 bodyLarge: TextStyle(color: Colors.white),
//                 bodyMedium: TextStyle(color: Colors.white),
//                 titleLarge: TextStyle(color: Colors.white),
//               ),
//               colorScheme: ColorScheme.dark(
//                 primary: primaryBlackColor,
//                 secondary: Colors.grey,
//               ),
//             ),
//             home: BottomBarPage(),
//             // home: FaceDetectorView(),
//           ),
//         );
//       },
//     );
//   }
// }
