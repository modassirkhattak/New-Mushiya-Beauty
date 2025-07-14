import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';
import 'package:mushiya_beauty/new_app/screens/home_tab.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class SortByFilter extends StatelessWidget {
  SortByFilter({super.key});

  final controller = Get.put(ShopifyProductController());

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
                          controller.sortProducts(value!);
                          // Get.back(result: value);//log and return selected option
                        },
                      );
                    }).toList(),
              ),
            ),
            Obx(() => Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  title: const Text("In Stock"),
                  value: 'in',
                  groupValue: controller.stockFilter.value,
                  onChanged: (val) => controller.updateStockFilter(val!),
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  title: const Text("Out of Stock"),
                  value: 'out',

                  groupValue: controller.stockFilter.value,
                  onChanged: (val) => controller.updateStockFilter(val!),
                ),
              ],
            )),



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
                      controller.applyFilters();
                      Get.back();
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
                      controller.clearAllFilters();
                      Get.back();
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

