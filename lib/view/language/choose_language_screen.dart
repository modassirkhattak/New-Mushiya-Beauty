// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:mushiya_beauty/view/auth/login/apple_login/pages/signin.dart';
// // import 'package:reserv_eat/pages/auth/login/login_screen.dart';
// import 'package:mushiya_beauty/view/language/utils/constant.dart';
//
// import 'controller/language_controller.dart';
// import 'controller/localization_controller.dart';
//
// class ChooseLanguageScreen extends StatelessWidget {
//   final bool fromHomeScreen;
//
//   ChooseLanguageScreen({Key? key, this.fromHomeScreen = false})
//     : super(key: key);
//   // final controller = Get.put(LoginController());
//
//   @override
//   Widget build(BuildContext context) {
//     Get.find<LanguageController>().initializeAllLanguages(context);
//
//     return Scaffold(
//       backgroundColor: Colors.green,
//       body: Container(
//         decoration: BoxDecoration(
//           // image: DecorationImage(
//           // image: AssetImage(
//           //   'assets/images/login_page_1.png'
//           // ),
//           // )
//         ),
//         child: GetBuilder<LanguageController>(
//           builder: (languageController) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 80),
//                 // Text(
//                 //   'choose_the_language'.tr,
//                 //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
//                 // ).paddingOnly(left: 12),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: _languagePopupMenu(languageController),
//                 ),
//                 const Spacer(),
//                 Center(
//                   child: Text(
//                     'Wolt'.tr,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xFF221B1B),
//                       fontSize: 20,
//                       fontFamily: 'Cocon',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ).paddingOnly(bottom: 10),
//                 Center(
//                   child: Text(
//                     'Presque tout, å portee \n de livraison! '.tr,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xFF221B1B),
//                       fontSize: 30,
//                       fontFamily: 'Cocon',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ).paddingOnly(bottom: 10),
//
//                 Platform.isIOS
//                     ? GestureDetector(
//                       onTap: () async {
//                         // await controller.appleSignIn();
//                         // Get.to(SignIn());
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           // color: AppColors.black,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Image.asset(
//                               //   'assets/images/apple_icon.png',
//                               //   scale: 4,
//                               //   color: Colors.white,
//                               // ),
//                               Text(
//                                 'Continue with Apple'.tr,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontFamily: 'Cocon',
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 '',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Color(0xFF221B1B),
//                                   fontSize: 20,
//                                   fontFamily: 'Cocon',
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ).paddingOnly(right: 20, left: 20, top: 20)
//                     : const SizedBox(),
//                 GestureDetector(
//                   onTap: () {
//                     // Your sign-in logic here
//                     // controller.signInWithGoogle();
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 56,
//                     decoration: BoxDecoration(
//                       // color: AppColors.lightWhite,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Image.asset(
//                           //   'assets/images/google_icon.png',
//                           //   scale: 4,
//                           // ),
//                           Text(
//                             'Continue with Google'.tr,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFF221B1B),
//                               fontSize: 18,
//                               fontFamily: 'Cocon',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             '',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFF221B1B),
//                               fontSize: 20,
//                               fontFamily: 'Cocon',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ).paddingOnly(right: 20, left: 20, top: 20),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // print("User Login ===> ${auth.currentUser}");
//
//                     // Get.offAll(BottomNavBar(userGests: "Guest",));
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 56,
//                     decoration: BoxDecoration(
//                       // color: AppColors.lightWhite,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Icon(Icons.perm_identity_sharp, size: 35),
//                           Text(
//                             'Continue with Guest'.tr,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFF221B1B),
//                               fontSize: 20,
//                               fontFamily: 'Cocon',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             '',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFF221B1B),
//                               fontSize: 18,
//                               fontFamily: 'Cocon',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ).paddingOnly(right: 20, left: 20, top: 20),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // print("User Login ===> ${auth.currentUser}");
//
//                     // Get.to(LoginScreen());
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 56,
//                     decoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Icon(Icons.email, color: Colors.white, size: 35),
//                           Text(
//                             'Continue with Email'.tr,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontFamily: 'Cocon',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             '',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFF221B1B),
//                               fontSize: 20,
//                               fontFamily: 'Cocon',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ).paddingOnly(right: 20, left: 20, top: 20, bottom: 60),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _languagePopupMenu(LanguageController languageController) {
//     return GestureDetector(
//       child: PopupMenuButton<int>(
//         onSelected: (int newIndex) {
//           languageController.setSelectIndex(newIndex);
//           if (languageController.languages.isNotEmpty &&
//               languageController.selectIndex != -1) {
//             Get.find<LocalizationController>().setLanguage(
//               Locale(
//                 AppConstants
//                     .languages[languageController.selectIndex]
//                     .languageCode,
//                 AppConstants
//                     .languages[languageController.selectIndex]
//                     .countryCode,
//               ),
//             );
//             if (fromHomeScreen) {
//               Navigator.pop(Get.context!);
//             } else {
//               // Get.to(LoginScreen());
//             }
//           } else {
//             // showCustomSnackBar('select_a_language'.tr);
//           }
//         },
//         itemBuilder: (BuildContext context) {
//           return languageController.languages.map((LanguageModel language) {
//             int index = languageController.languages.indexOf(language);
//             return PopupMenuItem<int>(
//               value: index,
//               child: Row(
//                 children: [
//                   // Image.asset(language.imageUrl, width: 34, height: 34),
//                   const SizedBox(width: 10),
//                   Text(language.languageName),
//                 ],
//               ),
//             );
//           }).toList();
//         },
//         child: Align(
//           alignment:
//               AppConstants
//                               .languages[languageController.selectIndex]
//                               .languageName ==
//                           'Arabic' ||
//                       AppConstants
//                               .languages[languageController.selectIndex]
//                               .languageName ==
//                           'Hebrew'
//                   ? Alignment.centerRight
//                   : Alignment.centerLeft,
//           child: Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//               decoration: BoxDecoration(
//                 // border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 languageController.selectIndex == -1
//                     ? 'select_a_language'.tr
//                     : languageController
//                         .languages[languageController.selectIndex]
//                         .languageName,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
