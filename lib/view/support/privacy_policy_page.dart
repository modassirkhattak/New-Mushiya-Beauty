import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/policy_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PolicyController controller = Get.put(PolicyController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Privacy Policy".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget:
              null, //SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Center(child: CircularProgressIndicator(color: whiteColor)),
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
                  onPressed: controller.retryFetch,
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.privacyPolicy.value == null) {
          return const Center(child: Text('Privacy policy not found'));
        }

        final policy = controller.privacyPolicy.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: policy.body,
                shrinkWrap: true,
                style: {
                  'p': Style(
                    fontSize: FontSize(14),
                    fontFamily: "Roboto",

                    fontWeight: FontWeight.w400,

                    color: whiteColor.withOpacity(0.8),
                  ),
                  'strong': Style(
                    fontSize: FontSize(18),
                    fontFamily: "Roboto",
                    // fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                  'ul': Style(
                    fontSize: FontSize.medium,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withOpacity(0.8),
                  ),
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
