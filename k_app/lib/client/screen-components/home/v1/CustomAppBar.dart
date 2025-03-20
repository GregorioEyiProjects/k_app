import 'package:flutter/material.dart';
import 'package:k_app/global.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? showBackArrowLeadingiIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final double? allMargin_;
  final double? marginTop_;
  final double? marginleft_;
  final double? marginRigth_;
  final IconData? actionIcon; // The icon on the right side of the app bar
  final String? fontFamily_;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackArrowLeadingiIcon = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.allMargin_ = 20,
    this.marginTop_ = 20,
    this.marginleft_ = 20,
    this.marginRigth_ = 20,
    this.actionIcon,
    this.fontFamily_ = "Poppins",
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          showBackArrowLeadingiIcon!, // Don't show the leading button
      title: Padding(
        padding: EdgeInsets.only(left: marginleft_!),
        child: Row(
          mainAxisAlignment: mainAxisAlignment!,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontFamily: fontFamily_,
              ),
            ),
          ],
        ),
      ),
      actions: actionIcon != null
          ? [
              Padding(
                padding: EdgeInsets.only(right: marginRigth_!),
                child: IconButton(
                  icon: Icon(actionIcon),
                  onPressed: () {
                    // later
                  },
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
