import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/home/home_page.dart';
import 'package:mushiya_beauty/view/profile/main_profile_nav_page.dart'
    show MainProfileNavPage;
import 'package:mushiya_beauty/view/saloon/saloon_page.dart';
import 'package:mushiya_beauty/view/shop/shop_page.dart' show ShopPage;
import 'package:mushiya_beauty/view/try_on/try_on_home_page.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/drawer_widget.dart';
import 'package:svg_flutter/svg.dart';

import '../../controller/profile_controller.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController()).fetchCustomer();
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: primaryBlackColor.withOpacity(0.1),
        border: Border.all(color: whiteColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            CupertinoIcons.home,
            0,
            currentIndex,
            imagePath:
                currentIndex == 0
                    ? 'assets/icons_svg/bar_1_icon.svg'
                    : 'assets/icons_svg/bar_1_unset.svg',
            size: 24,
            image: true,
          ),
          Spacer(),
          _navItem(
            CupertinoIcons.home,
            1,
            currentIndex,
            imagePath:
                currentIndex == 1
                    ? 'assets/icons_svg/bar_2_set.svg'
                    : 'assets/icons_svg/bar_2_icon.svg',
            size: 24,
            image: true,
          ),

          Spacer(),
          _centerIcon(2, currentIndex), // afro icon in center
          Spacer(),
          _navItem(
            CupertinoIcons.home,
            3,
            currentIndex,
            imagePath:
                currentIndex == 3
                    ? 'assets/icons_svg/bar_4_set.svg'
                    : 'assets/icons_svg/bar_4_icon.svg',
            size: 24,
            image: true,
          ),
          Spacer(),
          _navItem(
            CupertinoIcons.home,
            4,
            currentIndex,
            imagePath:
                currentIndex == 4
                    ? 'assets/icons_svg/bar_5_set.svg'
                    : 'assets/icons_svg/bar_5_profile.svg',
            size: 24,
            image: true,
          ),
          // _navItem(Icons.content_cut, 3, currentIndex),
          // _navItem(Icons.person_outline, 4, currentIndex),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    int index,
    int currentIndex, {
    bool? image,
    String? imagePath,
    double? size,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child:
          image == true
              ? CircleAvatar(
                backgroundColor:
                    index == currentIndex ? Colors.white : Colors.transparent,
                child: SvgPicture.asset(
                  imagePath!,
                  height: size,
                  width: size,
                  color: index == currentIndex ? Colors.black : whiteColor,
                ),
              )
              : Icon(
                icon,
                color: index == currentIndex ? Colors.white : Colors.grey,
                size: size,
              ),
    );
  }

  Widget _centerIcon(int index, int currentIndex) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        // padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: whiteColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: currentIndex == index ? 2 : 3,
          ),
        ),
        child: SvgPicture.asset(
          'assets/icons_svg/bar_3_black.svg',
          height: 40,
          // width: size,
          color: primaryBlackColor,
        ),
      ),
    );
  }
}

class BottomBarPage extends StatelessWidget {
  BottomBarPage({super.key});
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    HomePage2(),
    ShopPage(),
    TryOnHomePage(),
    SaloonPage(),
    MainProfileNavPage(),
    // Text("data"),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              CustomButton(
                textColor: primaryBlackColor,
                elevation: 0,
                backgroundColor: whiteColor,
                onPressed: () => Navigator.of(context).pop(false),
                text: 'No',
              ),
              CustomButton(
                elevation: 0,
                backgroundColor: whiteColor,
                textColor: primaryBlackColor,
                onPressed: () => Navigator.of(context).pop(true),
                text: 'Yes',
              ),
            ],
          ),
        );
        return shouldExit;
      },
      child: Scaffold(
        drawer: DrawerWidget(),
        backgroundColor: Colors.black,
        body: Obx(() => pages[controller.selectedIndex.value]),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
          child: Obx(
            () => CustomBottomNavBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeIndex,
            ),
          ),
        ),
      ),
    );
  }
}

Widget customDrawerMenu({
  required String title,
  required VoidCallback onTap,
  IconData? icon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(right: 47.0),
      decoration: BoxDecoration(
        color: primaryBlackColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        // border: Border(
        //   bottom: BorderSide(color: Colors.grey, width: 0.5),
        // ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Row(
          children: [
            CustomText(
              text: title,
              fontSize: 14,
              fontFamily: 'Roboto',
              color: whiteColor,
              fontWeight: FontWeight.w500,
              maxLines: 30,
            ),
            Spacer(),
            Icon(icon ?? Icons.add, color: whiteColor, size: 24),
          ],
        ),
      ),
    ),
  );
}
