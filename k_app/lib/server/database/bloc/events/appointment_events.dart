/* */
import 'package:equatable/equatable.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
// part of '../appointmemt_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

//Fetch or load the appointments
class FetchAppointments extends AppointmentEvent {}

//Add an appointment
class AddAppointment extends AppointmentEvent {
  final Appointment appointment;
  const AddAppointment({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

//Filter the appointments by establishment name
class FilterAppointmentsByEstablishmentName extends AppointmentEvent {
  final String filterValue;

  const FilterAppointmentsByEstablishmentName(this.filterValue);

  @override
  List<Object> get props => [filterValue];
}

//Delete an appointment
class DeleteAppointment extends AppointmentEvent {
  final int appointmentId;
  const DeleteAppointment({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

//Make a payment
class MakePayement extends AppointmentEvent {
  //Variables
  /*  final int id;
  final int appointmentID;
  final String customerName;
  final DateTime appointmentDate;
  final String appointmentTime;
  final double amount;
  final DateTime? date = DateTime.now();
  final String establismentName; */
  final Billing billing;

  //Constructor
  const MakePayement(this.billing);

  @override
  List<Object> get props => [billing];
}

//Reset the UI
class ResetAppointments extends AppointmentEvent {}
