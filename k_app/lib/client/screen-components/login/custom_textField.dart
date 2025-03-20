import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';

class CustomTextFieldController extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final double width;
  final double height;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? fieldlabel;
  final Color borderColor;
  final Color textColor;
  final Color hinttextColor;
  final Color iconColor;
  final Color backgroundColor;
  final double labelheight;

  const CustomTextFieldController({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.width = 250,
    this.height = 50,
    this.controller,
    this.prefixIcon,
    this.fieldlabel,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.hinttextColor = Colors.white70,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.labelheight = 0,
  });

  @override
  State<CustomTextFieldController> createState() =>
      _CustomTextFieldControllerState();
}

class _CustomTextFieldControllerState extends State<CustomTextFieldController> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      _obscureText = widget.isPassword;
    }

    return Column(
      children: [
        widget.fieldlabel == null
            ? const SizedBox(
                height: 0,
              )
            : Container(
                width: widget.width,
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.fieldlabel}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
        SizedBox(height: widget.labelheight),
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.borderColor,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: widget.textColor,
            ),
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: widget.hinttextColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12.0),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Icon(
                      widget.prefixIcon,
                      color: widget.iconColor,
                    ),
              suffixIcon: widget.isPassword != true
                  ? null
                  : IconButton(
                      icon: _obscureText
                          ? const Icon(
                              Icons.visibility_off,
                              color: AppColors.whiteColor,
                            )
                          : const Icon(Icons.visibility,
                              color: AppColors.whiteColor),
                      onPressed: () {
                        setState(
                          () {
                            _obscureText = !_obscureText;
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
