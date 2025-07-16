import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mushiya_beauty/controller/side_menu_controller.dart';
import 'package:mushiya_beauty/model/side_menu_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/become_affiliate/become_affiliate_start_page.dart';
import 'package:mushiya_beauty/view/bottom_bar/bottom_bar_page.dart';
import 'package:mushiya_beauty/view/event/event_home_page.dart';
import 'package:mushiya_beauty/view/rewards/reward_start_page.dart';
import 'package:mushiya_beauty/view/tutorials/tutorials_home_page.dart';
import 'package:mushiya_beauty/widget/custom_expansion_tile.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

import '../utills/services.dart';
import '../view/home/side_menu_collec_page.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final SideMenuController _controller = Get.put(SideMenuController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: greyColor,
      backgroundColor: Colors.black.withOpacity(0.8),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),

      shadowColor: Colors.grey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (_controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _controller.errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _controller.fetchMenus,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Find the menu with handle 'new-menu'
                  final newMenu = _controller.menuResponse.menus.firstWhere(
                    (menu) => menu.handle == 'mushiya-beauty-app-menu',
                    orElse:
                        () => MenuModel(
                          id: '',
                          handle: '',
                          title: 'No New Menu Found',
                          items: [],
                        ),
                  );

                  return _buildNewMenu(newMenu);
                }),

                customDrawerMenu(
                  title: 'Rewards',
                  icon: Icons.arrow_forward_ios,
                  onTap: () {
                    Get.to(() => RewardStartPage());
                  },
                ),
                customDrawerMenu(
                  title: 'Tutorials',
                  icon: Icons.arrow_forward_ios,
                  onTap: () {
                    Get.to(() => TutorialsHomePage());
                  },
                ),
                customDrawerMenu(
                  title: 'Events',
                  icon: Icons.arrow_forward_ios,
                  onTap: () {
                    Get.to(EventHomePage());
                  },
                ),
                // customDrawerMenu(
                //   title: 'Social media share',
                //   icon: Icons.arrow_forward_ios,
                //   onTap: () {},
                // ),
                customDrawerMenu(
                  title: 'Become affiliate',
                  icon: Icons.arrow_forward_ios,
                  onTap: () {
                    Get.to(() => BecomeAffiliateStartPage());
                  },
                ),
                // customDrawerMenu(
                //   title: 'Currency',
                //   icon: Icons.arrow_forward_ios,
                //   onTap: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildNewMenu(MenuModel menu) {
  return SizedBox(
    // height: 200,
    child: ListView(
      padding: EdgeInsets.only(right: 36),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,

      children: menu.items.map((item) => _buildMenuItem(item)).toList(),
    ),
  );
}

Widget _buildMenuItem(MenuItem item, {int level = 0, String? parentId}) {
  final SideMenuController _controller = Get.put(SideMenuController());

  final bool hasChildren = item.items.isNotEmpty;
  final bool isSelfReferencing = item.id == parentId;

  if (isSelfReferencing) return const SizedBox.shrink();

  return Padding(
    padding: EdgeInsets.only(left: level * 8.0, right: 8, top: 4),
    child: Card(
      color: primaryBlackColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: hasChildren
          ? ExpansionTile(
        iconColor: whiteColor,
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: CustomText(
          text: item.title,
          fontSize: 12,
          fontFamily: 'Roboto',
          color: whiteColor,
          fontWeight: FontWeight.w500,
          maxLines: 1,
        ),
        children: item.items
            .where((child) => child.id != item.id) // avoid self loop
            .map((child) => _buildMenuItem(child, level: level + 1, parentId: item.id))
            .toList(),
      )
          : ListTile(
        onTap: () {
          if (item.type == "PRODUCT") {
            final lastSegment = item.url.split('/').last;
            // ApiServices().fetchProductByHandle(lastSegment);
            _controller.refreshProductsCollect(collectionId: lastSegment, isProduct: true);
          } else {
            final lastSegment = item.url.split('/').last;
            // _controller.fetchIn/itialProducts(collectionId: lastSegment);
            _controller.refreshProducts(collectionId: lastSegment, isProduct: false);
            // Get.to(() => ShopifyProductGrid(id: lastSegment, title: item.title));
          }
        },
        dense: true,
        visualDensity: const VisualDensity(vertical: -3),
        title: CustomText(
          text: item.title,
          fontSize: 12,
          fontFamily: 'Roboto',
          color: whiteColor,
          fontWeight: FontWeight.w500,
          maxLines: 1,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
    ),
  );
}

// Widget _buildMenuItem(MenuItem item, {int level = 0}) {
//   final SideMenuController _controller = Get.put(SideMenuController());
//   return GestureDetector(
//     onTap: () {
//       if (item.type == "PRODUCT") {
//         String url = item.url;
//         String lastSegment = url.split('/').last;
//         print('lastSegment: $lastSegment');
//         ApiServices().fetchProductByHandle(lastSegment);
//       } else {
//         print('collectionId: ${item.url}');
//         String url = item.url;
//         String lastSegment = url.split('/').last;
//         print('lastSegment: $lastSegment');
//         _controller.fetchInitialProducts(collectionId: lastSegment);
//         Get.to(() => ShopifyProductGrid(id: lastSegment, title: item.title));
//       }
//     },
//     child: Padding(
//       padding: EdgeInsets.only(left: level * 8.0, right: 8, top: 4),
//       child: Card(
//         color: primaryBlackColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(12),
//             bottomRight: Radius.circular(12),
//           ),
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         child: ExpansionTile(
//           iconColor: whiteColor,
//           // minTileHeight: 55,
//           dense: true,
//           internalAddSemanticForOnTap: true,
//           controller: ExpansionTileController(),
//           clipBehavior: Clip.antiAlias,
//           maintainState: true,
//           shape: BeveledRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(10),
//               bottomRight: Radius.circular(10),
//             ),
//           ),
//           tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//           collapsedShape: BeveledRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(10),
//               bottomRight: Radius.circular(10),
//             ),
//           ),
//
//           // tilePadding: const EdgeInsets.symmetric(horizontal: 16),
//           title: CustomText(
//             text: item.title,
//             fontSize: 12,
//             fontFamily: 'Roboto',
//             color: whiteColor,
//             fontWeight: FontWeight.w500,
//             maxLines: 1,
//           ),
//           // subtitle: Text('${item.type} - ${item.url}'),
//           children: [
//             if (item.items.isNotEmpty)
//               ...item.items.map(
//                 (child) => _buildMenuItem(child, level: level + 1),
//               )
//             else
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Container(
//                   margin: EdgeInsets.only(left: 0.0),
//                   decoration: BoxDecoration(
//                     color: primaryBlackColor,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(12),
//                       bottomRight: Radius.circular(12),
//                     ),
//                     // border: Border(
//                     //   bottom: BorderSide(color: Colors.grey, width: 0.5),
//                     // ),
//                   ),
//
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 5,
//                     ),
//                     child: Row(
//                       spacing: 12,
//                       children: [
//                         // Image.asset(
//                         //   'assets/extra_images/teeth_1.png',
//                         //   width: 24,
//                         //   height: 24,
//                         // ),
//                         CustomText(
//                           text: item.title,
//                           fontSize: 12,
//                           fontFamily: 'Roboto',
//                           color: whiteColor,
//                           fontWeight: FontWeight.w500,
//                           maxLines: 2,
//                         ),
//                         // Spacer(),
//                         // Icon(icon ?? Icons.add, color: whiteColor, size: 24),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // child: ListTile(
//                 //   minVerticalPadding: 0,
//                 //   contentPadding: EdgeInsets.zero,
//                 //   title: const Text('Open'),
//                 //   subtitle: Text(item.url),
//                 //   trailing: const Icon(Icons.arrow_forward_ios, size: 14),
//                 //   onTap: () {
//                 //     // Open link or navigate
//                 //     // Example:
//                 //     // launchUrl(Uri.parse("https://yourdomain.com${item.url}"));
//                 //   },
//                 // ),
//               ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

/*************  ✨ Windsurf Command ⭐  *************/
/// Creates a custom drawer submenu widget with a title, optional icon, and
/// an onTap callback.
///
/// The widget is a [GestureDetector] that responds to tap events. It displays
/// the given [title] as text and an optional [icon], defaulting to [Icons.add]
/// if none is provided. The widget has a black background and rounded corners
/// on the top right and bottom right sides.
///
/// Parameters:
/// - [title]: The title text to display in the submenu.
/// - [onTap]: The callback function to execute when the submenu is tapped.
/// - [icon]: An optional icon to display next to the title. Defaults to [Icons.add].
///
/// Returns a [Widget] representing the custom drawer submenu.

/*******  b3b08484-396a-4cdc-b51c-dea97d44dfce  *******/

Widget customDrawerSubMenu({
  required String title,
  required VoidCallback onTap,
  IconData? icon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(left: 36.0),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Row(
          spacing: 12,
          children: [
            // Image.asset(
            //   'assets/extra_images/teeth_1.png',
            //   width: 24,
            //   height: 24,
            // ),
            CustomText(
              text: title,
              fontSize: 14,
              fontFamily: 'Roboto',
              color: whiteColor,
              fontWeight: FontWeight.w500,
              maxLines: 30,
            ),
            // Spacer(),
            // Icon(icon ?? Icons.add, color: whiteColor, size: 24),
          ],
        ),
      ),
    ),
  );
}
