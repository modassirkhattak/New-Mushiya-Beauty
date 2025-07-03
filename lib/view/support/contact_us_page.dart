import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/policy_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';

import 'package:mushiya_beauty/widget/custom_textfield.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});
  final PolicyController controller = Get.put(PolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Contact Us".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Center(
                    child: CircularProgressIndicator(color: whiteColor),
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.retryContactUsList,
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.contactUsList.value == null) {
                return const Center(child: Text('Contact us not found'));
              }

              final policy = controller.contactUsList.value!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: policy.body,
                    shrinkWrap: true,
                    style: {
                      'p': Style(
                        fontSize: FontSize(16),
                        fontFamily: "Roboto",

                        fontWeight: FontWeight.w400,

                        color: whiteColor.withOpacity(0.8),
                      ),
                      'strong': Style(
                        fontSize: FontSize(16),
                        fontFamily: "Roboto",
                        // fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                      ),
                      'ul': Style(
                        fontSize: FontSize(16),
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        color: whiteColor.withOpacity(0.8),
                      ),
                    },
                  ),
                ],
              );
            }),

            // CustomText(
            //   text: "Feel free to contact us if you need any help.",
            //   fontWeight: FontWeight.w400,
            //   textAlign: TextAlign.justify,
            //   fontSize: 16,
            //   fontFamily: "Roboto",
            //   maxLines: 1000,
            //   color: whiteColor.withOpacity(0.8),
            // ),
            // SizedBox(height: 20),
            // Row(
            //   spacing: 16,
            //   children: [
            //     SvgPicture.asset(
            //       'assets/icons_svg/email.svg',
            //       color: whiteColor,
            //       height: 24,
            //       width: 30,
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         CustomText(
            //           text: "Email",
            //           fontWeight: FontWeight.w500,
            //           textAlign: TextAlign.justify,
            //           fontSize: 16,
            //           fontFamily: "Roboto",
            //           maxLines: 1000,
            //           color: whiteColor,
            //         ),
            //         CustomText(
            //           text: "Support@example.com",
            //           fontWeight: FontWeight.w400,
            //           textAlign: TextAlign.justify,
            //           fontSize: 12,
            //           fontFamily: "Roboto",
            //           maxLines: 1000,
            //           color: whiteColor.withOpacity(0.3),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20),
            CustomTextField(
              hintText: "Name",
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            CustomTextField(
              hintText: "Email",
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            CustomTextField(
              hintText: "Message",
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 32),
            CustomButton(
              text: "Submit".toUpperCase(),
              onPressed: () {
                // showDialog(
                //   context: context,
                //   barrierDismissible: true,
                //   barrierColor: primaryBlackColor.withOpacity(0.8),

                //   builder:
                //       (context) => const ResetLinkDialog(
                //         text: "Your order has been placed successfully",
                //         iconPath: "assets/icons_svg/done_check_icon.svg",
                //         condition: "order_success",
                //       ),
                // );
              },
              isPrefixIcon: false,
              minWidth: double.infinity,
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              height: 48,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
