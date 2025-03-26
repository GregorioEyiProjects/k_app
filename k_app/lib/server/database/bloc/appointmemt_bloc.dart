import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/server/database/bloc/events/appointment_events.dart';
import 'package:k_app/server/database/bloc/states/appointment_state.dart';
import 'package:k_app/server/database/objectBox.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';

/* import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:k_app/server/models/billing-model.dart'; */

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  //Get the objectBox
  final ObjectBox objectBox;

  AppointmentBloc({required this.objectBox}) : super(AppointmentInitial()) {
    //
    //--- Events ---//
    //Fetch or load the data
    on<FetchAppointments>(
      (event, emit) async {
        debugPrint("Now using the FetchAppointments in Bloc");

        //Emit the loading state
        emit(AppointmentLoading());

        try {
          final response = await objectBox.appointmentRepo.getAppointments();
          debugPrint("Here is the response in FetchAppointments $response");

          emit(AppointmentLoaded(response, cachedAppointments: response));
        } catch (e) {
          emit(AppointmentError(message: e.toString()));
        }
      },
    );

    //Add an appointment
    on<AddAppointment>(
      (event, emit) async {
        debugPrint("Now using the AddAppointment in Bloc");

        //Emit the loading state
        emit(AppointmentLoading());

        try {
          //Add the appointment
          final Appointment appointmentAdded =
              await objectBox.appointmentRepo.addAppointment(event.appointment);

          if (appointmentAdded.id != null) {
            //Fetch the data to display the new appointment
            emit(AppointmentAdded(appointment: appointmentAdded));

            //Fetch the data to display the new appointment
            add(FetchAppointments());
          } else {
            emit(AppointmentError(message: 'Failed to add appointment'));
          }
        } catch (e) {
          emit(AppointmentError(message: e.toString()));
        }
      },
    );

    //Fecth the data by establishment name
    on<FilterAppointmentsByEstablishmentName>(
      (event, emit) async {
        debugPrint(
            "Now using the FilterAppointmentsByEstablishmentName in Bloc");
        //debugPrint("Here is the filter value ${event.filterValue}");

        if (state is AppointmentLoaded) {
          debugPrint("state is AppointmentLoaded");
          final currentState = state as AppointmentLoaded;

          // Use the cached list of appointments
          final appointments = currentState.cachedAppointments;
          debugPrint("Cached appointments: $appointments");

          _filterAndEmit(event.filterValue, appointments!, emit);
        } else if (state is AppointmentFiltered) {
          debugPrint("state is AppointmentFiltered");
          final currentState = state as AppointmentFiltered;

          // Use the cached list of appointments
          final appointments = currentState.allAppointments;
          debugPrint("Cached appointments: $appointments");

          // Use the original list of appointments
          _filterAndEmit(event.filterValue, currentState.allAppointments, emit);
        } else {
          debugPrint("No cached data with ${event.filterValue}");
          // If there's no cached data, emit an error state
          emit(
              AppointmentError(message: 'No appointments available to filter'));
        }
      },
    );

    //Delete the data
    on<DeleteAppointment>((event, emit) async {
      debugPrint("Now using the DeleteAppointment in Bloc");

      //Emit the loading state
      emit(AppointmentLoading());

      try {
        final bool response = await objectBox.appointmentRepo
            .deleteAppointment(event.appointmentId);
        debugPrint("Here is the response in DeleteAppointment $response");

        if (response) {
          //Emmit the deleted appointment so i can display a message
          emit(AppointmentDeleted(isDeleted: response));

          //Fetch the data to display the new state
          add(FetchAppointments());
        } else {
          emit(AppointmentError(message: 'Failed to delete appointment'));
        }
      } catch (e) {
        emit(AppointmentError(message: e.toString()));
      }
    });

    //Make a payment
    on<MakePayement>((event, emit) async {
      debugPrint("Now using the MakePayement in Bloc");

      //Emit the loading state
      emit(AppointmentLoading());

      try {
        final Billing response =
            await objectBox.billingRepo.addBilling(event.billing);

        if (response.id == null) {
          emit(AppointmentError(message: 'Failed to make payment'));
        } else {
          //Emit the payment
          emit(AppointmentPaid(isPaid: true));

          //Delete the appointment after payment
          add(DeleteAppointment(appointmentId: event.billing.appointmentID));

          //Fetch the data to display the new state
          add(FetchAppointments());
        }
      } catch (e) {
        emit(AppointmentError(message: e.toString()));
      }
    });
  }

  void _filterAndEmit(
    String filterValue,
    List<Appointment> appointments,
    Emitter<AppointmentState> emit,
  ) {
    //Emmit the loading state
    emit(AppointmentLoading());

    debugPrint("Filtering appointments with value: $filterValue");
    debugPrint("Cached appointments: $appointments");

    // Filter the appointments
    final filteredAppointments = filterValue == 'All'
        ? appointments
        : appointments
            .where(
                (appointment) => appointment.establishmentName == filterValue)
            .toList();
    debugPrint("Filtered appointments: $filteredAppointments");

    // Emit the filtered appointments
    emit(
      AppointmentFiltered(
        filteredAppointments: filteredAppointments,
        allAppointments: appointments,
      ),
    );
  }
}
