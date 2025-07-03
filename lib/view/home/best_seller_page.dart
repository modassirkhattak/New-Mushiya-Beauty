import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:mushiya_beauty/controller/home_controller.dart'
    show HomeController;
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart' show MyAppBarWidget;
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../controller/home_specific_collect_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../widget/custom_button.dart';
import '../product_details/best_seller_details.dart';

class BestSellerPage extends StatelessWidget {
  BestSellerPage({super.key, this.whichPage});

  final String? whichPage;
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.centerEnd,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: whichPage!.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Search",
                    textEditingController: controller.textController,
                    fillColor: whiteColor,
                    height: 40,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons_svg/search_icon.svg',
                        height: 16,
                        width: 16,
                      ),
                    ),
                    suffixIcon: Obx(
                      () =>
                          controller.searchQuery.isNotEmpty
                              ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  // controller.clearSearch();
                                  controller.textController.clear();
                                  controller.searchQuery.value = '';
                                  controller.applyFiltersAndSort();
                                },
                              )
                              : const SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showSortByFilter(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons_svg/sorting_icon.svg',
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isBestProductLoadingMore.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: whiteColor),
                  );
                }
                if (controller.bestProductErrorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Connection timed out, please try again"),
                        const SizedBox(height: 16),
                        MaterialButton(
                          onPressed: controller.retryFetchCollections,
                          color: redColor,
                          child: const Text(
                            "Retry",
                            style: TextStyle(color: whiteColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (controller.collectionsBestProduct.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return GridView.builder(
                  // controller: controller.scrollController,
                  itemCount: controller.collectionsBestProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    if (index == controller.collectionsBestProduct.length) {
                      return const Center(
                        child: CircularProgressIndicator(color: whiteColor),
                      );
                    }
                    final product = controller.collectionsBestProduct[index];
                    return GestureDetector(
                      onTap: () {
                        String gid =
                            controller.collectionsBestProduct[index].id;
                        String numericId = gid.split('/').last;
                        Get.put(
                          ProductDetailsController(),
                        ).fetchProduct(int.parse(numericId));
                        Get.put(HomeController()).selectedVariant.value = null;
                        Get.to(
                          BestSellerDetails(
                            id: controller.collectionsBestProduct[index].id,
                            title:
                                controller.collectionsBestProduct[index].title,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.imageSrc ??
                                      'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/extra_images/girl_1.png',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : Image.asset(
                                                'assets/extra_images/girl_1.png',
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons_svg/cart_add_icon.svg',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: product.title,
                            fontSize: 14,
                            maxLines: 2,
                            fontFamily: "Roboto",
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                          if (whichPage == 'Sale' || whichPage == 'Clearance')
                            CustomText(
                              text: "\$${product.variantPrice}",
                              fontSize: 12,
                              maxLines: 1,
                              topPadding: 4,
                              fontFamily: "Roboto",
                              color: whiteColor,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w400,
                            ),
                          CustomText(
                            text: "\$${product.variantPrice}",
                            fontSize: 12,
                            maxLines: 1,
                            topPadding: 2,
                            fontFamily: "Roboto",
                            color:
                                whichPage == 'Sale' || whichPage == 'Clearance'
                                    ? redColor
                                    : whiteColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  // void _showSortByFilter(BuildContext context) async {
  //   final result = await Get.dialog(SortByFilter(), barrierDismissible: true);
  //   if (result != null) {
  //     // Handle the selected sort option
  //     print('Selected sort: $result');
  //   }
  // }

  void _showSortByFilter(BuildContext context) async {
    final controller = Get.put(HomeSpecificCollectController());
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: primaryBlackColor,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                    Column(
                      children:
                          controller.sortOptions
                              .map(
                                (option) => RadioListTile<String>(
                                  activeColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  // contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  // activeColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  title: Text(option),
                                  value: option,
                                  groupValue:
                                      controller.selectedSortOption.value,
                                  onChanged:
                                      (value) => Navigator.pop(context, value),
                                ),
                              )
                              .toList(),
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
                                result: controller.selectedSortOption.value,
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
                              controller.clearFilters();
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
            ),
          ),
    );
    if (result != null) {
      controller.updateSortOption(result);
    }
  }
}
