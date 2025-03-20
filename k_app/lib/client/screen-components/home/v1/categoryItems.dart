import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/models/home/v1/Nail_model.dart';

class CustomCategoryItems extends StatefulWidget {
  final Nail nail;

  const CustomCategoryItems({super.key, required this.nail});

  @override
  State<CustomCategoryItems> createState() => _CustomCategoryItemsState();
}

class _CustomCategoryItemsState extends State<CustomCategoryItems> {
  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: Stack(
            children: [
              Image.asset(
                widget.nail.image,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: AppColors.blackColor.withOpacity(0.5),
                    child: Text(
                      truncateText(widget.nail.name, 20),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
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
    );
  }
}

/* 
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(
                      widget.nail.image,
                      height: 150,
                      width: 150,
                      fit: BoxFit.fitHeight,
                    ),
                    Text(
                      truncateText(widget.nail.name, 9),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
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
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {});
  }
 
}*/
