import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';

class CustomTextFieldController2 extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final double width;
  final double height;
  final IconData? prefixIcon;
  final bool isPassword;
  final double marginTop;
  final double marginleft;
  final double marginRigth;
  final double marginBottom;
  final TextInputType? keyboardType;
  final Color iconColor;

  const CustomTextFieldController2({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.width = 250,
    this.height = 50,
    this.controller,
    this.prefixIcon,
    this.marginTop = 35,
    this.marginleft = 15,
    this.marginRigth = 15,
    this.marginBottom = 0,
    this.keyboardType = TextInputType.text,
    this.iconColor = Colors.white,
  });

  @override
  State<CustomTextFieldController2> createState() =>
      _CustomTextFieldController2State();
}

class _CustomTextFieldController2State
    extends State<CustomTextFieldController2> {
  bool _obscureText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.marginleft,
        right: widget.marginRigth,
        top: widget.marginTop,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blueColor,
                      width: 2.0), // Customize the color and width as needed
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: widget.hintText,
                filled: true,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: widget.iconColor,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
