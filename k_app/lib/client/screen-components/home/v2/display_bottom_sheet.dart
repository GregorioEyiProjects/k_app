import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/home/v2/customButton2.dart';
import 'package:k_app/global.dart';
import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';

TimeOfDay? appointmentTime;
DateTime? appoinmentDate;
String? establishmentName;
String userName = '';
final eventFocusNode = FocusNode();
final eventController = TextEditingController();
bool isReadyToSave = false;

//Display the bottom sheet Modal
Future<void> displayBottomSheet(
  BuildContext context,
  DateTime selectedDate,
) async {
  //

  //Reset the values
  userName = '';
  eventController.clear();
  establishmentName = null;
  appointmentTime = null;
  //Return the bottom sheet
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext content) {
      //

      //Return a StatefulBuilder
      return StatefulBuilder(
        builder: (context, setState) {
          //
          //Variables
          final double keyboardHeight =
              MediaQuery.of(context).viewInsets.bottom;
          TimeOfDay? pickedTime;
          TimeOfDay initialTime = TimeOfDay.now();

          //Return the widget
          return Container(
            height: 350 + keyboardHeight,
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //TexField
                              _textField(setState),
                              //Space
                              const SizedBox(height: 20),
                              //Time picker
                              _pickTime(
                                pickedTime,
                                context,
                                initialTime,
                                setState,
                              ),
                              //Space
                              const SizedBox(height: 20),
                              //Select the place text
                              Text(
                                'Select the place',
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Poppins',
                                ),
                              ),

                              //Space
                              const SizedBox(height: 10),

                              //Establishments
                              _establismentContainer(setState),

                              //Space
                              const SizedBox(height: 20),

                              //Button
                              _buttonSave(context, selectedDate),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                //Close button
                Positioned(
                  top: 22,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Book an appointment",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _closeButton(context),
                )
              ],
            ),
          );
        },
      );
    },
  );
}

/* 
void _openConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Appointment booked'),
        content: const Text('Your appointment has been booked successfully'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
} */

//Close button
Widget _closeButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.greyColor.withAlpha(100),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.close),
        ),
      ),
    ],
  );
}

//TextField
Container _textField(
  StateSetter setState,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: TextField(
      //showCursor: false,
      focusNode: eventFocusNode,
      showCursor: true,
      onEditingComplete: () {
        setState(() {
          eventFocusNode.unfocus();
        });
      },
      onSubmitted: (value) {
        setState(() {
          eventFocusNode.unfocus();
        });
      },
      controller: eventController,
      onChanged: (value) {
        setState(() {
          if (value.isEmpty) {
            userName = '';
            debugPrint("User name>>>>: $userName");
            debugPrint("Is ready to save>>>>: ${_isItReadyToSave()}");
          } else {
            userName = value;
            debugPrint("User name>>>>: $userName");
          }
        });
        // _isItReadyToSave();
      },
      decoration: InputDecoration(
        icon: Text(
          "🧑🏻",
          style: TextStyle(
            fontSize: 20,
          ),
        ), //Icon(Icons.person),
        hintText: 'Enter the name',
        border: InputBorder.none,
      ),
    ),
  );
}

//Time picker
GestureDetector _pickTime(
  TimeOfDay? pickedTime,
  BuildContext context,
  TimeOfDay initialTime,
  StateSetter setState,
  //TimeOfDay? appointmentTime,
) {
  return GestureDetector(
    onTap: () async {
      debugPrint('appoinmentTime: $appointmentTime');
      pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        setState(() {
          initialTime = pickedTime!;
          appointmentTime = pickedTime;
          debugPrint('appoinmentTime: $appointmentTime');
        });
        // _isItReadyToSave();
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Left
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              //Icon(Icons.access_time),
              Text(
                "🕔",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 15.0),
              Text(
                'Select Time',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        //Right
        const SizedBox(width: 10),
        Text(
          appointmentTime == null
              ? 'Select Time' //🕔 ${initialTime.hour}:${initialTime.minute}
              : '🕔 ${appointmentTime!.hour}:${appointmentTime!.minute}',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w100,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    ),
  );
}

//Establishments
Row _establismentContainer(StateSetter setState) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {
          setState(() {
            establishmentName = "Nawamim";
          });
        },
        child: Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            border: establishmentName == "Nawamim"
                ? Border.all(
                    color: AppColors.lightBlueAccent,
                    width: 1.5,
                  )
                : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              "🏢 Nawamim",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            establishmentName = "Night Market";
          });
          _isItReadyToSave();

          /* if (userName.isNotEmpty &&
              establishmentName != null &&
              appointmentTime != null) {
            isReadyToSave = true;
            debugPrint('isReadyToSave: $isReadyToSave');
          } */
        },
        child: Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            border: establishmentName == "Night Market"
                ? Border.all(
                    color: AppColors.lightBlueAccent,
                    width: 1.5,
                  )
                : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              "🏢 Night Market",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

//Button save
Row _buttonSave(
  BuildContext context,
  DateTime selectedDate,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      CustomButton2(
        text: 'Book',
        height: 45,
        textColor: AppColors.whiteColor,
        backgroundColor: _isItReadyToSave() == true
            ? AppColors.lightBlueAccent
            : AppColors.greyColor,
        onTap: _isItReadyToSave()
            ? () {
                //Add the event
                //appProvider.addEvent(
                //  userName, appointmentTime, establishmentName);
                //Close the bottom sheet
                debugPrint('appointmentTime: $appointmentTime');
                _openConfirmationDialog(
                  context,
                  selectedDate,
                  userName,
                  appointmentTime,
                  establishmentName,
                  () {
                    Navigator.pop(context);
                  },
                );
                //Navigator.pop(context);
              }
            : () {
                debugPrint('Not ready to save');
              },
      ),
    ],
  );
}

//Confirmation dialog
void _openConfirmationDialog(
  BuildContext context,
  DateTime selectedDate,
  String username,
  TimeOfDay? appointmentTime,
  String? establishmentName,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Appointment details',
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensures the dialog takes minimal space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review the appointment before saving it, krup ☺️!',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            if (selectedDate != null)
              Text(
                '🧑🏻 $username',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

            //Space
            const SizedBox(height: 10),
            if (selectedDate != null)
              Text(
                '📅 ${formatDate(selectedDate)}',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            //Space
            const SizedBox(height: 10),
            if (appointmentTime != null)
              Text(
                '🕔 ${appointmentTime.hour}:${appointmentTime.minute}',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            //Space
            const SizedBox(height: 10),
            if (establishmentName != null)
              Text(
                '🏢 $establishmentName',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: <Widget>[
          CustomButton2(
            text: "Edit",
            height: 35,
            width: 80,
            backgroundColor: Colors.redAccent,
            onTap: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
          CustomButton2(
            text: "Save",
            height: 35,
            width: 80,
            backgroundColor: AppColors.lightBlueAccent,
            onTap: () async {
              final int response =
                  await Provider.of<AppProvider>(context, listen: false)
                      .addEventToObjexBox(
                username,
                selectedDate,
                appointmentTime!,
                establishmentName!,
              );
              if (response != -1) {
                Navigator.pop(context); // Close the dialog
                onConfirm(); // Call the callback
              }
              /* Navigator.pop(context); // Close the dialog
              onConfirm(); // Call the callback */
            },
          ),
        ],
      );
    },
  );
}

//Check if the user has entered all the required fields
bool _isItReadyToSave() {
  if (userName.isNotEmpty &&
      establishmentName != null &&
      appointmentTime != null) {
    isReadyToSave = true;
    debugPrint('isReadyToSave: $isReadyToSave');
  } else {
    isReadyToSave = false;
  }
  return isReadyToSave;
}
