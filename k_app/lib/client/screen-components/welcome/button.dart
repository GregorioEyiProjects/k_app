import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/global.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroungColor;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 190,
    this.height = 50,
    this.backgroungColor = AppColors.whiteColor,
    this.textColor = AppColors.blackColor,
  }) : super(key: key);

  //const CustomButton({super.key, required this.text, required this.onPressed} );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: marginleft, right: marginRigth),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 1.0,
                foregroundColor: textColor,
                backgroundColor: backgroungColor,
                minimumSize: Size(width, height),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                //padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: onPressed,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
