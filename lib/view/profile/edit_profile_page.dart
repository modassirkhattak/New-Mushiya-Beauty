// void showEditProfileDialog(BuildContext context, ProfileController controller) {
//   Get.dialog(
//     AlertDialog(
//       backgroundColor: Colors.black,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: Center(
//         child: Text("EDIT PROFILE", style: TextStyle(color: Colors.white)),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           GestureDetector(
//             onTap: () {
//               Get.bottomSheet(
//                 Container(
//                   color: Colors.white,
//                   child: Wrap(
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.camera_alt),
//                         title: Text("Camera"),
//                         onTap: () {
//                           controller.pickImage(ImageSource.camera);
//                           Get.back();
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.photo),
//                         title: Text("Gallery"),
//                         onTap: () {
//                           controller.pickImage(ImageSource.gallery);
//                           Get.back();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             child: Obx(
//               () => CircleAvatar(
//                 radius: 40,
//                 backgroundImage: controller.selectedImage.value != null
//                     ? FileImage(controller.selectedImage.value!)
//                     : AssetImage('assets/avatar_placeholder.png') as ImageProvider,
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Icon(Icons.camera_alt, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           TextField(
//             onChanged: (val) => controller.name.value = val,
//             style: TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: "Name",
//               hintStyle: TextStyle(color: Colors.white54),
//               filled: true,
//               fillColor: Colors.white12,
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//           onPressed: () => Get.back(),
//           child: Text("SAVE", style: TextStyle(color: Colors.black)),
//         )
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mushiya_beauty/controller/profile_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCustomer();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Edit profile".tr.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      // backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: whiteColor));
        } else if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        } else if (controller.customer.value == null) {
          return Center(child: Text("No customer found."));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        color: Colors.white,
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Camera".tr),
                              onTap: () {
                                controller.pickImage(ImageSource.camera);
                                Get.back();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text("Gallery".tr),
                              onTap: () {
                                controller.pickImage(ImageSource.gallery);
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Obx(
                    () => CircleAvatar(
                      radius: 40,
                      backgroundColor: whiteColor,
                      backgroundImage:
                          controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                              : AssetImage(
                                    'assets/extra_images/profile_user.png',
                                  )
                                  as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          // backgroundColor: whiteColor,
                          radius: 12,
                          child: Icon(
                            Icons.camera_enhance_outlined,
                            color: whiteColor,
                            size: 20,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: "Name".tr,
                  textColor: whiteColor,
                  textEditingController: controller.nameController,
                  // textEditingController: controller.nameController,
                  onChanged: (val) {
                    controller.name.value = val.toString();
                    return val;
                  },
                  isBorder: true,
                  fillColor: Colors.transparent,
                  borderColor: whiteColor.withOpacity(0.3),
                ),
                SizedBox(height: 32),
                CustomButton(
                  text: "Save".tr.toUpperCase(),
                  onPressed: () {
                    controller.updateCustomer(
                      cID: controller.customer.value!.id,
                      name: controller.name.value,
                    );
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: true,
                    //   barrierColor: primaryBlackColor.withOpacity(0.8),

                    //   builder:
                    //       (context) => const ResetLinkDialog(
                    //         text: "Your order has been placed successfully",
                    //         iconPath: "assets/icons_svg/done_check_icon.svg",
                    //         condition: "order_success",
                    //       ),
                    // );
                  },
                  isPrefixIcon: false,
                  minWidth: double.infinity,
                  backgroundColor: whiteColor,
                  textColor: primaryBlackColor,
                  height: 48,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
