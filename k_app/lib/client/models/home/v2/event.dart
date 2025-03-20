import 'package:flutter/material.dart';

class CalendarEvent {
  final String userName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;

  CalendarEvent({
    required this.userName,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  static List<CalendarEvent> listOfEvents = [
/*     CalendarEvent(
      userName: "Juanito Cupidos",
      appointmentDate: DateTime.now(),
      appointmentTime: TimeOfDay.now(),
    ), */
  ];

  //AddEvents to the list
  static addEvent(String userName, DateTime date, TimeOfDay time) {
    listOfEvents.add(CalendarEvent(
      userName: userName,
      appointmentDate: date,
      appointmentTime: time,
    ));
  }
}
