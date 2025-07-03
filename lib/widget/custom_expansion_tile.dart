import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class OrderSummaryTile extends StatelessWidget {
  final List<Widget> widget;
  final String title;
  final bool? subMenu;

  OrderSummaryTile({
    super.key,
    required this.widget,
    required this.title,
    required this.subMenu,
  });

  @override
  Widget build(BuildContext context) {
    RxBool selectValue = false.obs;
    return Container(
      margin: EdgeInsets.only(right: subMenu == true ? 0.0 : 47.0),
      decoration: BoxDecoration(
        color: primaryBlackColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
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

        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        collapsedShape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        onExpansionChanged: (value) {
          selectValue.value = value;
          print("Expansion changed: $selectValue");
        },

        collapsedIconColor: whiteColor,
        trailing: Obx(
          () => Icon(
            selectValue == false ? Icons.add : Icons.remove,
            color: whiteColor,
            size: 24,
          ),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        // backgroundColor: whiteColor,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
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
                      color: whiteColor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
                : CustomText(
                  text: "$title",
                  fontSize: 14,
                  color: whiteColor,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
        // childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: widget,
      ),
    );
  }
}
