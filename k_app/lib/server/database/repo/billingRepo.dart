import 'package:flutter/material.dart';
import 'package:k_app/objectbox.g.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:objectbox/objectbox.dart';

class BillingRepo {
  //Model or Entity or DataClass
  late final Box<Billing> _billingBox;

  //Constructor
  BillingRepo(Store store) : _billingBox = store.box<Billing>();

  // Get billings
  Future<List<Billing>> getBillings() async {
    return _billingBox.getAll();
  }

  // Add billings
  Future<Billing> addBilling(Billing billing) async {
    final response = await _billingBox.putAndGetAsync(billing);
    return response;
  }

  // Update a billing
  Future<Billing?> updateBilling(
    int id,
    Billing billing,
  ) async {
    //Check if the billing is already in the database//
    final query = _billingBox.query(Billing_.id.equals(id)).build();
    final Billing? billingList = query.findFirst();
    query.close();

    if (billingList == null) {
      debugPrint('Billing not found');
      return null;
    }

    //Update the billing
    if (billing.id == id) {
      //await _billingBox.putAsync(billing);
      final Billing response = await _billingBox.putAndGetAsync(billing);
      debugPrint('Billing updated. Now returning from the BillingRepo. . .');
      return response;
    } else {
      debugPrint('Billing ID is not the same');
      //Return null for now
      return null;
    }
  }

  // Delete billings
  Future<bool> deleteBilling(int billingID) async {
    final bool wasIsRemoved = _billingBox.remove(billingID);
    return wasIsRemoved;
  }

  //Get billings by date
  Future<List<Billing>> getBillingListByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    debugPrint('Filtering data in DB . . . ');

    // List<Billing> filteredBillingListToSend = [];
    //Query
    final query = _billingBox
        .query(Billing_.appointmentDate.between(
            startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch))
        .build();

    // Get the list
    final filteredBillingList = query.find();

    if (filteredBillingList.isEmpty) {
      debugPrint('No billings FOUND for today.');
      return [];
    }

    debugPrint('Billings FOUND for today. Now returning . . . ');
    return filteredBillingList;
  }

  // Get getCurrentMonthBillings
  Future<Map<String, dynamic>> getCurrentMonthBillingsInDB() async {
    debugPrint('Getting current month billings in DB . . . ');

    // Get the current month and year
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    // Create the start and end dates for the query
    DateTime startDate = DateTime(currentYear, currentMonth, 1);
    DateTime endDate =
        DateTime(currentYear, currentMonth + 1, 1).subtract(Duration(days: 1));

    //Query
    final query = _billingBox
        .query(Billing_.appointmentDate.between(
            startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch))
        .build();

    // Get the list
    final filteredBillingList = query.find();

    if (filteredBillingList.isEmpty) {
      debugPrint('No billings FOUND for this month. Now returning . . . ');
      final errorData = {
        'status': 'error',
        'message': 'No billings FOUND for this month.',
        'data': [],
      };
      return errorData;
    }

    if (filteredBillingList.isEmpty) {
      debugPrint('No billings FOUND for this month. Now returning . . . ');
      final errorData = {
        'status': 'error',
        'message': 'No billings FOUND for this month.',
        'data': [],
      };

      return errorData;
    }

    //ELSE ...
    final successData = {
      'status': 'success',
      'message': 'Billings FOUND for this month.',
      'data': filteredBillingList,
    };

    debugPrint('Billings FOUND for this month. Now returning . . . ');
    return successData;
  }

  //Get all  billings by Establishment name
  Future<List<Billing>> getAllBillingsByEstablishment(
      String establishmentName) async {
    //Query
    final query = _billingBox
        .query(Billing_.establismentName.equals(establishmentName))
        .build();

    // Get the list
    final filteredBillingList = query.find();

    return filteredBillingList;
  }

  //Get all billings by Establishment name and Month
  Future<Map<String, dynamic>> getAllBillingsByEstablishmentAndMonth(
      String establishmentName, String month) async {
    debugPrint('Filtering data . . . ');
    int monthNumber = 0;
    bool isAll = month == 'All' ? true : false;

    switch (month) {
      case 'January':
        monthNumber = 1;
        break;
      case 'February':
        monthNumber = 2;
        break;
      case 'March':
        monthNumber = 3;
        break;
      case 'April':
        monthNumber = 4;
        break;
      case 'May':
        monthNumber = 5;
        break;
      case 'June':
        monthNumber = 6;
        break;
      case 'July':
        monthNumber = 7;
        break;
      case 'August':
        monthNumber = 8;
        break;
      case 'September':
        monthNumber = 9;
        break;
      case 'October':
        monthNumber = 10;
        break;
      case 'November':
        monthNumber = 11;
        break;
      case 'December':
        monthNumber = 12;
        break;
      default:
        monthNumber = 0;
    }

    //Check if the month is not selected
    if (monthNumber == 0 && !isAll) {
      debugPrint('No month was selected');
      final data = {
        'status': 'error',
        'message': 'No month was selected',
        'data': [],
      };
      return data;
    }

    debugPrint('Month Number >>> : $monthNumber');
    debugPrint('Establishment Name >>> : $establishmentName');

    //Default list
    List<Billing> filteredBillingList = [];

    // Get the current year
    final int currentYear = DateTime.now().year;

    // Create the start and end dates for the query
    DateTime startDate = DateTime(currentYear, monthNumber, 1);
    DateTime endDate = DateTime(currentYear, monthNumber + 1, 1).subtract(Duration(
        milliseconds:
            1)); //it was days: 1 and it was giving me '<<< End Date  >>> : 2025-03-31 00:00:00.000'

    debugPrint(' <<< End Date  >>> : $endDate');

    if (establishmentName == 'All') {
      debugPrint('All was selectd . . .');

      //Query
      final query = _billingBox
          .query(
            Billing_.appointmentDate.between(startDate.millisecondsSinceEpoch,
                endDate.millisecondsSinceEpoch),
          )
          .build();
      // Get the list
      filteredBillingList = query.find();

      //Check if the list is empty
      if (filteredBillingList.isEmpty) {
        debugPrint('No billings FOUND for this month. Now returning . . . ');

        final data = {
          'status': 'error',
          'message': 'No billings FOUND for this month.',
          'data': [],
        };
        return data;
      }

      //ELSE ...
      final responsData = {
        'status': 'success',
        'message': 'Billings FOUND for this month.',
        'data': filteredBillingList,
      };

      debugPrint(
          'Filtered list length >>> : ${(responsData['data'] as List<Billing>).length}');
      return responsData;
    }

    // ---- If establishmentName is not All ----

    //Query
    final query = _billingBox
        .query(
          Billing_.establismentName.equals(establishmentName).and(
                Billing_.appointmentDate.between(
                    startDate.millisecondsSinceEpoch,
                    endDate.millisecondsSinceEpoch),
              ),
        )
        .build();
    // Get the list
    filteredBillingList = query.find();

    if (filteredBillingList.isEmpty) {
      debugPrint('No billings FOUND for this month. Now returning . . . ');

      final data = {
        'status': 'error',
        'message': 'No billings FOUND for this month.',
        'data': [],
      };
      return data;
    }

    //ELSE ...
    final responsData = {
      'status': 'success',
      'message': 'Billings FOUND for this month.',
      'data': filteredBillingList,
    };

    debugPrint(
        'Filtered list length >>> : ${(responsData['data'] as List<Billing>).length}');

    return responsData;
  }
}
