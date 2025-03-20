import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/models/home/v1/Nail_model.dart';

class CustomItemCategories extends StatefulWidget {
  final Nail nail;

  const CustomItemCategories({super.key, required this.nail});

  @override
  State<CustomItemCategories> createState() => CustomItemCategoriesState();
}

class CustomItemCategoriesState extends State<CustomItemCategories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.greyColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Image.asset(
                  widget.nail.image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.nail.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyColor.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                // later
              },
              child: Icon(
                Icons.favorite_border,
                color: AppColors.textColor,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
