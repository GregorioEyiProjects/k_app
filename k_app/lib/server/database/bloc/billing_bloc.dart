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
        final List<Billing> response =
            await objectBox.billingRepo.getBillings();
        debugPrint("Here is the response in FetchAppointments $response");

        if (response.isEmpty) {
          emit(BillingError(message: 'No billings found'));
          return;
        }

        //ELSE ...

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
        //debugPrint("Here is the total earnings per day after getting it with getCurrentDayAndMonthBillings  $totalEarningsPerDay");
        //debugPrint("Here is the total earnings per month after getting it with getCurrentDayAndMonthBillings $totalEarningsPerMonthOrTotal");

        //Emit the loaded state
        emit(FetchBillingLoaded(
          billingsLoaded: response,
          totalEarningsPerMonthOrTotal: totalEarningsPerMonthOrTotal,
          totalEarningsPerDay: totalEarningsPerDay,
          selectedDateText: "Filter",
          originalCachedBillings: response,
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
    on<DeleteBilling>((event, emit) {});

    //Filter the billings by establishment name
    on<FetchBillingsByEstablishmentAndMonth>((event, emit) async {
      debugPrint("Now using the FetchBillingsByEstablishmentAndMonth in Bloc");

      debugPrint(
          "Here is the... establishment name 1 ${event.stablismentName}");
      debugPrint("Here is the... value to filter name ${event.filterValue}");

      try {
        if (event.stablismentName == "All") {
          // Fetch all billings
          add(FetchBillings());
          // Fetch the current day and month billing amount
          //add(FetchCurrentDayAndMonthBillings());
        } else {
          // Handle specific establishment filtering
          final List<Billing> response =
              await objectBox.billingRepo.getAllBillingsByEstablishmentAndMonth(
            event.stablismentName,
            event.filterValue,
          );

          debugPrint(
              "Here is the response in FetchBillingsByEstablishmentAndMonth $response");

          if (response.isEmpty) {
            emit(BillingError(message: 'No billings found'));
            return;
          }

          //ELSE ...

          //Get the total earnings for the current month or total
          final totalEarningsPerMonthOrTotal =
              response.fold(0.0, (prev, element) => prev + element.amount);

          emit(BillingLoading()); // Emit a temporary loading state

          emit(
            FetchBillingsByEstablishmentAndMonthLoaded(
              billingsFound: response,
              // timestamp: DateTime.now(),
              totalEarningsPerMonthOrTotal: totalEarningsPerMonthOrTotal,
            ),
          );
          debugPrint(
              "Data was emitted in FetchBillingsByEstablishmentAndMonth");
        }
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
        final List<Billing> response =
            await objectBox.billingRepo.getCurrentMonthBillingsInDB();

        if (response.isEmpty) {
          emit(BillingError(message: 'No billings found'));
          return;
        }
        //ELSE ...

        //Get the total earnings in the current month
        final totalEarningsInMonth = response.fold(
            0.0, (previousValue, element) => previousValue + element.amount);
        debugPrint(
            "Here is the total earnings in the current month $totalEarningsInMonth");

        // Get the original list of billings
        // final currentState = state as BillingLoaded;
        //final cachedBillings = currentState.originalCachedBillings;

        //debugPrint("CurrentState.totalEarningsPerDay in FetchCurrentDayAndMonthBillings ${currentState.totalEarningsPerDay}");
        //debugPrint("CurrentState.totalEarningsPerMonthOrTotal FetchCurrentDayAndMonthBillings ${currentState.totalEarningsPerMonthOrTotal}");

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

  Future<Map<String, dynamic>> getCurrentDayAndMonthBillings() async {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day);
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    debugPrint("Here is the start time $startTime");
    debugPrint("Here is the end time $endTime");

    //Make a request to the DB to get the total amount for today
    final todalTodayAmountResponse =
        await objectBox.billingRepo.getBillingListByDate(startTime, endTime);

    //Check if the response is empty
    if (todalTodayAmountResponse.isEmpty) {
      //emit(BillingError(message: 'No billings found'));
      return {"totalEarningsPerDay": 0.0, "totalEarningsInMonth": 0.0};
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
    final List<Billing> response =
        await objectBox.billingRepo.getCurrentMonthBillingsInDB();

    if (response.isEmpty) {
      //emit(BillingError(message: 'No billings found'));
      return {"totalEarningsPerDay": 0.0, "totalEarningsInMonth": 0.0};
    }
    //ELSE ...

    //Get the total earnings in the current month
    final totalEarningsInMonth = response.fold(
        0.0, (previousValue, element) => previousValue + element.amount);
    debugPrint(
        "Here is the total earnings in the current month $totalEarningsInMonth");

    return {
      "totalEarningsPerDay": totalEarningsPerDay,
      "totalEarningsInMonth": totalEarningsInMonth
    };
  }
}
