import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/checkout_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_checkbox.dart';
import 'package:mushiya_beauty/widget/custom_dialog.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:svg_flutter/svg.dart';

import '../../controller/cart_controller.dart';
import '../../controller/payment_controller.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  final controller = Get.put(CheckoutController());
  final paymentController = Get.put(PaymentController());
  final CartSaloonController cartController = Get.find<CartSaloonController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: 'Check out'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Obx(
        () =>
            cartController.cartItems.isEmpty
                ? Center(child: Text('Your cart is empty!'))
                : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Container(
                        // height: 50,
                        decoration: BoxDecoration(
                          // color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: whiteColor, width: 0.3),
                        ),
                        child: ExpansionTile(
                          iconColor: whiteColor,
                          minTileHeight: 50,
                          dense: true,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          // : Border.all(color: whiteColor),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // side: BorderSide(color: whiteColor, width: 1),
                          ),
                          title: Text(
                            'Order Summary ${'\$'}${cartController.totalPrice}',
                          ),
                          childrenPadding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          children: [
                            Obx(
                              () => SizedBox(
                                height:
                                    110 *
                                    double.parse(
                                      cartController.cartItems.length
                                          .toString(),
                                    ),
                                child: ListView.builder(
                                  itemCount: cartController.cartItems.length,
                                  padding: const EdgeInsets.only(bottom: 0),
                                  // padding: EdgeInsets.s,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),

                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                          bottom: 0,
                                          top: 6,
                                          left: 4,
                                        ),
                                        child: Row(
                                          spacing: 12,
                                          children: [
                                            Stack(
                                              clipBehavior:
                                                  Clip.none, // Let positioned overflow if needed
                                              children: [
                                                Image.network(
                                                  cartController
                                                      .cartItems[index]
                                                      .image,
                                                  height: 75,
                                                  width: 88,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: -5,
                                                  right: -5,
                                                  child: CircleAvatar(
                                                    backgroundColor: whiteColor,
                                                    radius: 10,
                                                    child: CustomText(
                                                      text: "1",
                                                      color: primaryBlackColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text:
                                                      cartController
                                                          .cartItems[index]
                                                          .name,
                                                  fontSize: 14,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor,
                                                ),
                                                CustomText(
                                                  text:
                                                      "\$${cartController.cartItems[index].price}",
                                                  fontSize: 18,
                                                  fontFamily: "Archivo",
                                                  fontWeight: FontWeight.w600,
                                                  color: whiteColor,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: "Discount code",
                                    textEditingController:
                                        controller.countryController,
                                    isBorder: true,
                                    textColor: whiteColor,
                                    fillColor: Colors.transparent,
                                    borderColor: whiteColor.withOpacity(0.3),
                                  ),
                                ),
                                CustomButton(
                                  text: 'Apply',
                                  height: 44,
                                  minWidth: 96,
                                  // width: 80,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  backgroundColor: whiteColor,
                                  textColor: primaryBlackColor,
                                  onPressed: () {
                                    print("Apply");
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            // Row(
                            //   spacing: 10,
                            //   children: [
                            //     Expanded(
                            //       child: CustomTextField(
                            //         hintText: "Mushiya bucks",
                            //         textEditingController:
                            //             controller.countryController,
                            //         isBorder: true,
                            //         fillColor: Colors.transparent,
                            //         textColor: whiteColor,
                            //         suffixIcon: CustomText(
                            //           text: "\$20",
                            //           fontSize: 12,

                            //           fontWeight: FontWeight.w400,
                            //           fontFamily: 'Roboto',
                            //           color: whiteColor,
                            //         ),
                            //         borderColor: whiteColor.withOpacity(0.3),
                            //       ),
                            //     ),
                            //     CustomButton(
                            //       text: 'Apply',
                            //       height: 44,
                            //       minWidth: 96,
                            //       // width: 80,
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.w500,
                            //       backgroundColor: whiteColor,
                            //       textColor: primaryBlackColor,
                            //       onPressed: () {
                            //         print("Apply");
                            //       },
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 12),
                            Row(
                              children: [
                                CustomText(
                                  text:
                                      "Sub total (${cartController.cartItems.length} items)",
                                  fontSize: 12,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                                Spacer(),
                                CustomText(
                                  text: "\$${cartController.totalPrice}",
                                  fontSize: 12,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                              ],
                            ),
                            // SizedBox(height: 12),
                            // Row(
                            //   children: [
                            //     CustomText(
                            //       text: "Shipping",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //     Spacer(),
                            //     CustomText(
                            //       text: "\$00",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 12),
                            // Row(
                            //   children: [
                            //     CustomText(
                            //       text: "Taxes",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //     Spacer(),
                            //     CustomText(
                            //       text: "\$00",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 12),
                            // Row(
                            //   children: [
                            //     CustomText(
                            //       text: "Tip",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //     Spacer(),
                            //     CustomText(
                            //       text: "\$00",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                CustomText(
                                  text: "Discount",
                                  fontSize: 12,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                                Spacer(),
                                CustomText(
                                  text: "-\$00",
                                  fontSize: 12,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                              ],
                            ),
                            // SizedBox(height: 12),
                            // Row(
                            //   children: [
                            //     CustomText(
                            //       text: "Mushiya bucks",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //     Spacer(),
                            //     CustomText(
                            //       text: "-\$00",
                            //       fontSize: 12,
                            //       fontFamily: "Roboto",
                            //       fontWeight: FontWeight.w400,
                            //       color: whiteColor,
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                CustomText(
                                  text: "Total",
                                  fontSize: 12,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                                Spacer(),
                                CustomText(
                                  text: "\$${cartController.totalPrice}",
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                      CustomText(
                        text: "Delivery Information",
                        fontSize: 18,
                        fontFamily: "Archivo",
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                      ),
                      CustomTextField(
                        hintText: "Name",
                        textEditingController: controller.nameController,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "Address 1",
                        textEditingController: controller.address1Controller,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "Address 2",
                        textEditingController: controller.address2Controller,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "Country",
                        textEditingController: controller.countryController,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "City",
                        textEditingController: controller.cityController,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "State",
                        textEditingController: controller.stateController,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "Postal code",
                        textEditingController: controller.pCodeController,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        keyboardType: TextInputType.number,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomTextField(
                        hintText: "Phone Number",
                        textEditingController: controller.phoneNoController,
                        isBorder: true,
                        textColor: whiteColor,
                        fillColor: Colors.transparent,
                        keyboardType: TextInputType.phone,
                        borderColor: whiteColor.withOpacity(0.3),
                      ),
                      CustomText(
                        text: "Add tip",
                        fontSize: 18,
                        fontFamily: "Archivo",
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,

                        child: CustomCheckboxWithText(
                          color: whiteColor,
                          subUnderlineText: "",
                          text:
                              "Show your support for the team at Mushiya Beauty",
                          textSize: 16,
                          textColor: whiteColor.withOpacity(0.5),

                          isChecked: controller.isCheckedSupport,
                          onTap: () {
                            controller.isCheckedSupport.value =
                                !controller.isCheckedSupport.value;
                          },
                        ),
                      ),

                      CustomText(
                        text: "Payment method",
                        fontSize: 18,
                        fontFamily: "Archivo",
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 70 * 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:
                              controller.paymentMethods.map((method) {
                                return Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.selectedPaymentMethod.value =
                                          method['name']!;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      // padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              controller
                                                          .selectedPaymentMethod
                                                          .value ==
                                                      method['name']
                                                  ? whiteColor
                                                  : whiteColor,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: method['name']!,
                                              groupValue:
                                                  controller
                                                      .selectedPaymentMethod
                                                      .value,
                                              activeColor: primaryBlackColor,
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                    primaryBlackColor,
                                                  ),
                                              onChanged: (value) {
                                                controller
                                                    .selectedPaymentMethod
                                                    .value = value!;
                                              },
                                            ),
                                            // const SizedBox(width: 12),
                                            Expanded(
                                              child: CustomText(
                                                leftPadding: 0,
                                                text: method['name']!,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color: primaryBlackColor,
                                              ),
                                            ),
                                            Spacer(),
                                            SvgPicture.asset(
                                              method['icon']!,
                                              height: 17,
                                              width: 17,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      CustomButton(
                        text: "Pay now".toUpperCase(),
                        onPressed: () {
                          if(FirebaseAuth.instance.currentUser == null){
                            Get.snackbar(
                              "Error",
                              "Please login to continue.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          if (controller.nameController.text.isEmpty ||
                              controller.address1Controller.text.isEmpty ||
                              controller.countryController.text.isEmpty ||
                              controller.cityController.text.isEmpty ||
                              controller.stateController.text.isEmpty ||
                              controller.pCodeController.text.isEmpty ||
                              controller.phoneNoController.text.isEmpty) {
                            Get.snackbar(
                              "Missing Fields",
                              "Please fill all required delivery information.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (controller.selectedPaymentMethod.value.isEmpty) {
                            Get.snackbar(
                              "Payment Method",
                              "Please select a payment method.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (controller.phoneNoController.text.length < 7) {
                            Get.snackbar(
                              "Phone Number",
                              "Please enter a valid phone number.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          /// Proceed to payment
                          print(controller.selectedPaymentMethod.value);

                          if (controller.selectedPaymentMethod.value == "Stripe") {
                            paymentController.makePayment(
                              price: cartController.totalPrice.toString(),
                            );
                          } else if (controller.selectedPaymentMethod.value == "PayPal") {
                            Get.defaultDialog(title: "PayPal", content: Text("Coming soon"));
                          }
                        },

                        isPrefixIcon: false,
                        minWidth: double.infinity,
                        backgroundColor: whiteColor,
                        textColor: primaryBlackColor,
                        height: 48,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
      ),
    );
  }
}
