import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:mushiya_beauty/utills/app_colors.dart';

class CustomTabWidget extends StatelessWidget {
  final List<Widget> children;
  final Function(int)? onTap;

  const CustomTabWidget({super.key, required this.children, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TabBar(
        // tabAlignment: TabAlignment.startOffset,
        // automaticIndicatorColorAdjustment: false,
        labelStyle: GoogleFonts.roboto(
          color: whiteColor,

          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorPadding: EdgeInsets.only(right: ),
        indicatorColor: whiteColor,
        labelPadding: const EdgeInsets.all(0),
        unselectedLabelStyle: GoogleFonts.roboto(
          color: whiteColor,

          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        dragStartBehavior: DragStartBehavior.start,
        indicatorWeight: 4,
        padding: EdgeInsets.all(0),
        isScrollable: false,
        onTap: onTap,

        tabs: children,
      ),
    );
  }
}

class CustomStyleTabBarWidget extends StatelessWidget {
  final List<Widget> children;

  const CustomStyleTabBarWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TabBar(
        isScrollable: false,
        labelStyle: GoogleFonts.roboto(
          color: whiteColor,

          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorPadding: EdgeInsets.only(right: ),
        indicatorColor: whiteColor,

        labelPadding: const EdgeInsets.all(0),
        unselectedLabelStyle: GoogleFonts.roboto(
          color: whiteColor,

          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        indicatorWeight: 6,
        tabs: children,
      ),
    );
  }
}
