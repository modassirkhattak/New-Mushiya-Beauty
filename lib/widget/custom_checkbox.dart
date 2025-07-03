import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';

import '../view/terms_condition/terms_condition_page.dart';

class CustomCheckboxWithText extends StatelessWidget {
  final RxBool isChecked;
  final VoidCallback onTap;
  final String? text;
  final String? subUnderlineText;
  final Color? color;
  final Color? textColor;
  final double? textSize;

  const CustomCheckboxWithText({
    super.key,
    required this.isChecked,
    required this.onTap,
    this.text,
    this.subUnderlineText,
    this.color,
    this.textSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: color ?? Colors.black, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  isChecked.value
                      ? Icon(
                        Icons.check,
                        size: 16,
                        color: color ?? Colors.black,
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                text: TextSpan(
                  text: text ?? "I Agree With ",
                  style: GoogleFonts.roboto(
                    color: textColor ?? primaryBlackColor,
                    fontSize: textSize ?? 14,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: subUnderlineText ?? "Terms & Conditions",
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(TermsConditionPage());
                            },
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
