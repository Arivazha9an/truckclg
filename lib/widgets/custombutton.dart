import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final double? width;
  final String title;
  final Color background;
  final Color textColor;
  final double fontSize;
  final VoidCallback onTap;
  final bool isLoading;
  const CustomTextButton(
      {super.key,
      this.width,
      required this.title,
      required this.background,
      required this.textColor,
      required this.fontSize,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Container(
              width: width,
              height: 46,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          );
  }
}
