import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';

class FilterSection extends StatefulWidget {
  //final VoidCallback? onTap;
  final ValueChanged<String>? onTapped;
  final bool? isFilteredFromThePreviousScreen;

  const FilterSection(
      {super.key, this.onTapped, this.isFilteredFromThePreviousScreen});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  String? hintText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hintText = 'Filter';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      onChanged: widget.isFilteredFromThePreviousScreen == true
          ? null
          : (value) {
              print("Value: $value");
              switch (value) {
                case 1:
                  //print('Today');
                  setState(() {
                    hintText = 'Today';
                    widget.onTapped!(hintText!);
                  });
                  break;
                case 2:
                  //print('Yesterday');
                  setState(() {
                    hintText = 'Yesterday';
                    widget.onTapped!(hintText!);
                  });
                  break;
                case 3:
                  //print('Last 7 days');
                  setState(() {
                    hintText = 'Last 7 days';
                    widget.onTapped!(hintText!);
                  });
                  break;

                case 4:
                  //print('Last 30 days');
                  setState(() {
                    hintText = 'Last 30 days';
                    widget.onTapped!(hintText!);
                  });
                  break;
              }
            },
      hint: Text(
        hintText!,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.blackColor.withOpacity(0.6),
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      items: [
        DropdownMenuItem(
          value: 1,
          child: Text(
            'Today',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text(
            'Yesterday',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        DropdownMenuItem(
          value: 3,
          child: Text(
            'Last 7 days',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        DropdownMenuItem(
          value: 4,
          child: Text(
            'Last 30 days',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
