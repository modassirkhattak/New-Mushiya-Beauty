import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // If you're using GetX

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final RxString selectedValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        iconColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.60),
            width: 0.1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.60),
            width: 0.1,
          ),
        ),
      ),
      style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
      hint: Text(hintText, style: const TextStyle(fontSize: 14)),
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
      validator:
          validator ??
          (value) {
            if (value == null) {
              return 'Please select a value';
            }
            return null;
          },
      onChanged: onChanged,
      onSaved: (value) {
        selectedValue.value = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
