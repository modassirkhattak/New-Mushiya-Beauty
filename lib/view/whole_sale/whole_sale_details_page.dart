import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:mushiya_beauty/controller/cart_controller.dart';
import 'package:mushiya_beauty/controller/whole_sale_controller.dart';
import 'package:mushiya_beauty/model/whole_sale_prroduct_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/cart/cart_page.dart';
import 'package:mushiya_beauty/view/checkout/checkout_page.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

class WholeSaleDetailsPage extends StatelessWidget {
  WholeSaleDetailsPage({super.key, required this.wholeSalePrroductModel});

  final WholeSalePrroductModel wholeSalePrroductModel;
  final WholeSaleController controller = Get.put(WholeSaleController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: greyColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => FaqPage());
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        // mini: true,
        shape: const CircleBorder(),
        backgroundColor: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/icons_svg/message_icon2.svg',
            height: 24,
            width: 24,
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: 'Product details'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 16,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                // homeModel.image,
                wholeSalePrroductModel.image,
                height: 320,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 320,
                    width: double.infinity,
                    color: greyColor,
                    child: Center(
                      child: CustomText(
                        text: 'Image not available',
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 320,
                    width: double.infinity,
                    color: greyColor,
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        color: primaryBlackColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: wholeSalePrroductModel.name,
              fontSize: 18,
              fontFamily: 'Archivo',
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8),
            Column(
              children:
                  wholeSalePrroductModel.units.entries.map((entry) {
                    return Row(
                      children: [
                        CustomText(
                          text: '${entry.key} Units: ',
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          color: whiteColor,
                          fontWeight: FontWeight.w400,
                        ),

                        CustomText(
                          text: '${entry.value} units',
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    );
                  }).toList(),
            ),

            SizedBox(height: 16),
            CustomText(
              text: 'Description',
              fontSize: 18,
              fontFamily: 'Archivo',
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
            CustomText(
              text: wholeSalePrroductModel.desc,
              // 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla. ',
              fontSize: 12,
              fontFamily: 'Roboto',
              maxLines: 4,
              color: whiteColor,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 16),
            // add to cart buttons
            Row(
              children: [
                CustomText(
                  text: 'Select quantity',
                  fontSize: 18,
                  fontFamily: 'Archivo',
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: whiteColor, width: 0.8),
                  ),

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: primaryBlackColor, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.decrementQuantity();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: whiteColor,
                              size: 18,
                            ),
                          ),
                        ),
                        Obx(
                          () => CustomText(
                            text: controller.quantity.value.toString(),
                            fontSize: 14,

                            fontFamily: 'Roboto',
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.quantity.value >=
                                wholeSalePrroductModel.minQuantity) {
                              Get.snackbar(
                                "Minimum Quantity",
                                "You must add at least ${wholeSalePrroductModel.minQuantity} items to the cart.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.withOpacity(0.8),
                                colorText: whiteColor,
                              );
                              return;
                            } else {
                              controller.incrementQuantity();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Icon(Icons.add, color: whiteColor, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            // add to cart button and buy now
            Row(
              spacing: 30,
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Add to cart".toUpperCase(),
                    onPressed: () {
                      if (wholeSalePrroductModel.minQuantity < 5) {
                        Get.snackbar(
                          "Minimum Quantity",
                          "You must add at least ${wholeSalePrroductModel.minQuantity} items to the cart.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: whiteColor,
                        );
                        return;
                      } else {
                        cartController.addToCart(
                          CartItem(
                            id: wholeSalePrroductModel.docId,
                            name: wholeSalePrroductModel.name,
                            image: wholeSalePrroductModel.image,
                            bookedDate: DateTime.now().toIso8601String(),
                            price: double.parse(
                              wholeSalePrroductModel.wholePrice,
                            ),
                            timeSlot: "Whole Sale",
                            quantity: controller.quantity.value,
                          ),
                        );
                      }
                    },
                    backgroundColor: whiteColor,
                    textColor: primaryBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 40,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    text: "buy now".toUpperCase(),
                    onPressed: () {
                      if (wholeSalePrroductModel.minQuantity < 5) {
                        Get.snackbar(
                          "Minimum Quantity",
                          "You must add at least ${wholeSalePrroductModel.minQuantity} items to the cart.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: whiteColor,
                        );
                        return;
                      } else {
                        cartController.addToCart(
                          CartItem(
                            id: wholeSalePrroductModel.docId,
                            name: wholeSalePrroductModel.name,
                            image: wholeSalePrroductModel.image,
                            bookedDate: DateTime.now().toIso8601String(),
                            price: double.parse(
                              wholeSalePrroductModel.wholePrice,
                            ),
                            timeSlot: "Whole Sale",
                            quantity: controller.quantity.value,
                          ),
                        );
                        Get.to(() => CheckoutPage());
                      }
                    },
                    backgroundColor: primaryBlackColor,
                    borderColor: whiteColor,
                    textColor: whiteColor,
                    showBorder: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 40,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // more payment options
            Center(
              child: GestureDetector(
                onTap: () => Get.to(() => CheckoutPage()),
                child: CustomText(
                  text: 'More payment options',
                  fontSize: 12,
                  fontFamily: 'Archivo',
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            // CustomTabWidget(
            //   children: [
            //     Tab(text: 'Description'),
            //     Tab(text: 'Shipping policy'),
            //     Tab(text: 'Return policy'),
            //   ],
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.30,
            //   child: TabBarView(
            //     children: [
            //       tabbarView(homeModel: homeModel, title: "Description"),
            //       tabbarView(homeModel: homeModel, title: "Shipping policy"),
            //       tabbarView(homeModel: homeModel, title: "Return policy"),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
