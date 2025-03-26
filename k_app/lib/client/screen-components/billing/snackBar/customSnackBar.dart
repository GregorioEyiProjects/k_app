/*
  For this custom snackbar to be used, you need to use the library "  awesome_snackbar_content: ^0.1.5 "
  And if it gives any kind of trouble related to "intl"
  Then use the following code in the pubspec.yaml file:
    dependency_overrides:
      intl: 0.19.0
 */

import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    double titleSize = 18,
    required String message,
    double messagefontSize = 16,
    String fontFamily = 'Poppins',
    Color backgroundColor = AppColors.backgroundColor,
    FontWeight fontWeight = FontWeight.w300,
    ContentType contentType = ContentType.success,
    double elevation = 10,
    Duration duration = const Duration(seconds: 3),
    String heroTag = 'defaultHeroTag',
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: backgroundColor,
        elevation: elevation,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.only(top: 50, left: 10, right: 10),
        content: AwesomeSnackbarContent(
          title: title,
          titleTextStyle: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
          message: message,
          messageTextStyle: TextStyle(
            fontSize: messagefontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ),
          contentType: contentType,
        ),
      ));
  }
}
