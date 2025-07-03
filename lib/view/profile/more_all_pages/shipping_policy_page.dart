import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/policy_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';

class TheShoppingPolicyPage extends StatelessWidget {
  TheShoppingPolicyPage({super.key, required this.isPage});

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    final PolicyController controller = Get.put(PolicyController());

    return Scaffold(
      appBar:
          isPage == false
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: MyAppBarWidget(
                  title: "Shipping policy".toUpperCase(),
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
                  onPressed: controller.retryShippingFetch,
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.shippingPrivacyPolicy.value == null) {
          return const Center(child: Text('Shipping Privacy policy not found'));
        }

        final policy = controller.shippingPrivacyPolicy.value!;
        return SingleChildScrollView(
          padding:
              isPage == false
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: policy.body,
                shrinkWrap: true,
                style: {
                  'p': Style(
                    fontSize: FontSize.medium,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withOpacity(0.8),
                  ),
                  'strong': Style(
                    fontSize: FontSize.medium,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withOpacity(0.8),
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mushiya_beauty/controller/product_details_controller.dart';
// import 'package:mushiya_beauty/model/home_model.dart';
// import 'package:mushiya_beauty/utills/app_colors.dart';
// import 'package:mushiya_beauty/widget/custom_appbar.dart';

// import 'package:mushiya_beauty/widget/custom_text.dart';

// class TheShoppingPolicyPage extends StatelessWidget {
//   TheShoppingPolicyPage({super.key});

//   final controller = Get.put(ProductDetailsController());

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: MyAppBarWidget(
//             title: "Shipping policy".toUpperCase(),
//             titleImage: true,
//             actions: true,
//             actionsWidget:
//                 null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
//             leadingButton: true,
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 16,
//             children: [
//               CustomText(
//                 text: 'Shipping & custom policy',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: whiteColor,
//                 fontWeight: FontWeight.w600,
//               ),
//               CustomText(
//                 text: 'Express and priority shipping',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: whiteColor,
//                 fontWeight: FontWeight.w600,
//               ),

//               CustomText(
//                 text:
//                     'For all Express and Priority Shipping requests, please expect up to 3-5 business days for delivery due to a processing period of 2-3 days before shipment.',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text: 'Standard Shipping',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: whiteColor,
//                 fontWeight: FontWeight.w600,
//               ),
//               CustomText(
//                 text:
//                     "Orders are running on a 3-5 business day processing/production time. Weekends and Holidays do not count. Once shipped, please allow 4-6 business days to receive your order if you are in the United States and 10-20 business days for international orders.",
//                 // 'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text:
//                     "Please note that we are not responsible for any shipping/delivery delays. We encourage our customers to allow ample time for delivery as well as unplanned delays. If your order has already shipped and you contact us with an address change, you are responsible for the additional shipping charges. Abandoned and refused packages will not be refunded.",
//                 // 'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text: 'CUSTOMS POLICY',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: whiteColor,
//                 fontWeight: FontWeight.w600,
//               ),
//               CustomText(
//                 text:
//                     "All international orders must go through customs. Customs policies and procedures vary per country. It is your responsibility to pay any customs fees or duties required to receive your package. ",
//                 // 'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text: 'BABY NAPS CUSTOM WIG ORDERS',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: whiteColor,
//                 fontWeight: FontWeight.w600,
//               ),
//               CustomText(
//                 text:
//                     "Please allow approximately of 5-10 business days for production and shipping for custom made wigs if you are in the United States. Please allow extra 5-10 business days for international orders.",
//                 // 'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget tabbarView({required HomeModel homeModel, required String title}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     spacing: 12,
//     children: [
//       CustomText(
//         text: title,
//         fontSize: 18,
//         fontFamily: 'Archivo',
//         color: whiteColor,
//         fontWeight: FontWeight.w600,
//       ),
//       CustomText(
//         text:
//             'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla. ',
//         fontSize: 12,
//         fontFamily: 'Roboto',
//         color: whiteColor,
//         maxLines: 90,
//         fontWeight: FontWeight.w400,
//       ),
//     ],
//   );
// }
