import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

/* Step 2: Define the Entity (Model)  */
@Entity()
class Appointment {
  int? id;
  String userName;
  @Property(type: PropertyType.date)
  DateTime appointmentDate;
  String appointmentTime;
  String establishmentName;

  Appointment({
    this.id,
    required this.userName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.establishmentName,
  });

  //Helper method to convert TimeOfDay to String
  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper method to convert TimeOfDay to String 2
  static String timeOfDayToString2(DateTime time) {
    // 2 digit hour //Output 0{time.hour.toString()}// Ex: 09
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper method to convert String to TimeOfDay
  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  //ToString
  Map<String, dynamic> toPrint() {
    return {
      'id': id,
      'userName': userName,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'establishmentName': establishmentName,
    };
  }
}
