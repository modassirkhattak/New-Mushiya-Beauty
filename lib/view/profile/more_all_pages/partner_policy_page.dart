import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/policy_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';

class PartnerPolicyPage extends StatelessWidget {
  PartnerPolicyPage({super.key, required this.isPage, required this.handle});

  final bool isPage;
  final String handle;

  @override
  Widget build(BuildContext context) {
    final PolicyController controller = Get.put(PolicyController());

    return Scaffold(
      // backgroundColor: redColor,
      appBar:
          isPage == false
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: MyAppBarWidget(
                  title: "Return policy".tr.toUpperCase(),
                  titleImage: true,
                  actions: true,
                  actionsWidget:
                      null, //SvgPicture.asset('assets/icons_svg/share_icon.svg'),
                  leadingButton: true,
                ),
              ),
      body: Obx(() {
        if (controller.isPolicyLoading.value) {
          return const Center(
            child: Center(child: CircularProgressIndicator(color: whiteColor)),
          );
        }

        final page = controller.page.value;

        if (page == null) {
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
                  onPressed: controller.retryPageContent(handle),
                  child:  Text(
                    'Retry'.tr,
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.page.value == null) {
          return  Center(child: Text('Return Policy not found'.tr));
        }

        final policy = controller.page.value!;
        return SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    fontSize: FontSize(14),
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

//
//import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mushiya_beauty/controller/product_details_controller.dart';
// import 'package:mushiya_beauty/utills/app_colors.dart';
// import 'package:mushiya_beauty/widget/custom_appbar.dart';

// import 'package:mushiya_beauty/widget/custom_text.dart';

// class PartnerPolicyPage extends StatelessWidget {
//   PartnerPolicyPage({super.key});

//   final controller = Get.put(ProductDetailsController());

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: MyAppBarWidget(
//             title: "Return policy".toUpperCase(),
//             titleImage: true,
//             actions: true,
//             actionsWidget:
//                 null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
//             leadingButton: true,
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 16,
//             children: [
//               CustomText(
//                 text: 'NEED TO MAKE AN EXCHANGE?  NO PROBLEM! ',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: whiteColor,
//                 fontWeight: FontWeight.w600,
//               ),

//               CustomText(
//                 text:
//                     'Mushiya Beauty is pleased to accommodate all exchange requests. To get started with your exchange, you must contact us immediately per the following– ',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text:
//                     'Within 7 days of receipt of your product, please contact Mushiya Beauty 24/7 Customer Service Representatives via chat at MushiyaBeauty.com. They will gladly facilitate your exchange request. If you can not reach our Customer Service Representatives via chat then you may also email your exchange request to info@mushiyabeauty.com for further assistance. ',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text:
//                     'Please be aware that before any exchange, store credit or replacement order is done, your return must pass quality control. There will be no exchanges on hair that has been worn, washed, colored, lifted, straightened, permed or chemically altered. Lastly, all exchange requests must be submitted within 7 days of receipt of your product. ',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text: 'Abandoned and refused packages will not be refunded. ',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text:
//                     'The customer is responsible for all shipping costs associated with an exchange.',
//                 fontSize: 16,
//                 fontFamily: 'Roboto',
//                 color: whiteColor.withOpacity(0.80),
//                 fontWeight: FontWeight.w400,
//                 maxLines: 30,
//               ),
//               CustomText(
//                 text: 'NO REFUNDS. EXCHANGES ONLY.',
//                 maxLines: 2,
//                 fontSize: 18,
//                 fontFamily: 'Archivo',
//                 color: redColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
