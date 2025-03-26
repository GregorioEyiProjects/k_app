import 'package:flutter/material.dart';
import 'package:k_app/client/models/home/v2/event.dart';
import 'package:k_app/server/database/objectBox.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';

class AppProvider with ChangeNotifier {
  final ObjectBox objectBox;

  //Constructor
  AppProvider(this.objectBox);

  //Private list
  List<Appointment> _events = [];
  List<Billing> _billingList = [];

  Map<DateTime, List<String>> _events2 = {};
  List<CalendarEvent> _events3 = [];

  //Public list
  List<Appointment> get listOfEvents => _events;
  List<Billing> get billingList => _billingList;

  //Fetch events Or get all Appointments
  Future<void> fetchEvents() async {
    _events = await objectBox.appointmentRepo.getAppointments();
    _billingList = await objectBox.billingRepo.getBillings();
    print("Events 3 ${_events.toString()}");
    notifyListeners();
  }

  /*
      Appointment methos
  */

  //Add Events to the ObjectBox list
  Future<int> addEventToObjexBox(
    String userName,
    DateTime date,
    TimeOfDay time,
    String establishmentName,
  ) async {
    Appointment appointment = Appointment(
      userName: userName,
      appointmentDate: date,
      appointmentTime: Appointment.timeOfDayToString(time),
      establishmentName: establishmentName,
    );

    //Add to the objectBox
    final Appointment appointmentResponse =
        await objectBox.appointmentRepo.addAppointment(appointment);

    if (appointmentResponse.id != null) {
      //Add to the list
      _events.add(appointmentResponse);
      notifyListeners();
      debugPrint('Appointment added to the list');
      return appointmentResponse.id!;
    }

    return -1;
  }

  //Delete Events or Appointments
  deleteEventToObjexBox(int appointmentID) {
    //Remove from the objectBox
    objectBox.appointmentRepo.deleteAppointment(appointmentID);

    //Remove from the list
    _events.removeWhere((element) => element.id == appointmentID);
    notifyListeners();
  }

  //Add Events to the Temporal list
  addEventTo(String userName, DateTime date, TimeOfDay time) {
    //CalendarEvent.addEvent(userName, date, time);
    //notifyListeners();
  }

  /*
      Billing methos
  */

  //Add a billing
  void addBilling(Billing billing) async {
    await objectBox.billingRepo.addBilling(billing);
    _billingList.add(billing);
    notifyListeners();
  }

  //Get billing by date
  Future<List<Billing>> getBillingByDate(DateTime startDate, DateTime endDate) {
    //print('Passing from getBillingByDate in the PROVIDER . . . ');
    final respone =
        objectBox.billingRepo.getBillingListByDate(startDate, endDate);

    return respone;
    // return _billingList.where((element) => element.date == date).toList();
  }

  //Get all billings by Establishment name
  Future<List<Billing>> getBillingByEstablishment(String establishmentName) {
    final response =
        objectBox.billingRepo.getAllBillingsByEstablishment(establishmentName);
    return response;
  }

  //Get all billings by Establishment name and Month
  Future<List<Billing>> getBillingByEstablishmentAndMonth(
      String establishmentName, String month) {
    print(
        'Passing from getBillingByEstablishmentAndMonth in the PROVIDER . . . ');
    //print('Establishment Name: $establishmentName');
    //print('Month: $month');
    final response = objectBox.billingRepo
        .getAllBillingsByEstablishmentAndMonth(establishmentName, month);
    return response;
  }

  // Get getCurrentMonthBillings
  Future<List<Billing>> getCurrentMonthBillings() {
    final response = objectBox.billingRepo.getCurrentMonthBillingsInDB();
    return response;
  }

  //Update Events or Appointments
  Future<Billing?> updateBillingTo(int id, Billing billing) async {
    final billingSave = await objectBox.billingRepo.updateBilling(id, billing);
    notifyListeners();
    return billingSave;
  }

  Future<bool> deleteBilling(int id) async {
    final billingResponse = await objectBox.billingRepo.deleteBilling(id);
    notifyListeners();
    return billingResponse;
  }
}
