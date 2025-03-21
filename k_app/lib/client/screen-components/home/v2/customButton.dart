import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';

class CustomButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final String? btnTitle;
  final String textIcon;
  final Color? color;
  final Color? textColor;
  final double width;
  final double height;
  final Color backgroungColor;
  final double fontSize;

  CustomButton2({
    super.key,
    required this.onPressed,
    this.btnTitle,
    this.textIcon = '🗑️',
    this.color = Colors.blue,
    this.textColor = AppColors.whiteColor,
    this.backgroungColor = AppColors.backgroundColor,
    this.width = 40,
    this.height = 40,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1.0,
        foregroundColor: textColor,
        backgroundColor: backgroungColor,
        //minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        //padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        btnTitle == null ? textIcon : btnTitle!,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
