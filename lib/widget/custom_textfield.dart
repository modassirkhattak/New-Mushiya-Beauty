import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utills/app_colors.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  String? hintText;
  TextInputType? keyboardType;
  TextEditingController? textEditingController;
  bool? obscureText;
  bool? filled;
  Color? fillColor;
  String? fontFamily;
  String? Function(String?)? onValidate;
  int? maxLines;
  bool? enabled;
  Color? hintColor;
  double? hintFontSize;
  FontWeight? hintFontWeight;
  double? borderRadius;
  double? height;
  double? width;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Color? shadowColor;
  List<TextInputFormatter>? inputFormator;
  EdgeInsetsGeometry? contentPadding;
  Color? cursorColor;
  Color? textColor;
  bool? isBorder;
  final bool? readOnly;
  List<TextInputFormatter>? inputFormatters;
  double elevation;
  final  Function(String?)? onChanged;
  final Color? borderColor; // ✅ NEW

  CustomTextField({
    Key? key,
    required this.hintText,
    this.inputFormator,
    this.inputFormatters,
    this.fontFamily = "SF Pro Text",
    this.textEditingController,
    this.filled = true,
    this.hintFontWeight = FontWeight.w500,
    this.fillColor,
    this.readOnly = false,
    this.hintFontSize = 14,
    this.hintColor = greyColor,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onValidate,
    this.maxLines = 1,
    this.borderRadius = 10,
    this.prefixIcon,
    this.suffixIcon,
    this.isBorder = true,
    this.elevation = 0,
    this.height,
    this.width,
    this.shadowColor,
    this.contentPadding,
    this.cursorColor,
    this.textColor,
    this.onChanged,
    this.borderColor, // ✅ NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderSide getBorderSide() {
      if (isBorder == true) {
        return BorderSide(color: borderColor ?? primaryBlackColor, width: 0.8);
      }
      return BorderSide.none;
    }

    return TextFormField(
      inputFormatters: inputFormator,
      cursorColor: cursorColor,
      obscuringCharacter: '∗',
      enabled: enabled,
      readOnly: readOnly!,
      onChanged: onChanged,

      maxLines: maxLines,
      controller: textEditingController,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        fontFamily: fontFamily,
        color: textColor ?? primaryBlackColor,
      ),
      // autovalidateMode: AutovalidateMode.onUnfocus,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        constraints: BoxConstraints(
          minHeight: height ?? 48,
          maxHeight: height ?? 48,
          minWidth: width ?? double.infinity,
        ),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        hintText: hintText,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        hintStyle: TextStyle(
          fontWeight: hintFontWeight,
          fontSize: hintFontSize,
          fontFamily: fontFamily,
          color: hintColor ?? greyColor,
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(minWidth: 30),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: getBorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: getBorderSide(),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: getBorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: getBorderSide(),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
      ),
      validator: onValidate,
    );
  }
}
