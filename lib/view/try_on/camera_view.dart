import 'dart:io';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:camera/camera.dart';
import 'package:mushiya_beauty/view/try_on/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  bool _changingCameraLens = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: _changingCameraLens
                ? Center(
                    child: const Text('Changing camera lens'),
                  )
                : ScreenRecorder(
                    background: Colors.black,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    controller: screenController,
                    child: CameraPreview(
                      _controller!,
                      child: widget.customPaint,
                    ),
                  ),
          ),
          // _switchLiveCameraToggle(),
          // _detectionViewModeToggle(),
          switchFilter(),
          // switchFilter2(),
          // _exposureControl(),
        ],
      ),
    );
  }

  Widget _detectionViewModeToggle() => Positioned(
        bottom: 8,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: widget.onDetectorViewModeChanged,
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.photo_library_outlined,
              size: 25,
              color: whiteColor,
            ),
          ),
        ),
      );

  Widget _switchLiveCameraToggle() => Positioned(
        bottom: 8,
        right: 0,
        left: 0,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () async {
              if (isRecording) {
                screenController.stop();
                try {
                  screenController.stop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Center(child: CircularProgressIndicator(color: Colors.white,)),
                      );
                    },
                  );
                  var gif = await screenController.exporter.exportGif();
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.memory(Uint8List.fromList(gif ?? [])),
                      );
                    },
                  );
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   fullscreenDialog: true,
                  //   builder: (_) => ShowVideoScreen(filePath: videoDirectory),
                  // ));
                } catch (e) {
                  print("ag path erro: " + e.toString());
                }
                // XFile? file = await _controller?.stopVideoRecording();
                setState(() {
                  isRecording = false;
                });
              } else {
                screenController.exporter.clear();
                screenController.start();
                setState(() {
                  isRecording = true;
                });
              }
            },
            backgroundColor: Colors.black54,
            child: CircleAvatar(
              backgroundColor: Colors.white,
                child: isRecording
                    ? Icon(Icons.stop)
                    : Icon(Icons.camera_alt_outlined)),
          ),
        ),
      );

  Widget switchFilter() => Positioned(
        bottom: 120,
        left: 20,
        right: 30,
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(),
            shrinkWrap: true,
            scrollDirection:Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context,index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () => setState(() {
                    filterNum = 0;
                  }),
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        height: 68.0,
                        width: 68.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: whiteColor
                        ),
                        child: Image.asset('assets/goggles.png'),
                      ),
                      CustomText(text: "Baby Naps",fontSize: 14,color: Colors.white,)
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      );
  // Widget switchFilter2() => Positioned(
  //   bottom: 120,
  //       right: 30,
  //       child: SizedBox(
  //         height: 50.0,
  //         width: 50.0,
  //         child: FloatingActionButton(
  //             heroTag: Object(),
  //             onPressed: () => setState(() {
  //                   filterNum = 1;
  //                 }),
  //             backgroundColor: whiteColor,
  //             child: CircleAvatar(child: Image.asset('assets/helmet.png',))),
  //       ),
  //     );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
