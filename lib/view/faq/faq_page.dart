import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
// import 'package:mushiya_beauty/widget/custom_expansion_tile.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "fac".toUpperCase(),
          titleImage: true,
          actions: true,

          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 3, // Placeholder for FAQ items count
        itemBuilder: (context, index) {
          // Replace with actual FAQ item widgets
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: OrderSummaryTile(
              color: whiteColor,

              subMenu: false,
              textColor: primaryBlackColor,

              title:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do  ",
              widget: [
                Container(color: primaryBlackColor, height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CustomText(
                        leftPadding: 8,
                        topPadding: 8,
                        bottomPadding: 8,
                        rightPadding: 8,
                        text:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, to Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut al",
                        maxLines: 30,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,

                        color: primaryBlackColor,

                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OrderSummaryTile extends StatelessWidget {
  final List<Widget> widget;
  final String title;
  final bool? subMenu;
  final Color? color;
  final Color? textColor;

  OrderSummaryTile({
    super.key,
    required this.widget,
    required this.title,
    required this.subMenu,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    RxBool selectValue = false.obs;
    return Container(
      // margin: EdgeInsets.only(right: subMenu == true ? 0.0 : 47.0),
      decoration: BoxDecoration(
        color: color ?? primaryBlackColor,
        borderRadius: BorderRadius.circular(12),
        // border: Border(
        //   bottom: BorderSide(color: Colors.grey, width: 0.5),
      ),
      //
      child: ExpansionTile(
        iconColor: whiteColor,
        // minTileHeight: 55,
        dense: true,
        internalAddSemanticForOnTap: true,
        controller: ExpansionTileController(),
        clipBehavior: Clip.antiAlias,
        maintainState: true,

        collapsedBackgroundColor: color,
        backgroundColor: color,

        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        collapsedShape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onExpansionChanged: (value) {
          selectValue.value = value;
          print("Expansion changed: $selectValue");
        },

        collapsedIconColor: whiteColor,
        trailing: Obx(
          () => Icon(
            selectValue == false ? Icons.add : Icons.remove,
            color: textColor ?? whiteColor,
            size: 24,
          ),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        // backgroundColor: whiteColor,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),

        title:
            subMenu == true
                ? Row(
                  spacing: 12,
                  children: [
                    Image.asset(
                      'assets/extra_images/teeth_1.png',
                      width: 24,
                      height: 24,
                    ),
                    CustomText(
                      text: "$title",
                      fontSize: 14,
                      color: textColor ?? whiteColor,
                      fontFamily: "Roboto",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
                : CustomText(
                  text: "$title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  color: textColor ?? whiteColor,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
        // childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: widget,
      ),
    );
  }
}
