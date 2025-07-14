import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/blog_controllers.dart';
import 'package:mushiya_beauty/controller/login_provider.dart';
import 'package:mushiya_beauty/controller/profile_controller.dart';
import 'package:mushiya_beauty/utills/api_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/utills/comman_dialog.dart';
import 'package:mushiya_beauty/view/auth/stated_page.dart';
import 'package:mushiya_beauty/view/language/choose_language_screen.dart';
import 'package:mushiya_beauty/view/language/controller/language_controller.dart';
import 'package:mushiya_beauty/view/orders_history/orders_history_page.dart';
import 'package:mushiya_beauty/view/profile/edit_profile_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/blog_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/partner_policy_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/shipping_policy_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/social_media_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/the_ceo_page.dart';
import 'package:mushiya_beauty/view/subscriptions/subscriptions_page.dart';
import 'package:mushiya_beauty/view/support/about_us_page.dart';
import 'package:mushiya_beauty/view/support/contact_us_page.dart';
import 'package:mushiya_beauty/view/support/privacy_policy_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/drawer_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/policy_controller.dart';
class MainProfileNavPage extends StatelessWidget {
  MainProfileNavPage({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Get.find<LanguageController>().initializeAllLanguages(context);
    // controller.fetchCustomer
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          // title: ''.toUpperCase() ?? 'All products'.toUpperCase(),
          titleImage: false,
          actions: true,
          actionsWidget: null,
          leadingButton: false,
        ),
      ),
      body: Obx(
          ()=> controller.isProfileLoading.value  ?Center(child: CircularProgressIndicator(color: whiteColor,)) :SingleChildScrollView(
          child: Column(
            // spacing: 16,
            children: [
              Container(
                // color: Colors.white,
                margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                // margin: EdgeInsets.only(left: 16),
                child:
                    FirebaseAuth.instance.currentUser == null
                        ? CustomText(
                          text: "Guest Mode".tr,
                          fontWeight: FontWeight.w500,
                          color: primaryBlackColor,
                          fontSize: 14,
                          fontFamily: "Roboto",
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/extra_images/profile_user.png',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        Get.put(
                                          ProfileController(),
                                        ).nameController.text,

                                    fontWeight: FontWeight.w500,
                                    color: primaryBlackColor,
                                    fontSize: 14,
                                    fontFamily: "Roboto",
                                  ),

                                  CustomText(
                                    text: controller.emailController.text,
                                    fontSize: 12,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400,
                                    color: primaryBlackColor,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  minimumSize: Size(90, 26),
                                  maximumSize: Size(90, 26),
                                  padding: EdgeInsets.all(0),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => EditProfilePage());
                                },
                                child: CustomText(
                                  text: 'Edit Profile'.tr,
                                  fontSize: 12,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
              // Profile Section
              SizedBox(height: 0),
              // sectionTitle('Profile'),
              menuItem(
                'assets/icons_svg/language.svg',
                'Language'.tr,
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (_) => showLanguageDialog(),
                    ),
                // onPressed: () => Get.to(ChooseLanguageScreen()),
              ),
              FirebaseAuth.instance.currentUser == null
                  ? SizedBox.shrink()
                  : menuItem(
                    'assets/icons_svg/change_pass.svg',
                    'Change Password'.tr,
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder:
                              (_) => showChangePasswordDialog(
                                Get.put(ProfileController()),
                              ),
                        ),
                  ),
              // SizedBox(height: 16),
              // sectionTitle('About'),
              menuItem('assets/icons_svg/brand.svg', 'The Brand', onPressed: () async {
                final uri = Uri.parse(
                  controller.brandUrl.value,
                );
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $uri')),
                  );
                }
              },),
              menuItem('assets/icons_svg/non_profile.svg', 'The non Profit', onPressed: () async {
                final uri = Uri.parse(
                  controller.theNonProfiftUrl.value,
                );
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $uri')),
                  );
                }
              },),
              menuItem(
                'assets/icons_svg/the_ceo.svg',
                'The CEO'.tr,
                onPressed: () => Get.to(() => TheCeoPage()),
              ),
              // SizedBox(height: 16),
              // sectionTitle('Account'),
              FirebaseAuth.instance.currentUser == null
                  ? Container()
                  : menuItem(
                    'assets/icons_svg/order_summ.svg',
                    'Order History'.tr,
                    onPressed: () => Get.to(() => OrderHistoryScreen()),
                  ),
              FirebaseAuth.instance.currentUser == null
                  ? Container()
                  : menuItem(
                    'assets/icons_svg/subscription.svg',
                    'Subscription'.tr,
                    onPressed: () => Get.to(() => SubscriptionsPage()),
                  ),
              // SizedBox(height: 16),
              // sectionTitle('Community & Social'),
              menuItem(
                'assets/icons_svg/people.svg',
                'Social'.tr,
                onPressed: () => Get.to(() => SocialMediaPage()),
              ),
              menuItem('assets/icons_svg/media.svg', 'Media & Press',
                onPressed: () async {
                  final uri = Uri.parse(
                    controller.mediaPressUrl.value,
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $uri')),
                    );
                  }
                },),
              menuItem(
                'assets/icons_svg/blog_icon.svg',
                'Blog'.tr,
                onPressed: () {
                  Get.put(BlogControllers()).fetchBlogs();
                  showDialog(context: context, builder: (_) => dialogBox());
                },
              ),
              menuItem('assets/icons_svg/broadcast.svg', 'Podcast',
                onPressed: () async {
                  final uri = Uri.parse(
                    controller.podCastUrl.value,
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $uri')),
                    );
                  }
                },),
              // SizedBox(height: 16),
              // sectionTitle('Policies'),
              menuItem(
                'assets/icons_svg/delivery.svg',
                'Shipping Policy'.tr,
                onPressed:
                    () {
                      Get.put(PolicyController()).fetchPageContent(SHIPPING_POLICY);
                      Get.to(() => PartnerPolicyPage(isPage: true,handle: SHIPPING_POLICY));
                      // Get.to(() => TheShoppingPolicyPage(isPage: true));
                    },
              ),
              menuItem(
                'assets/icons_svg/store_policy.svg',
                'Return Policy'.tr,
                onPressed: () {
                  Get.put(PolicyController()).fetchPageContent(RETURN_POLICY);
                  Get.to(() => PartnerPolicyPage(isPage: true,handle: RETURN_POLICY));
                },
              ),
              menuItem(
                'assets/icons_svg/partner.svg',
                'Partner with Us'.tr,
                onPressed:
                    () {
                  Get.put(PolicyController()).fetchPageContent(PARTNER_POLICY);
                  Get.to(() => PartnerPolicyPage(isPage: true,handle: PARTNER_POLICY));
                  // Get.to(() => TheShoppingPolicyPage(isPage: true));
                },
              ),
              // menuItem(
              //   'assets/icons_svg/partner.svg',
              //   'Partner with Us',
              //   onPressed: () => Get.to(() => TermsConditionPage()),
              // ),

              // SizedBox(height: 16),
              // sectionTitle('Support'),
              menuItem(
                'assets/icons_svg/about_us.svg',
                'About Us'.tr,
                onPressed: () => Get.to(AboutUsPage()),
              ),
              menuItem(
                'assets/icons_svg/privacy_policy.svg',
                'Privacy Policy'.tr,
                onPressed: () => Get.to(PrivacyPolicyPage()),
              ),
              menuItem(
                'assets/icons_svg/contact_us.svg',
                'Contact Us'.tr,
                onPressed: () => Get.to(ContactUsPage()),
              ),
              FirebaseAuth.instance.currentUser == null
                  ? menuItem(
                    'assets/icons_svg/logout.svg',
                    'Login'.tr,
                    onPressed: () => Get.to(StatedPage()),
                  )
                  : menuItem(
                    'assets/icons_svg/logout.svg',
                    'Logout'.tr,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context:
                            Get.context!, // Use Get.context if you're using GetX
                        builder:
                            (BuildContext context) => CupertinoActionSheet(
                              title:  CustomText(
                                text: "Logout?".tr,
                                color: whiteColor,
                                fontFamily: "Roboto",
                                textAlign: TextAlign.center,
                              ),
                              message:  CustomText(
                                text: "Are you sure you want to logout?".tr,
                                color: whiteColor,
                                fontFamily: "Roboto",
                                textAlign: TextAlign.center,
                              ),
                              // message: const Text('Are you sure you want to logout?'),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    // Call your logout logic here
                                    Get.put(ShopifyAuthService()).logout();
                                    Get.back(); // Close the action sheet
                                  },
                                  child:  CustomText(
                                    text: "Yes".tr,
                                    color: redColor,
                                    fontFamily: "Roboto",
                                  ),
                                  isDestructiveAction: true,
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Get.back(); // Close the action sheet
                                  },
                                  child: CustomText(
                                    text: "No".tr,
                                    color: whiteColor,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Get.back(); // Close the sheet
                                },
                                child:  CustomText(
                                  text: "Cancel".tr,
                                  color: whiteColor,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      width: double.infinity,
      color: Colors.white,
      child: CustomText(
        text: title,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: "Archivo",
      ),
    );
  }
}

Widget menuItem(
  String icon,
  String title, {
  VoidCallback? onPressed,
  Color? color,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    // color: Colors.black,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
        colors: [
          whiteColor.withOpacity(0.3),
          primaryBlackColor.withOpacity(0.6),
        ],
      ),
      // border: Border(
      //   bottom: BorderSide(width: 1, color: whiteColor.withOpacity(0.1)),
      // ),
    ),
    child: ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // side: BorderSide(color: Color)
      ),
      leading: SvgPicture.asset(
        icon,
        height: 24,
        width: 24,
        color: color,
        // color: whiteColor.withOpacity(0.80),
      ),

      title: CustomText(
        text: title,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: "Roboto",
        color: whiteColor,
      ),
      // title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
      onTap: onPressed,
    ),
  );
}

dialogBox() {
  final controller = Get.put(BlogControllers());

  return AlertDialog(
    backgroundColor: Colors.white,
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: Center(
      child: CustomText(
        text: 'Select Option'.tr,
        color: primaryBlackColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: "Roboto",
      ),
    ),
    content: Container(
      width: Get.width * 0.78, // 95% of screen width
      height: Get.width * 0.60,
      child: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(
            height: 200,
            width: Get.width * 0.78,
            child: Center(
              child: CircularProgressIndicator(color: primaryBlackColor),
            ),
          );
        } else if (controller.errorMessage.isNotEmpty) {
          return Text(controller.errorMessage.value);
        } else if (controller.blogs.isEmpty) {
          return Center(
            child: Text(
              'No blogs found'.tr,
              style: TextStyle(color: Colors.red, fontFamily: "Roboto"),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.blogs.length,
          itemBuilder: (context, index) {
            final item = controller.blogs[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    // side: BorderSide(color: Color)
                  ),

                  // leading: SvgPicture.asset(
                  //   icon,
                  //   height: 24,
                  //   width: 24,
                  //   // color: whiteColor.withOpacity(0.80),
                  // ),
                  title: CustomText(
                    text: item.title,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: "Roboto",
                    color: primaryBlackColor,
                  ),

                  trailing: Icon(Icons.chevron_right, color: primaryBlackColor),
                  onTap: () {
                    print(item.id);
                    Get.back();
                    controller.fetchBlogDetails(item.id.toString());
                    Get.to(() => BlogPage());
                    // Get.to(() => BlogDetailsPage(blogsModel: item));
                  },
                ),
              ],
            );
          },
        );
      }),
    ),

    // ),
  );
}
