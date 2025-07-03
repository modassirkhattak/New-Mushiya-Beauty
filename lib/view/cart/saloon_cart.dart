import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/checkout/checkout_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

import '../../controller/cart_controller.dart';

class SaloonCartPage extends StatelessWidget {
   SaloonCartPage({super.key});
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: 'Cart'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          right: 16,
          left: 16,
          bottom: 16,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Obx(
                    () => cartController.cartItems.isEmpty
                    ? Center(child: Text('Your cart is empty!'))
                    : ListView.builder(
                  itemCount: cartController.cartItems.length,
                  // padding: EdgeInsets.s,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                          bottom: 6,
                          top: 6,
                          left: 4,
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            Image.network(
                              item.image,
                              height: 75,
                              width: 88,
                            ),
                            Column(
                              // spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: item.name,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 8),
                                CustomText(
                                  text: DateFormat("dd-MM-yyyy").format(DateTime.parse(item.bookedDate)),
                                  // fontSize: 14,/
                                  // fontFamily: "Roboto",

                                  // text: item.bookedDate,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 0),
                                CustomText(
                                  text: item.timeSlot,
                                  // fontSize: 14,/
                                  // fontFamily: "Roboto",

                                  // text: item.bookedDate,
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                ),
                                // add to cart button
                                // Container(
                                //   padding: EdgeInsets.symmetric(
                                //     horizontal: 8,
                                //     vertical: 0,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(6),
                                //     border: Border.all(
                                //       color: primaryBlackColor,
                                //       width: 0.8,
                                //     ),
                                //   ),
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     spacing: 10,
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {},
                                //         child: Icon(
                                //           Icons.remove,
                                //           color: primaryBlackColor,
                                //           size: 11,
                                //         ),
                                //       ),
                                //       CustomText(
                                //         text: '12',
                                //         fontSize: 14,
                                //         fontFamily: 'Roboto',
                                //         color: primaryBlackColor,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //
                                //       GestureDetector(
                                //         onTap: () {},
                                //
                                //         child: Icon(
                                //           Icons.add,
                                //           color: primaryBlackColor,
                                //           size: 11,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            Spacer(),
                            CustomText(
                              text: "\$${item.price}",
                              fontSize: 18,
                              color: primaryBlackColor,
                              fontFamily: "Archivo",
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Spacer(),
            SizedBox(height: 40),
            Row(
              children: [
                CustomText(
                  text: "Date",
                  fontSize: 12,
                  fontFamily: "Roboto",
                  color: whiteColor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                CustomText(
                  text:
                      "${DateFormat("EEE").format(DateTime.now())} ${DateFormat('dd/MM/yyyy').format(DateTime.now())}", // "12/3/2025",
                  fontSize: 12,
                  fontFamily: "Archivo",
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: "Time",
                  fontSize: 12,
                  fontFamily: "Roboto",
                  color: whiteColor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                CustomText(
                  text:
                      "${DateFormat('hh:mm a').format(DateTime.now())}", // "12/3/2025",
                  fontSize: 12,
                  fontFamily: "Archivo",
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: "Grand total",
                  fontSize: 12,
                  fontFamily: "Roboto",
                  color: whiteColor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                CustomText(
                  text: "\$${cartController.totalPrice}", // "12/3/2025",
                  fontSize: 12,
                  fontFamily: "Archivo",
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: "Deposit due today",
                  fontSize: 12,
                  fontFamily: "Roboto",
                  color: whiteColor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                CustomText(
                  text: "\$${cartController.totalPrice}", // "12/3/2025",
                  fontSize: 12,
                  fontFamily: "Archivo",
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),

            SizedBox(height: 12),
            Divider(height: 0.1, color: whiteColor, thickness: 0.2),
            // SizedBox(height: 12),
            // Row(
            //   children: [
            //     CustomText(
            //       text: "Total",
            //       fontSize: 14,
            //       fontFamily: "Roboto",
            //       color: whiteColor,
            //       fontWeight: FontWeight.w500,
            //     ),
            //     Spacer(),
            //     CustomText(
            //       text: "\$20",
            //       fontSize: 18,
            //       fontFamily: "Archivo",
            //       color: whiteColor,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ],
            // ),
            SizedBox(height: 32),
            CustomButton(
              text: "Checkout".toUpperCase(),
              onPressed: () {
                Get.to(() => CheckoutPage());
              },
              backgroundColor: whiteColor,
              minWidth: double.infinity,
              textColor: primaryBlackColor,
              fontSize: 16,
              height: 48,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
