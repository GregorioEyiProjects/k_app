import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart';
import 'package:k_app/client/screen-components/home/v2/customButton2.dart';
import 'package:k_app/client/screen-components/home/v2/display_bottom_sheet.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/models/home/v2/event.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    super.key,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final DateTime initialDate = DateTime.now();

  List<Appointment>? appointmentsList;
  TimeOfDay? pickedTime;
  final TextEditingController eventController = TextEditingController();
  final FocusNode eventFocusNode = FocusNode();

  String? userName;
  DateTime? appoinmentDate;
  TimeOfDay? appoinmentTime;
  String? establishmentName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AppProvider>(context, listen: false).fetchEvents();
      setState(() {
        appointmentsList =
            Provider.of<AppProvider>(context, listen: false).listOfEvents;
      }); // Trigger a rebuild to update the UI with the events
    });
  }

  @override
  void dispose() {
    eventController.dispose();
    eventFocusNode.dispose();
    super.dispose();
  }

  //Add the event
/*   void _showAddEventDialog(DateTime selectedDate) {
    eventController.clear();
    userName = null;
    appoinmentDate = null;
    appoinmentTime = null;
    establishmentName = null;
    TimeOfDay initialTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'Appoiment on \n${formatDate(selectedDate)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Customer name',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: AppColors.blackColor,
                    ),
                  ),

                  //Text field
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
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
                          eventFocusNode
                              .unfocus(); // Remove focus when done typing
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          eventFocusNode
                              .unfocus(); // Remove focus when the user submits the text
                        });
                      },
                      controller: eventController,
                      onChanged: (value) {
                        setState(() {
                          userName = value;
                          print("User name>>>>: $userName");
                        });
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
                  ),
                  SizedBox(height: 15),

                  //Time picker
                  GestureDetector(
                    onTap: () async {
                      pickedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );

                      if (pickedTime != null) {
                        setState(() {
                          initialTime = pickedTime!;
                          appoinmentTime = pickedTime!;
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                  ),

                  //Pick the establishment
                  SizedBox(height: 10),
                  Text(
                    'Select the place',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  //Establishment selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            establishmentName = "Nawamim";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: establishmentName == "Nawamim"
                                ? Border.all(
                                    color: AppColors.lightBlueAccent,
                                    width: 1.5,
                                  )
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: establishmentName == "Night Market"
                                ? Border.all(
                                    color: AppColors.lightBlueAccent,
                                    width: 1.5,
                                  )
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                  ),

                  //Show info before adding
                  SizedBox(height: 15),
                  if (userName != null &&
                      appoinmentTime != null &&
                      establishmentName != null)
                    _displayInfoB4Save(userName!, selectedDate, appoinmentTime,
                        establishmentName!, context),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      userName = eventController.text;
                      appoinmentDate = selectedDate;
                      appoinmentTime = pickedTime;

                      //Check if the user has entered all the details
                      if (userName == null || userName!.isEmpty) {
                        CustomSnackBar.show(
                          context,
                          title: "Custommer name is empty",
                          message: "Please enter the customer name!",
                          contentType: ContentType.failure,
                        );

                        return;
                      }

                      if (appoinmentDate == null) {
                        CustomSnackBar.show(
                          context,
                          title: "Date is empty",
                          message: "Please select the date!",
                          contentType: ContentType.failure,
                        );
                        return;
                      }

                      if (appoinmentTime == null) {
                        CustomSnackBar.show(
                          context,
                          title: "Time is empty",
                          message: "Please select the time!",
                          contentType: ContentType.failure,
                        );
                        return;
                      }

                      if (establishmentName == null) {
                        CustomSnackBar.show(
                          context,
                          title: "Place is empty",
                          message: "Please select the place!",
                          contentType: ContentType.failure,
                        );
                        return;
                      }

                      // If everything OK, Add the appointment
                      if (userName != null &&
                          appoinmentDate != null &&
                          appoinmentTime != null &&
                          establishmentName != null) {
                        Provider.of<AppProvider>(context, listen: false)
                            .addEventToObjexBox(
                                userName!.trim(),
                                appoinmentDate!,
                                appoinmentTime!,
                                establishmentName!);

                        // Update the events list
                        appointmentsList =
                            Provider.of<AppProvider>(context, listen: false)
                                .listOfEvents;

                        // Unfocus the text field
                        eventFocusNode.unfocus();

                        //Clear the text field
                        // /eventController.clear();
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
 */

  void _showEventDetailsDialog(List<Appointment> dayEvents) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            'Appoiment details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
            ),
          ),
          content: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /* Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: dayEvents.map((event) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Customer: ${event.userName} \nTime: ${event.appointmentTime.format(context)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  );
                }).toList(),
              ), */
              Text(
                //'Customer: ${dayEvents.first.userName}',
                '🧑🏻 ${dayEvents.first.userName}',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 15),
              _appoimentDateInfo(appointmentsList!.first.appointmentDate),
              SizedBox(height: 15),
              _appointmentTimeInfo(
                  Appointment.stringToTimeOfDay(
                      appointmentsList!.first.appointmentTime),
                  context),
            ],
          ),
          actions: [
            //Add new one
            CustomButton2(
              text: 'Add new',
              height: 35,
              width: 80,
              backgroundColor: Colors.greenAccent,
              onTap: () {
                Navigator.of(context).pop();
                //_showAddEventDialog(dayEvents.first.appointmentDate);
                displayBottomSheet(context, dayEvents.first.appointmentDate);
              },
            ),
            /* TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //_showAddEventDialog(dayEvents.first.appointmentDate);
                displayBottomSheet(context, dayEvents.first.appointmentDate);
              },
              child: Text(
                'Add new',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                ),
              ),
            ), */
            SizedBox(width: 10),
            CustomButton2(
              text: 'cancel',
              height: 35,
              width: 80,
              backgroundColor: Colors.redAccent,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            /* TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                ),
              ),
            ), */
          ],
        );
      },
    );
  }

  Row _appoimentDateInfo(DateTime dateTime) {
    return Row(
      children: [
        //Icon(Icons.calendar_today, size: 18),
        Text("📅"),
        SizedBox(width: 5),
        Text(
          '${formatDate(dateTime.toLocal())}',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Row _appointmentTimeInfo(TimeOfDay time, BuildContext context) {
    return Row(
      children: [
        //Icon(Icons.access_time, size: 18),
        Text("🕔"),
        SizedBox(width: 5),
        Text(
          time.format(context),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _displayInfoB4Save(
      String userName,
      DateTime? appoinmentDate,
      TimeOfDay? appoinmentTime,
      String establishmentName,
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(
          "Appoiment details",
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 10),
        Text(
          '🧑🏻 $userName',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 5),
        if (appoinmentDate != null)
          Row(
            children: [
              //Icon(Icons.calendar_today, size: 16),
              Text("📅"),
              SizedBox(width: 5),
              Text(
                '${formatDate(appoinmentDate.toLocal())}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        SizedBox(height: 5),
        if (appoinmentTime != null)
          Row(
            children: [
              //Icon(Icons.access_time, size: 16),
              Text("🕔"),
              SizedBox(width: 5),
              Text(
                Appointment.timeOfDayToString(appoinmentTime!),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        SizedBox(height: 5),
        if (establishmentName != null)
          Row(
            children: [
              //Icon(Icons.access_time, size: 16),
              Text("🏢"),
              SizedBox(width: 5),
              Text(
                establishmentName,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }

  formatDate1(DateTime selectedDate) {
    return DateFormat('MMM d').format(selectedDate);
  }

  formatDate2(DateTime selectedDate) {
    //final String month
    return '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    //Test
    if (appointmentsList == null) {
      return Center(child: CircularProgressIndicator());
    }
    //bool isEventDay = d
    return TableCalendar(
      focusedDay: initialDate,
      rowHeight: 35,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppColors.todayColodBackground,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.todayColodBackground,
          shape: BoxShape.circle,
        ),
        /**/ selectedTextStyle: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
        defaultTextStyle: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
        outsideDaysVisible: false,
        markerDecoration: BoxDecoration(
          color: AppColors.todayDotColor,
          shape: BoxShape.circle,
        ),
      ),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      enabledDayPredicate: (day) {
        // Enable today and future days
        return !day.isBefore(DateTime.now().subtract(Duration(days: 1)));
      },
      selectedDayPredicate: (day) {
        // Highlight the current day
        return isSameDay(day, DateTime.now());
      },
      eventLoader: (day) {
        if (appointmentsList == null) return [];
        return appointmentsList!
            .where((e) => isSameDay(e.appointmentDate, day))
            .toList();
      },
      //eventLoader: (day) => events[day] ?? [],

      onDaySelected: (selectedDay, focusedDay) {
        if (appointmentsList == null) return;

        final daysEvent = appointmentsList!
            .where((e) => isSameDay(e.appointmentDate, selectedDay))
            .toList();

        if (daysEvent.isNotEmpty) {
          _showEventDetailsDialog(daysEvent);
        } else {
          displayBottomSheet(context, selectedDay);
          // _showAddEventDialog(selectedDay);
        }
      },
    );
  }
}
