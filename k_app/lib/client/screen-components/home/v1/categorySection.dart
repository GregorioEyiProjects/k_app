import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/global.dart';

class CustomCategoryTab extends StatefulWidget {
  int? selectedIndex;
  final List<String> categoryList;
  final String fontFamily_;

  CustomCategoryTab({
    super.key,
    required this.categoryList,
    this.selectedIndex = 0,
    this.fontFamily_ = "Poppins",
  });

  @override
  State<CustomCategoryTab> createState() => _CustomCategoryTabState();
}

class _CustomCategoryTabState extends State<CustomCategoryTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: widget.categoryList.map((category) {
          int index = widget.categoryList.indexOf(category);

          return GestureDetector(
            onTap: () {
              setState(() {
                setState(() {
                  widget.selectedIndex = index;
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: widget.fontFamily_,
                      fontWeight: FontWeight.bold,
                      color: widget.selectedIndex == index
                          ? AppColors.textColor
                          : AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: 3),
                  widget.selectedIndex == index
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 5,
                          width: 70,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.textColor),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        }).toList()),
      ),
    );
  }
}
