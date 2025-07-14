import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Add flutter_slidable
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/checkout/checkout_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import '../../controller/cart_controller.dart';

class SaloonCartPage extends StatelessWidget {
  SaloonCartPage({super.key});
  final CartSaloonController cartController = Get.put(CartSaloonController());

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
        child: Obx(
              () => cartController.cartItems.isEmpty
              ? const Center(child: Text('Your cart is empty!'))
              : Column(
            children: [
              Expanded(
                flex: 9,
                child:  ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return Padding(
                        padding:const EdgeInsets.only(bottom: 24),
                        child: Slidable(
                          key: ValueKey(item.name), // Unique key for each item
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),

                            extentRatio: 0.25,
                            children: [
                              SlidableAction(

                                onPressed: (context) {
                                  cartController.removeFromCart(item.id);
                                },
                                backgroundColor: redColor,
                                foregroundColor: whiteColor,

                                icon: Icons.delete,
                                label: 'Delete',
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          child: Container(
                            // margin: const EdgeInsets.only(bottom: 24),
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
                                children: [
                                  Image.network(
                                    item.image,
                                    height: 75,
                                    width: 88,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'assets/extra_images/placeholder.png', // Replace with your placeholder
                                      height: 75,
                                      width: 88,
                                      fit: BoxFit.cover,
                                    ),
                                    loadingBuilder: (context, child, loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryBlackColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: item.name,
                                          fontSize: 14,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomText(
                                          text: DateFormat("dd-MM-yyyy")
                                              .format(DateTime.parse(item.bookedDate)),
                                          fontSize: 14,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomText(
                                          text: item.timeSlot,
                                          fontSize: 14,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
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
                          ),
                        ),
                      );
                    },

                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  CustomText(
                    text: "Date",
                    fontSize: 12,
                    fontFamily: "Roboto",
                    color: whiteColor.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  const Spacer(),
                  CustomText(
                    text:
                    "${DateFormat("EEE").format(DateTime.now())} ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                    fontSize: 12,
                    fontFamily: "Archivo",
                    color: whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  CustomText(
                    text: "Time",
                    fontSize: 12,
                    fontFamily: "Roboto",
                    color: whiteColor.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  const Spacer(),
                  CustomText(
                    text: "${DateFormat('hh:mm a').format(DateTime.now())}",
                    fontSize: 12,
                    fontFamily: "Archivo",
                    color: whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  CustomText(
                    text: "Grand total",
                    fontSize: 12,
                    fontFamily: "Roboto",
                    color: whiteColor.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  const Spacer(),
                  Obx(
                        () => CustomText(
                      text: "\$${cartController.totalPrice}",
                      fontSize: 12,
                      fontFamily: "Archivo",
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  CustomText(
                    text: "Deposit due today",
                    fontSize: 12,
                    fontFamily: "Roboto",
                    color: whiteColor.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  const Spacer(),
                  Obx(
                        () => CustomText(
                      text: "\$${cartController.totalPrice}",
                      fontSize: 12,
                      fontFamily: "Archivo",
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 0.1, color: whiteColor, thickness: 0.2),
              const SizedBox(height: 32),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}