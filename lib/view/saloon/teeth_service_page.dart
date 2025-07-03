import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/salon_service_firebase_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/saloon/saloon_service_details_page.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';
import '../../controller/saloon_service.controller.dart';

Widget teethServiceTabbarView({required String title}) {
  final controller = Get.find<SaloonServiceController>();

  return Column(
    children: [
      CustomText(
        text:
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla.",
        topPadding: 4,
        bottomPadding: 4,
        fontSize: 12,
        maxLines: 4,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w400,
        color: whiteColor.withOpacity(0.8),
      ),
      const SizedBox(height: 16),
      Expanded(
        child: StreamBuilder<List<SalonService>>(
          stream: controller.getSalonServices(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            final services = snapshot.data!;
            return GridView.builder(
              controller: controller.scrollController,
              itemCount: services.length, //filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final homeModel = services[index];
                return GestureDetector(
                  onTap: () {
                    // final gid = homeModel.id;
                    // final numericId = gid.split('/').last;
                    // Get.put(
                    // ProductDetailsController(),
                    // ).fetchProduct(int.parse(numericId));
                    // Get.put(HomeController()).selectedVariant.value = null;
                    Get.to(
                      () => SaloonServiceDetailsPage(
                        homeModel: homeModel,
                        title: homeModel.sName,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              homeModel.images.isEmpty
                                  ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                                  : homeModel.thumbnailImage,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/extra_images/girl_1.png',
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : Image.asset(
                                            'assets/extra_images/girl_1.png',
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                            ),
                          ),

                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(8),
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
                      const SizedBox(height: 6),
                      CustomText(
                        text: homeModel.sName,
                        fontSize: 14,
                        maxLines: 2,
                        fontFamily: "Roboto",
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: "\$${homeModel.price}",
                        fontSize: 12,
                        maxLines: 1,
                        fontFamily: "Roboto",
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),

      /*  Expanded(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      color: whiteColor,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.retryFetchProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.filteredProducts.isEmpty) {
            return const Center(
              child: Text(
                'No products found',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
            );
          }

          return GridView.builder(
            controller: controller.scrollController,
            itemCount: controller.filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final homeModel = controller.filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  final gid = homeModel.id;
                  final numericId = gid.split('/').last;
                  Get.put(ProductDetailsController())
                      .fetchProduct(int.parse(numericId));
                  Get.put(HomeController()).selectedVariant.value = null;
                  Get.to(() => SaloonServiceDetails(
                    homeModel: homeModel,
                    title: homeModel.title,
                  ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            homeModel.mainImage == null
                                ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                                :homeModel.mainImage!.src,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                              'assets/extra_images/girl_1.png',
                                  height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            loadingBuilder:
                                (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : Image.asset(
                              'assets/extra_images/girl_1.png',
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // if (whichPage == 'New' ||
                        //     whichPage == 'All Produccts' &&
                        //         product.status == "active")
                        //   Positioned(
                        //     top: 10,
                        //     left: 10,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color:
                        //             whichPage == 'All Produccts'
                        //                 ? greyColor
                        //                 : primaryBlackColor,
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: CustomText(
                        //         text:
                        //             whichPage == 'New'
                        //                 ? "New"
                        //                 : "Solid Out",
                        //         leftPadding: 8,
                        //         topPadding: 4,
                        //         rightPadding: 8,
                        //         bottomPadding: 4,
                        //         fontSize: 12,
                        //         maxLines: 1,
                        //         fontFamily: "Roboto",
                        //         color: whiteColor,
                        //       ),
                        //     ),
                        //   ),
                        // if (whichPage == 'Sale' ||
                        //     whichPage == 'Clearance')
                        //   Positioned(
                        //     top: 10,
                        //     left: 10,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: redColor,
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: CustomText(
                        //         text:
                        //             whichPage == 'Sale' ? "Sale" : "Sale",
                        //         leftPadding: 8,
                        //         topPadding: 4,
                        //         rightPadding: 8,
                        //         bottomPadding: 4,
                        //         fontSize: 12,
                        //         maxLines: 1,
                        //         fontFamily: "Roboto",
                        //         color: whiteColor,
                        //       ),
                        //     ),
                        //   ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
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
                    const SizedBox(height: 6),
                    CustomText(
                      text: homeModel.title,
                      fontSize: 14,
                      maxLines: 2,
                      fontFamily: "Roboto",
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: "\$${homeModel.variants.first.price}",
                      fontSize: 12,
                      maxLines: 1,
                      fontFamily: "Roboto",
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
   */
    ],
  );
}
