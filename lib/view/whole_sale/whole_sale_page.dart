import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/cart_controller.dart';
import 'package:mushiya_beauty/controller/whole_sale_controller.dart';
import 'package:mushiya_beauty/model/whole_sale_prroduct_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/whole_sale/whole_sale_details_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:svg_flutter/svg.dart';

class WholeSalePage extends StatelessWidget {
  WholeSalePage({super.key});
  final WholeSaleController controller = Get.put(WholeSaleController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: 'Whole sale'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Search",

              textEditingController: TextEditingController(
                text: controller.searchText.value,
              ),
              fillColor: whiteColor,
              height: 40,
              onChanged: (value) {
                controller.searchText.value = value!;
              },
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/icons_svg/search_icon.svg',
                  height: 16,
                  width: 16,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.filteredList.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }

                return ListView.builder(
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 12.0,
                        vertical: 5,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => WholeSaleDetailsPage(
                              wholeSalePrroductModel: product,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              bottom: BorderSide(color: whiteColor, width: 1),
                            ),
                            color: whiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 13.0,
                              right: 13.0,
                              left: 13.0,
                            ),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Image.network(
                                      product.image,
                                      height: 154,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.error),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        CustomText(
                                          text: product.name,
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: primaryBlackColor,
                                        ),
                                        CustomText(
                                          text: "|",
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: primaryBlackColor,
                                        ),
                                        CustomText(
                                          text: "\$${product.price}",
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: primaryBlackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "Wholesale Price: ",
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: primaryBlackColor,
                                        ),
                                        CustomText(
                                          text: "\$${product.wholePrice}",
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: primaryBlackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "MOQ: ",
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: primaryBlackColor,
                                        ),
                                        CustomText(
                                          text: product.moq,
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: primaryBlackColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: primaryBlackColor,
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.decrementQuantity();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: Icon(
                                                Icons.remove,
                                                color: primaryBlackColor,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => CustomText(
                                              text:
                                                  controller.quantity.value
                                                      .toString(),
                                              fontSize: 14,

                                              fontFamily: 'Roboto',
                                              color: primaryBlackColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (controller.quantity.value >=
                                                  product.minQuantity) {
                                                Get.snackbar(
                                                  "Minimum Quantity",
                                                  "You must add at least ${product.minQuantity} items to the cart.",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8),
                                                  colorText: whiteColor,
                                                );
                                                return;
                                              } else {
                                                controller.incrementQuantity();
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: Icon(
                                                Icons.add,
                                                color: primaryBlackColor,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    CustomButton(
                                      text: "Add to cart".toUpperCase(),
                                      onPressed: () {
                                        if (product.minQuantity < 5) {
                                          Get.snackbar(
                                            "Minimum Quantity",
                                            "You must add at least ${product.minQuantity} items to the cart.",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red
                                                .withOpacity(0.8),
                                            colorText: whiteColor,
                                          );
                                          return;
                                        } else {
                                          cartController.addToCart(
                                            CartItem(
                                              id: product.docId,
                                              name: product.name,
                                              image: product.image,
                                              bookedDate:
                                                  DateTime.now()
                                                      .toIso8601String(),
                                              price: double.parse(
                                                product.wholePrice,
                                              ),
                                              timeSlot: "Whole Sale",
                                              quantity:
                                                  controller.quantity.value,
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor:
                                          product.minQuantity < 5
                                              ? greyColor
                                              : primaryBlackColor,
                                      minWidth: 147,
                                      textColor: whiteColor,
                                      fontSize: 16,
                                      elevation: 0,
                                      height: 38,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
