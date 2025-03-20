import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Billing {
  int? id;
  int appointmentID;
  String customerName;
  @Property(type: PropertyType.date)
  DateTime appointmentDate; //Date of appointment
  String appointmentTime; //Time of appointment
  double amount;
  DateTime? date = DateTime.now(); //Date of billing
  String establismentName;

  Billing({
    this.id,
    required this.customerName,
    required this.appointmentID,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.amount,
    this.date,
    required this.establismentName,
  });

  //Helper method to check if it is a double
  static double isDouble(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    final number = double.tryParse(value);
    print('Number: $number');

    return number ?? 0.0;
  }

  //Helper method to convert TimeOfDay to String
  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  //Helper method to convert String to TimeOfDay
  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

//ToString
  Map<String, dynamic> toPrint() {
    return {
      'id': id,
      'customerName': customerName,
      'appointmentID': appointmentID,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'amount': amount,
      'establismentName': establismentName,
    };
  }
}
