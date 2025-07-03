import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class SortByFilter extends StatelessWidget {
  SortByFilter({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryBlackColor,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: CustomText(
                  text: 'Sort By',
                  // style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.w600,
                  // ),
                ),
              ),
            ),
            Obx(
              () => Column(
                children:
                    controller.sortOptions.map((option) {
                      return RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        title: Text(option),
                        value: option,
                        groupValue: controller.selectedSortOption.value,
                        onChanged: (value) {
                          controller.updateSortOption(value!);
                          Get.back(
                            result: value,
                          ); // Close dialog and return selected option
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: [
                Expanded(
                  child: CustomButton(
                    height: 48,
                    text: "Apply".toUpperCase(),
                    onPressed: () {
                      Get.back(
                        result:
                            controller.selectedOption != -1
                                ? controller.sortOptions[controller
                                    .selectedOption]
                                : null,
                      );
                    },
                    backgroundColor: whiteColor,
                    textColor: primaryBlackColor,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    height: 48,
                    borderColor: whiteColor,
                    text: "Clear".toUpperCase(),

                    onPressed: () {
                      controller.clearSelection();
                      Get.back(result: null);
                    },

                    backgroundColor: Colors.transparent,
                    showBorder: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mushiya_beauty/controller/home_controller.dart';
// import 'package:mushiya_beauty/utills/app_colors.dart';
// import 'package:mushiya_beauty/widget/custom_button.dart';
// import 'package:mushiya_beauty/widget/custom_text.dart';

// class SortByFilter extends StatelessWidget {
//   SortByFilter({super.key});

//   final controller = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Dialog(
//         backgroundColor: primaryBlackColor,

//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         child: Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: const Padding(
//                   padding: EdgeInsets.only(bottom: 16.0),
//                   child: CustomText(
//                     text: 'Sort By',
//                     // style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontFamily: 'Archivo',
//                     fontWeight: FontWeight.w600,
//                     // ),
//                   ),
//                 ),
//               ),
//               ...controller.sortOptions.map((option) {
//                 final index = controller.sortOptions.indexOf(option);
//                 return RadioListTile<int>(
//                   contentPadding: EdgeInsets.zero,
//                   dense: true,
//                   visualDensity: VisualDensity.compact,
//                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   title: CustomText(
//                     text: option,
//                     // style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: "Roboto",
//                   ),
//                   // ),
//                   value: index,
//                   groupValue: controller.selectedOption,
//                   activeColor: Colors.white,
//                   onChanged: (value) {
//                     controller.setSelectedOption(value!);
//                   },
//                   controlAffinity: ListTileControlAffinity.leading,
//                 );
//               }).toList(),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 spacing: 20,
//                 children: [
//                   Expanded(
//                     child: CustomButton(
//                       height: 48,
//                       text: "Apply".toUpperCase(),
//                       onPressed: () {
//                         Get.back(
//                           result:
//                               controller.selectedOption != -1
//                                   ? controller.sortOptions[controller
//                                       .selectedOption]
//                                   : null,
//                         );
//                       },
//                       backgroundColor: whiteColor,
//                       textColor: primaryBlackColor,
//                     ),
//                   ),
//                   Expanded(
//                     child: CustomButton(
//                       height: 48,
//                       borderColor: whiteColor,
//                       text: "Clear".toUpperCase(),

//                       onPressed: () {
//                         controller.clearSelection();
//                         Get.back(result: null);
//                       },

//                       backgroundColor: Colors.transparent,
//                       showBorder: true,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
