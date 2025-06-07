import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart';
import 'package:k_app/client/screen-components/home/v2/customButton2.dart';
import 'package:k_app/client/screen-components/home/v2/display_bottom_sheet.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/models/home/v2/event.dart';
import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
import 'package:k_app/server/database/bloc/states/appointment_state.dart';
import 'package:k_app/server/models/appointment-model.dart';
//import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  //Get the list fetched from the DB (ObjectBox)
  //final List<Appointment>? appointmentsListComing;

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
      // await Provider.of<AppProvider>(context, listen: false).fetchEvents();
      //debugPrint("Here is the list of events in CustomCalendar : ${widget.appointmentsListComing}");
      setState(() {
        //appointmentsList = widget.appointmentsListComing;
        //appointmentsList = Provider.of<AppProvider>(context, listen: false).listOfEvents;
      }); // Trigger a rebuild to update the UI with the events
    });
  }

  @override
  void dispose() {
    eventController.dispose();
    eventFocusNode.dispose();
    super.dispose();
  }

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
    /* if (appointmentsList == null) {
      return Center(child: CircularProgressIndicator());
    } */

    return BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
      if (state is AppointmentLoaded) {
        //Get the list of appointments
        appointmentsList = state.appointments;
        //Return the calendar
        return _CalendarContainer(context);
      } else if (state is AppointmentFiltered) {
        debugPrint(
            'Filtered appointments in AppointmentFiltered in CustomCalendar: ${state.filteredAppointments}');
        appointmentsList = state.filteredAppointments;
        return _CalendarContainer(context);
      } else if (state is AppointmentError) {
        return Center(
          child: Text(
            state.message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        );
      } else {
        return Center(
          child: Text(
            'Initial state',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        );
      }
    });

    /*  return TableCalendar(
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
  
   */
  }

  TableCalendar<dynamic> _CalendarContainer(BuildContext context) {
    return TableCalendar(
      focusedDay: initialDate,
      rowHeight: 45,
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
        //Initial state
        if (appointmentsList == null) return [];

        //Return the list of events
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
