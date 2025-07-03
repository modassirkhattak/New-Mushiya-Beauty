import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/side_menu_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/utills/services.dart';

import '../../controller/home_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_text.dart';
import '../product_details/best_seller_details.dart';

class ShopifyProductGrid extends StatelessWidget {
  final controller = Get.put(SideMenuController());

  final ScrollController scrollController = ScrollController();
  final String id;
  final String title;

  ShopifyProductGrid({super.key, required this.id, required this.title}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.loadMoreProducts(collectionId: id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "${title}".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          if (controller.isLoading2.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(0),
                  itemCount: controller.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return GestureDetector(
                      onTap: () {
                        String gid = controller.products[index].id;
                        String numericId = gid.split('/').last;
                        Get.put(
                          ProductDetailsController(),
                        ).fetchProduct(int.parse(numericId));
                        // Get.put(HomeController()).selectedVariant.value = null;
                        // .selectedVariant.value = product.variants.first;
                        Get.to(
                          BestSellerDetails(
                            id: controller.products[index].id,
                            title: controller.products[index].title,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.image.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.image,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CustomText(
                              text: product.title,
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: whiteColor,
                              fontWeight: FontWeight.w500,
                            ) /*Text(product.title,
                                maxLines: 2, overflow: TextOverflow.ellipsis),*/,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: CustomText(
                              text: product.price,
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            ) /*Text("\$${product.price}", style: TextStyle(color: Colors.green)),*/,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (controller.isFetchingMore)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        }),
      ),
    );
  }
}
