import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/subscription_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/payment/payment_selection_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class SubscriptionsPage extends StatelessWidget {
  SubscriptionsPage({super.key});
  final controller = Get.put(SubscriptionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Premium membership".toUpperCase(),
          titleImage: true,
          actions: true,

          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CustomText(
                text: "Subscribe to unlock exclusive tutorial videos.",
                fontSize: 16,
                maxLines: 2,
                fontFamily: 'Roboto',
                color: whiteColor.withOpacity(0.80),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24),
            CustomText(
              text: "Choose Your Plan",
              fontSize: 18,
              fontFamily: 'Archivo',
              color: whiteColor.withOpacity(0.80),
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              // height: 81 * 4,
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
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            // padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    controller.selectedPaymentMethod.value ==
                                            method['name']
                                        ? whiteColor
                                        : whiteColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 12.0,
                                top: 20,
                                bottom: 20,
                                left: 12,
                              ),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: method['name']!,
                                    groupValue:
                                        controller.selectedPaymentMethod.value,
                                    activeColor: primaryBlackColor,
                                    fillColor: MaterialStateProperty.all(
                                      primaryBlackColor,
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value =
                                          value!;
                                    },
                                  ),
                                  // const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          leftPadding: 0,
                                          text: method['name']!,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                          color: primaryBlackColor,
                                        ),
                                        CustomText(
                                          leftPadding: 0,
                                          text: method['subText']!,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                          color: primaryBlackColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Spacer(),
                                  // SvgPicture.asset(
                                  //   method['icon']!,
                                  //   height: 17,
                                  //   width: 17,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: "Subscribe to watch".toUpperCase(),
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              height: 48,
              minWidth: double.infinity,
              onPressed: () {
                Get.to(
                  () => PaymentSelectionPage(
                    selectedPaymentMethod: "Subscription",
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
