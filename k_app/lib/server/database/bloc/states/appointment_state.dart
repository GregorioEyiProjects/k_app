/* */
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:k_app/server/models/appointment-model.dart';
//part of '../appointmemt_bloc.dart';

abstract class AppointmentState extends Equatable {
  final List<Appointment>? cachedAppointments;
  const AppointmentState({this.cachedAppointments});

  @override
  List<Object> get props => [];
}

//Initial state
class AppointmentInitial extends AppointmentState {}

//Loading state
class AppointmentLoading extends AppointmentState {}

//Loaded state (First State)
class AppointmentLoaded extends AppointmentState {
  //
  final List<Appointment> appointments;

  // Cached list of appointments
  //final List<Appointment> cachedAppointments;
  //final List<Appointment> appointments;

  //Constructor
  const AppointmentLoaded(
    this.appointments, {
    super.cachedAppointments,
  });

  @override
  List<Object> get props => [appointments];
}

//Filter data by Establishment name
class AppointmentFiltered extends AppointmentState {
  final List<Appointment> filteredAppointments; // Filtered list
  final List<Appointment> allAppointments; // Original list

  const AppointmentFiltered({
    required this.filteredAppointments,
    required this.allAppointments,
  });

  @override
  List<Object> get props => [filteredAppointments, allAppointments];
}

// Added state
class AppointmentAdded extends AppointmentState {
  final Appointment appointment;
  const AppointmentAdded({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

// Deleted state
class AppointmentDeleted extends AppointmentState {
  final bool isDeleted;
  const AppointmentDeleted({required this.isDeleted});

  @override
  List<Object> get props => [isDeleted];
}

//Appointment paid state
class AppointmentPaid extends AppointmentState {
  final bool isPaid;
  const AppointmentPaid({required this.isPaid});

  @override
  List<Object> get props => [isPaid];
}

//Reset state when the UI is reset
class UIReset extends AppointmentState {}

//------- Error state ---------//
class AppointmentError extends AppointmentState {
  final String message;
  const AppointmentError({required this.message});

  @override
  List<Object> get props => [message];
}
