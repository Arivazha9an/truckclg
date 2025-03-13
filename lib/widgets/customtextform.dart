import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labeltext;
  final bool isObscure;
  final TextInputType keyboardType;
  final bool validate;
  final bool readOnly;
  final VoidCallback? ontap;
  final ValueChanged? onChanged;
  final int maxLines;
  final int? maxLength;
  final double? width;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    required this.labeltext,
    required this.keyboardType,
    this.validate = true,
    this.readOnly = false,
    this.ontap,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-4, 4),
            blurRadius: 18,
            spreadRadius: 0,
            color: Color(0x17000000),
          )
        ],
      ),
      child: TextFormField(
        minLines: 1,
        maxLength: maxLength,
        maxLines: maxLines,
        readOnly: readOnly,
        controller: controller,
        validator: validate
            ? (value) {
                if (value!.isEmpty) {
                  return "Field cannot be empty";
                } else {
                  if (maxLength != null) {
                    if (value.length != maxLength) {
                      return "Invallid data";
                    }
                  }
                  return null;
                }
              }
            : (value) {
                return null;
              },
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          color: black,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        onTap: ontap,
        obscureText: isObscure,
        obscuringCharacter: "*",
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labeltext,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: orange),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            )),
      ),
    );
  }
}
