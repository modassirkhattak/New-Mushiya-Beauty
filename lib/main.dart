import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:mushiya_beauty/testing.dart';
import 'package:shopify_flutter/shopify_config.dart';
import 'new_app/main.dart' show MyHomePage;
import 'utills/app_colors.dart';
import 'view/bottom_bar/bottom_bar_page.dart';
import 'view/language/controller/localization_controller.dart';
import 'view/language/utils/constant.dart';
import 'view/try_on/detector_view.dart';
import 'view/try_on/face_detector_painter.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:mushiya_beauty/view/language/utils/get_di.dart' as di;

late ui.Image goggleImage;
late ui.Image helmetImage;
int filterNum = 0;
final FaceDetector faceDetector = FaceDetector(
  options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
);
ScreenRecorderController screenController = ScreenRecorderController(
  pixelRatio: 0.5,
  skipFramesBetweenCaptures: 2,
);
// late RecordWidgetController recordWidgetController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Stripe.publishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';
  await Stripe.instance.applySettings();
  ShopifyConfig.setConfig(
    storefrontAccessToken: '7b7ff363f445082993d4a173de185fed',
    storeUrl: 'https://runwaycurls.myshopify.com',
    adminAccessToken: "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",
    storefrontApiVersion: '2023-10',

    cachePolicy: CachePolicy.cacheAndNetwork,
    language: 'en',
  );
  Map<String, Map<String, String>> _languages = await di.init();

  // final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  // final String videoDirectory = path.join(appDocumentsDir.path, 'videos');
  // print("ag path init: " + videoDirectory);
  // recordWidgetController = RecordWidgetController(
  //     directory_folder_render: Directory(videoDirectory));
  goggleImage = await loadImage('wig_try_on.png');
  // goggleImage = await loadImage('goggles.png');
  // helmetImage = await loadImage('helmet.png');
  helmetImage = await loadImage('wig_try_on.png');
  runApp(MyApp(languages: _languages));
}

Future<ui.Image> loadImage(String imageName) async {
  final data = await rootBundle.load('assets/$imageName');
  return decodeImageFromList(data.buffer.asUint8List());
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: GetMaterialApp(
            title: 'Mushiya Beauty',
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(
              AppConstants.languages[0].languageCode,
              AppConstants.languages[0].countryCode,
            ),
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            color: primaryBlackColor,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: primaryBlackColor),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: primaryBlackColor,
              primaryColor: primaryBlackColor,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
              ),
              colorScheme: ColorScheme.dark(
                primary: primaryBlackColor,
                secondary: Colors.grey,
              ),
            ),
            home: BottomBarPage(),
            // home: MyHomePage(),
            // home: CalendarAvailabilityScreen(),
          ),
        );
      },
    );
  }
}

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(foregroundPainter: painter);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
