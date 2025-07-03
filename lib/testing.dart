// import 'package:mushiya_beauty/widget/ar_plugin/managers/ar_anchor_manager.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/managers/ar_location_manager.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/managers/ar_object_manager.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/managers/ar_session_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/ar_flutter_plugin.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/datatypes/config_planedetection.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/datatypes/node_types.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/datatypes/hittest_result_types.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/models/ar_node.dart';
// import 'package:mushiya_beauty/widget/ar_plugin/models/ar_anchor.dart';
// import 'package:camera/camera.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final cameras = await availableCameras();
//   runApp(WigTryOnApp(cameras: cameras));
// }
//
// class WigTryOnApp extends StatelessWidget {
//   final List<CameraDescription> cameras;
//
//   const WigTryOnApp({super.key, required this.cameras});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '3D Wig Try-On',
//       theme: ThemeData.dark(),
//       home: WigTryOnScreen(cameras: cameras),
//     );
//   }
// }
//
// class WigTryOnScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;
//
//   const WigTryOnScreen({super.key, required this.cameras});
//
//   @override
//   _WigTryOnScreenState createState() => _WigTryOnScreenState();
// }
//
// class _WigTryOnScreenState extends State<WigTryOnScreen> {
//   late CameraController _cameraController;
//   late ARSessionManager _arSessionManager;
//   late ARObjectManager _arObjectManager;
//   ARAnchor? _faceAnchor;
//   ARNode? _wigNode;
//
//   String selectedWig = 'wig1.glb';
//   final List<String> wigs = ['wig1.glb', 'wig2.glb', 'wig3.glb', 'wig4.glb'];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     _cameraController = CameraController(
//       widget.cameras.first,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     try {
//       await _cameraController.initialize();
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint("Camera error: $e");
//     }
//   }
//
//   void _onARViewCreated(
//     ARSessionManager arSessionManager,
//     ARObjectManager arObjectManager,
//     ARAnchorManager arAnchorManager,
//   ) {
//     _arSessionManager = arSessionManager;
//     _arObjectManager = arObjectManager;
//
//     _arSessionManager.onInitialize(
//       showFeaturePoints: false,
//       showPlanes: false,
//       customPlaneTexturePath: null,
//       showWorldOrigin: false,
//       handleTaps: false,
//     );
//
//     // Removed invalid setter 'onNodeTap' as it is not defined for ARSessionManager.
//     debugPrint("Node tap functionality is not supported by ARSessionManager.");
//
//     debugPrint(
//       "Face anchor detection functionality is not supported directly by ARSessionManager.",
//     );
//   }
//
//   void _onFaceDetected(ARAnchor anchor) {
//     if (_faceAnchor != null) return;
//
//     _faceAnchor = anchor;
//     _addWigNode();
//   }
//
//   Future<void> _addWigNode() async {
//     if (_faceAnchor == null) return;
//
//     final node = ARNode(
//       type: NodeType.webGLB,
//       uri: selectedWig,
//       scale: vector.Vector3(0.15, 0.15, 0.15),
//       position: vector.Vector3(0.0, 0.18, 0.0),
//       rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//     );
//
//     try {
//       if (_faceAnchor is ARPlaneAnchor) {
//         await _arObjectManager.addNode(
//           node,
//           planeAnchor: _faceAnchor as ARPlaneAnchor,
//         );
//       } else {
//         debugPrint("Error: _faceAnchor is not of type ARPlaneAnchor.");
//       }
//       _wigNode = node;
//     } catch (e) {
//       debugPrint("Error adding node: $e");
//     }
//   }
//
//   Future<void> _changeWig(String wig) async {
//     if (_wigNode == null || _faceAnchor == null) return;
//
//     setState(() => selectedWig = wig);
//
//     await _arObjectManager.removeNode(_wigNode!);
//     _wigNode = null;
//
//     final newNode = ARNode(
//       type: NodeType.webGLB,
//       uri: selectedWig,
//       scale: vector.Vector3(0.15, 0.15, 0.15),
//       position: vector.Vector3(0.0, 0.18, 0.0),
//       rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//     );
//
//     try {
//       if (_faceAnchor is ARPlaneAnchor) {
//         await _arObjectManager.addNode(
//           newNode,
//           planeAnchor: _faceAnchor as ARPlaneAnchor,
//         );
//       } else {
//         debugPrint("Error: _faceAnchor is not of type ARPlaneAnchor.");
//       }
//       _wigNode = newNode;
//     } catch (e) {
//       debugPrint("Error changing wig: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           _cameraController.value.isInitialized
//               ? Stack(
//                 children: [
//                   ARView(
//                     onARViewCreated: (
//                       ARSessionManager sessionManager,
//                       ARObjectManager objectManager,
//                       ARAnchorManager anchorManager,
//                       ARLocationManager locationManager,
//                     ) {
//                       _onARViewCreated(
//                         sessionManager,
//                         objectManager,
//                         anchorManager,
//                       );
//                     },
//                     planeDetectionConfig: PlaneDetectionConfig.none,
//                   ),
//                   _wigSelectionPanel(),
//                 ],
//               )
//               : const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   Widget _wigSelectionPanel() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 120,
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         color: Colors.black54,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: wigs.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () => _changeWig(wigs[index]),
//               child: Container(
//                 width: 80,
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color:
//                         selectedWig == wigs[index]
//                             ? Colors.blue
//                             : Colors.transparent,
//                     width: 3,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.face_retouching_natural,
//                       size: 40,
//                       color: Colors.white,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Wig ${index + 1}',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _arSessionManager.dispose();
//     super.dispose();
//   }
// }
