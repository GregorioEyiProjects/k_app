import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/server/database/bloc/events/billing_events.dart';
import 'package:k_app/server/database/bloc/states/billing_state.dart';
import 'package:k_app/server/database/objectBox.dart';
import 'package:k_app/server/models/billing-model.dart';

class BillingBloc extends Bloc<BillingEvents, BillingState> {
  final ObjectBox objectBox;

//Constructor
  BillingBloc({required this.objectBox}) : super(BillingInitial()) {
    // --- Event handlers --- //

    // Fetch or load the data
    on<FetchBillings>((event, emit) async {
      debugPrint("Now using the FetchBillings in Bloc");

      //Emit the loading state
      emit(BillingLoading());

      //Get all Billings
      try {
        //Get the billings
        Map<String, dynamic> response =
            await getTheUpdatedBillingsList(objectBox);

        if (response["billingsLoaded"].isEmpty) {
          emit(BillingError(message: 'No billings found'));
          return;
        }

        //ELSE ...

        //Emit the loaded state
        emit(FetchBillingLoaded(
          billingsLoaded: response["billingsLoaded"],
          totalEarningsPerMonthOrTotal: response["totalEarningsInMonth"],
          totalEarningsPerDay: response["totalEarningsPerDay"],
          selectedDateText: "Filter",
          originalCachedBillings: response["billingsLoaded"],
        ));
        debugPrint("Data was emitted in FetchBillings");
      } catch (e) {
        emit(BillingError(message: e.toString()));
      }
    });

    //Update a billing
    on<UpdateBilling>((event, emit) async {
      debugPrint("Now using the UpdateBilling in Bloc");

      //Emit the loading state
      emit(BillingLoading());

      final billingId = event.billingId;
      final billing = event.billing;

      try {
        final response =
            await objectBox.billingRepo.updateBilling(billingId, billing);

        if (response == null || response.id == null) {
          emit(BillingError(message: 'Billing not found'));
          return;
        }

        //ELSE ...

        //Fetch the data again to get the updated list
        final updatedBillings = await objectBox.billingRepo.getBillings();

        //Now get the total earnings for the current month and day
        final currentDayAndMonthBillings =
            await getCurrentDayAndMonthBillings();

        if (currentDayAndMonthBillings["totalEarningsPerDay"] == 0.0 &&
            currentDayAndMonthBillings["totalEarningsInMonth"] == 0.0) {
          emit(BillingError(message: 'No billings found'));
          return;
        }

        //Extract the value
        final totalEarningsPerDay =
            currentDayAndMonthBillings["totalEarningsPerDay"];
        final totalEarningsPerMonthOrTotal =
            currentDayAndMonthBillings["totalEarningsInMonth"];

        //Emit that the data was updated
        emit(BillingUpdated(billingLoaded: response));

        emit(FetchBillingLoaded(
          billingsLoaded: updatedBillings,
          totalEarningsPerMonthOrTotal: totalEarningsPerMonthOrTotal,
          totalEarningsPerDay: totalEarningsPerDay,
          selectedDateText: "Filter",
          originalCachedBillings: updatedBillings,
        ));
        debugPrint("Is it emitted?");
      } catch (e) {
        emit(BillingError(message: e.toString()));
      }
    });

    //Delete a billing
    on<DeleteBilling>((event, emit) async {
      debugPrint("Now using the DeleteBilling in Bloc");

      //Emit the loading state
      emit(BillingLoading());

      try {
        //
        final bool billingResponse =
            await objectBox.billingRepo.deleteBilling(event.billingId);
        debugPrint("Here is the billingResponse $billingResponse");

        if (!billingResponse) {
          emit(BillingError(message: 'Billing not found'));
          return;
        }

        //ELSE ...

        //Emit
        emit(BillingDeleted(isDeleted: billingResponse));

        //Fetch the data again to get the updated list
        //final updatedBillings = await objectBox.billingRepo.getBillings();
        //Now get the total earnings for the current month and day
        //final currentDayAndMonthBillings = await getCurrentDayAndMonthBillings();

        //Emit the loading state
        emit(BillingLoading());

        //Get all Billings
        Map<String, dynamic> response =
            await getTheUpdatedBillingsList(objectBox);

        if (response["billingsLoaded"].isEmpty) {
          emit(BillingError(message: 'No billings found'));
          return;
        }

        //ELSE ...

        //Emit the loaded state
        emit(FetchBillingLoaded(
          billingsLoaded: response["billingsLoaded"],
          totalEarningsPerMonthOrTotal: response["totalEarningsInMonth"],
          totalEarningsPerDay: response["totalEarningsPerDay"],
          selectedDateText: "Filter",
          originalCachedBillings: response["billingsLoaded"],
        ));
        debugPrint("Data was emitted in FetchBillings");
      } catch (e) {
        emit(BillingError(message: e.toString()));
      }
    });

    //Filter the billings by establishment name
    on<FetchBillingsByEstablishmentAndMonth>((event, emit) async {
      debugPrint("Now using the FetchBillingsByEstablishmentAndMonth in Bloc");

      debugPrint(
          "Here is the... establishment name 1 ${event.stablismentName}");
      debugPrint("Here is the... value to filter name ${event.filterValue}");

      try {
        final Map<String, dynamic> response =
            await objectBox.billingRepo.getAllBillingsByEstablishmentAndMonth(
          event.stablismentName,
          event.filterValue,
        );

        //debugPrint("<<< Here is the response in FetchBillingsByEstablishmentAndMonth >>>> ${response['data']}");

        /* for (var element in response['data']) {
          debugPrint("Here is the element ${element.toString()}");
          debugPrint(
              "<<<<<Here is the element amount>>>> ${element.amount} andf the date is ${element.appointmentDate}");
        } */

        //debugPrint("Here is the response in FetchBillingsByEstablishmentAndMonth $response");

        if (response['status'] == 'error') {
          emit(BillingError(message: 'No billings found'));
          return;
        }

        //ELSE ...

        //Get the total earnings for the current month or total
        final totalEarningsPerMonthOrTotal = response['data']
            .fold(0.0, (prev, element) => prev + element.amount);

        emit(BillingLoading()); // Emit a temporary loading state

        emit(
          FetchBillingsByEstablishmentAndMonthLoaded(
            billingsFound: response['data'],
            // timestamp: DateTime.now(),
            totalEarningsPerMonthOrTotal: totalEarningsPerMonthOrTotal,
          ),
        );
        debugPrint("Data was emitted in FetchBillingsByEstablishmentAndMonth");
        //}
      } catch (e) {
        emit(BillingError(message: e.toString()));
      }
    });

    //Filter this month billings and display the total amount
    on<FetchCurrentDayAndMonthBillings>((event, emit) async {
      debugPrint("Now using the FetchCurrentDayAndMonthBillings in Bloc");

      try {
        // ----- Get the total earnings for the current day ----- //

        // Get and Update the total amount for today
        DateTime now = DateTime.now();
        DateTime startTime = DateTime(now.year, now.month, now.day);
        DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
        debugPrint("Here is the start time $startTime");
        debugPrint("Here is the end time $endTime");

        //Make a request to the DB to get the total amount for today
        final todalTodayAmountResponse = await objectBox.billingRepo
            .getBillingListByDate(startTime, endTime);

        //Check if the response is empty
        if (todalTodayAmountResponse.isEmpty) {
          emit(BillingError(message: 'No billings found'));
          return;
        }

        //ELSE ...
        //Output the total amount for today
        for (Billing billing in todalTodayAmountResponse) {
          debugPrint("Here is the billing amount ${billing.amount}");
        }

        // -------- Get the total amount for today ---------  //
        final totalEarningsPerDay = todalTodayAmountResponse.fold(
            0.0, (previousValue, element) => previousValue + element.amount);
        debugPrint("Here is the total amount for today $totalEarningsPerDay");

        //Get the total earnings for the current Month
        final Map<String, dynamic> response =
            await objectBox.billingRepo.getCurrentMonthBillingsInDB();

        if (response.isEmpty) {
          emit(BillingError(message: 'No billings found'));
          return;
        }
        //ELSE ...

        //Get the total earnings in the current month
        final totalEarningsInMonth = response['data'].fold(
            0.0, (previousValue, element) => previousValue + element.amount);
        debugPrint(
            "Here is the total earnings in the current month $totalEarningsInMonth");

        // ----------- Emit the loaded state  ----------- //
        emit(
          FilterCurrentMonthBillingsLoaded(
            totalEarningsPerMonthOrTotal: totalEarningsInMonth,
            totalEarningsPerDay: totalEarningsPerDay,
            //originalCachedBillings: cachedBillings!,
          ),
        );

        return;
      } catch (e) {
        emit(BillingError(message: e.toString()));
      }
    });

    //Filter the billings created within a day and display the total amount
    on<FetchBillingsByDay>(
      (event, emit) async {
        debugPrint("Now using the FetchBillingsByDay in Bloc");

        //Emit the loading state
        emit(BillingLoading());

        try {
          debugPrint("Here is the start date ${event.startDate}");
          debugPrint("Here is the end date ${event.endDate}");
          final response = await objectBox.billingRepo.getBillingListByDate(
            event.startDate,
            event.endDate,
          );

          if (response.isEmpty) {
            emit(BillingError(message: 'No billings found'));
            return;
          }

          debugPrint(
              "Here is the response in FetchBillingsByDay ${response.toString()}");

          //ELSE ...
          // Retrieve the previous value of totalEarningsPerMonthOrTotal
          double? previousTotalEarnings = state.totalEarningsPerMonthOrTotal;
          debugPrint(
              "Here is the previous total earnings $previousTotalEarnings");

          //  Emit the loaded state
          emit(
            BillingsByDayLoaded(
              billingsFound: response,
              totalEarningsPerMonthOrTotal: previousTotalEarnings,
            ),
          );
        } catch (e) {
          emit(BillingError(message: e.toString()));
        }
      },
    );

    //Get default filter text value (UNSUED)
    on<UpdateDateFilter>((event, emit) {
      debugPrint("Now using the UpdateDateFilter in Bloc");
      if (state is FetchBillingLoaded) {
        debugPrint("State is BillingLoaded");
        final currentState = state as FetchBillingLoaded;
        debugPrint(
            "CurrentState.totalEarningsPerDay in UpdateDateFilter ${currentState.totalEarningsPerDay}");
        debugPrint(
            "CurrentState.totalEarningsPerMonthOrTotal UpdateDateFilter ${currentState.totalEarningsPerMonthOrTotal}");

        emit(
          FetchBillingLoaded(
            billingsLoaded: currentState.billingsLoaded,
            //totalEarningsPerMonthOrTotal:currentState.totalEarningsPerMonthOrTotal,
            selectedDateText: event.dateText,
            originalCachedBillings: currentState.originalCachedBillings,
          ),
        );
        debugPrint("State returned");

        return;
      }

      debugPrint("State is NOT BillingLoaded");
    });

    //Reset the UI
    on<ResetBillings>((event, emit) {
      final currentState = state as FetchBillingLoaded;
      //final cachedBillings = currentState.originalCachedBillings;
      //final totalEarningsPerMonthOrTotal = currentState.totalEarningsPerMonthOrTotal;
      emit(FetchBillingLoaded(
        billingsLoaded: currentState.originalCachedBillings!,
        totalEarningsPerMonthOrTotal: currentState.totalEarningsPerMonthOrTotal,
        selectedDateText: "Filter",
        originalCachedBillings: currentState.originalCachedBillings!,
      ));
    });
  }

// ------ ------ Methods ------ ------ //
  Future<Map<String, dynamic>> getTheUpdatedBillingsList(
    ObjectBox objectBox,
  ) async {
    //
    //final List<Billing> listOfBillingsFound =await objectBox.billingRepo.getBillings();
    final Map<String, dynamic> listOfBillingsFound =
        await objectBox.billingRepo.getCurrentMonthBillingsInDB();
    debugPrint(
        "Here is the response in FetchAppointments $listOfBillingsFound");

    if (listOfBillingsFound['status'] == 'error') {
      //emit(BillingError(message: 'No billings found'));
      return {
        "totalEarningsPerDay": 0.0,
        "totalEarningsInMonth": 0.0,
        "billingsLoaded": listOfBillingsFound['data']
      };
    }

    //ELSE ...

    //Now get the total earnings for the current month and day
    final currentDayAndMonthBillings = await getCurrentDayAndMonthBillings();

    if (currentDayAndMonthBillings["totalEarningsPerDay"] == 0.0 &&
        currentDayAndMonthBillings["totalEarningsInMonth"] == 0.0) {
      debugPrint("Both are  0.0");
      return {
        "totalEarningsPerDay": 0.0,
        "totalEarningsInMonth": 0.0,
        "billingsLoaded": listOfBillingsFound['data']
      };
    }

    //Extract the value
    final totalEarningsPerDay =
        currentDayAndMonthBillings["totalEarningsPerDay"];
    final totalEarningsPerMonthOrTotal =
        currentDayAndMonthBillings["totalEarningsInMonth"];
    debugPrint(
        "Here is the total earnings per day after getting it with getCurrentDayAndMonthBillings  $totalEarningsPerDay");
    debugPrint(
        "Here is the total earnings per month after getting it with getCurrentDayAndMonthBillings $totalEarningsPerMonthOrTotal");

    return {
      "totalEarningsPerDay": totalEarningsPerDay,
      "totalEarningsInMonth": totalEarningsPerMonthOrTotal,
      "billingsLoaded": listOfBillingsFound['data']
    };
  }

//Get the total earnings for the current day and month
  Future<Map<String, dynamic>> getCurrentDayAndMonthBillings() async {
    debugPrint("Now using the getCurrentDayAndMonthBillings method");

    //
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day);
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    debugPrint("Here is the start time $startTime");
    debugPrint("Here is the end time $endTime");

    //Make a request to the DB to get the total amount for today
    final todalTodayAmountResponse =
        await objectBox.billingRepo.getBillingListByDate(startTime, endTime);

    debugPrint(
        "Here is the response in getCurrentDayAndMonthBillings $todalTodayAmountResponse");

    //Check if the response is empty
    if (todalTodayAmountResponse.isEmpty) {
      debugPrint(
          "No billings found for today. \nSo now searching for the current month");
      //emit(BillingError(message: 'No billings found'));
      //return {"totalEarningsPerDay": 0.0, "totalEarningsInMonth": 0.0};
    }

    //ELSE ...
    //Output the total amount for today
    /*  for (Billing billing in todalTodayAmountResponse) {
      debugPrint("Here is the billing amount ${billing.amount}");
    } */

    // -------- Get the total amount for today ---------  //
    final totalEarningsPerDay = todalTodayAmountResponse.fold(
        0.0, (previousValue, element) => previousValue + element.amount);
    debugPrint("Here is the total amount for today $totalEarningsPerDay");

    //Get the total earnings for the current Month
    final Map<String, dynamic> response =
        await objectBox.billingRepo.getCurrentMonthBillingsInDB();

    if (response['status'] == 'error') {
      //emit(BillingError(message: 'No billings found'));
      return {"totalEarningsPerDay": 0.0, "totalEarningsInMonth": 0.0};
    }
    //ELSE ...
    debugPrint("Here is the response in getCurrentMonthBillingsInDB $response");

    //Get the total earnings in the current month
    final totalEarningsInMonth = response['data']
        .fold(0.0, (previousValue, element) => previousValue + element.amount);
    debugPrint(
        "Here is the total earnings in the current month $totalEarningsInMonth");

    return {
      "totalEarningsPerDay": totalEarningsPerDay,
      "totalEarningsInMonth": totalEarningsInMonth
    };
  }
}
