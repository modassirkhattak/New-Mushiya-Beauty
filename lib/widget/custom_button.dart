// import 'package:car_rental/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.showBorder = false,
    this.borderColor,
    this.elevation = 4,
    this.radius = 10,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.height = 40,

    this.minWidth = 77,
    this.prefixIcon,
    this.isPrefixIcon = false,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool? showBorder;
  final double? elevation;
  final double? fontSize;
  final double? radius;
  final double? minWidth;
  final double? height;
  final Widget? prefixIcon;
  final FontWeight? fontWeight;
  final bool isPrefixIcon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightElevation: 3,
      highlightColor: Colors.transparent,
      elevation: elevation,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
        side: BorderSide(
          color:
              showBorder == true
                  ? borderColor ?? primaryBlackColor
                  : Colors.transparent,
        ),
      ),
      minWidth: minWidth,
      height: height,
      child:
          isPrefixIcon == false
              ? Text(
                text,
                style: TextStyle(
                  // style: GoogleFonts.archivo(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontFamily: 'Archivo',
                ),

              )
              : prefixIcon ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logout.png', height: 25),
                      const SizedBox(width: 5),
                      Text(
                        text,
                        style: TextStyle(
                          // style: GoogleFonts.archivo(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          fontFamily: 'Archivo',
                        ),
                      ),
                    ],
                  ),
    );
  }
}
