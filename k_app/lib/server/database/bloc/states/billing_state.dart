import 'package:equatable/equatable.dart';
import 'package:k_app/server/models/billing-model.dart';

abstract class BillingState extends Equatable {
  final double totalEarningsPerMonthOrTotal;
  final double totalEarningsPerDay;
  final String selectedDateText;
  final List<Billing>? originalCachedBillings;

  const BillingState({
    this.totalEarningsPerMonthOrTotal = 0.0,
    this.totalEarningsPerDay = 0.0,
    this.selectedDateText = "Filter",
    this.originalCachedBillings,
  });

  @override
  List<Object> get props =>
      [selectedDateText, totalEarningsPerMonthOrTotal, originalCachedBillings!];
}

// ----------- Initial state  & Loading state -----------////
class BillingInitial extends BillingState {
  const BillingInitial();
}

class BillingLoading extends BillingState {
  const BillingLoading();
}

// ----------- Loaded states ----------- ////
//Loaded state
class FetchBillingLoaded extends BillingState {
  final List<Billing> billingsLoaded;

  //Constructor
  const FetchBillingLoaded({
    required this.billingsLoaded,
    super.totalEarningsPerMonthOrTotal = 0.0,
    super.totalEarningsPerDay = 0.0,
    super.selectedDateText = "Filter",
    super.originalCachedBillings,
  });

  @override
  List<Object> get props => [
        billingsLoaded,
        totalEarningsPerMonthOrTotal,
        selectedDateText,
        originalCachedBillings!
      ];
}

//BillingsByEstablishmentAndMonthLoaded state
class FetchBillingsByEstablishmentAndMonthLoaded extends BillingState {
  final List<Billing> billingsFound;
  // final DateTime timestamp;

  const FetchBillingsByEstablishmentAndMonthLoaded({
    required this.billingsFound,
    //required this.timestamp,
    super.totalEarningsPerMonthOrTotal = 0.0,
    super.totalEarningsPerDay = 0.0,
    super.selectedDateText = "Filter",
    super.originalCachedBillings,
  });

  @override
  List<Object> get props => [
        billingsFound,
        // timestamp,
        totalEarningsPerMonthOrTotal,
        totalEarningsPerDay,
        selectedDateText,
        originalCachedBillings!
      ];
}

//FetchBillingsByDayLoaded state
class BillingsByDayLoaded extends BillingState {
  final List<Billing> billingsFound;

  const BillingsByDayLoaded({
    required this.billingsFound,
    super.totalEarningsPerMonthOrTotal = 0.0,
    super.totalEarningsPerDay = 0.0,
    super.selectedDateText = "Filter",
    super.originalCachedBillings,
  });

  @override
  List<Object> get props => [
        billingsFound,
        totalEarningsPerMonthOrTotal,
        totalEarningsPerDay,
        selectedDateText,
        originalCachedBillings!
      ];
}

//FilterCurrentMonthBillingsInDB state
class FilterCurrentMonthBillingsLoaded extends BillingState {
  //final double totalEarningsPerDay;
  //final List<Billing> billingListCache;

  const FilterCurrentMonthBillingsLoaded({
    super.totalEarningsPerMonthOrTotal = 0.0,
    super.totalEarningsPerDay = 0.0,
    super.selectedDateText = "Filter",
    super.originalCachedBillings,
  });

  @override
  List<Object> get props => [
        totalEarningsPerMonthOrTotal,
        totalEarningsPerDay,
        selectedDateText,
        originalCachedBillings!
      ];
}

//Deleted state
class BillingDeleted extends BillingState {
  final bool isDeleted;

  const BillingDeleted({
    required this.isDeleted,
    super.totalEarningsPerMonthOrTotal = 0.0,
    super.totalEarningsPerDay = 0.0,
    super.originalCachedBillings,
    super.selectedDateText = "Filter",
  });

  @override
  List<Object> get props => [
        isDeleted,
        totalEarningsPerMonthOrTotal,
        totalEarningsPerDay,
        selectedDateText
      ];
}

//Updated state
class BillingUpdated extends BillingState {
  final Billing billingLoaded;

  const BillingUpdated({
    required this.billingLoaded,
    super.totalEarningsPerMonthOrTotal,
    super.totalEarningsPerDay,
    super.selectedDateText = "Filter",
    super.originalCachedBillings,
  });

  @override
  List<Object> get props => [
        billingLoaded,
        totalEarningsPerMonthOrTotal,
        totalEarningsPerDay,
        selectedDateText,
        originalCachedBillings!,
      ];
}

//Reset state when the UI is reset
class UIReset extends BillingState {}

// -------- Error state -------- //
class BillingError extends BillingState {
  final String message;
  const BillingError({required this.message});

  @override
  List<Object> get props => [message];
}
