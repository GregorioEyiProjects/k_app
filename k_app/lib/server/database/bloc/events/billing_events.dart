import 'package:equatable/equatable.dart';
import 'package:k_app/server/models/billing-model.dart';

abstract class BillingEvents extends Equatable {
  const BillingEvents();

  @override
  List<Object> get props => [];
}

//Fetch or load the billings
class FetchBillings extends BillingEvents {}

//Update a billing.
class UpdateBilling extends BillingEvents {
  final int billingId;
  final Billing billing;
  const UpdateBilling({required this.billing, required this.billingId});

  @override
  List<Object> get props => [billingId, billing];
}

//Delete a billing.
class DeleteBilling extends BillingEvents {
  final int billingId;
  const DeleteBilling({required this.billingId});

  @override
  List<Object> get props => [billingId];
}

//Filter the billings by establishment name.
class FetchBillingsByEstablishmentAndMonth extends BillingEvents {
  final String stablismentName;
  final String filterValue;

  const FetchBillingsByEstablishmentAndMonth({
    required this.stablismentName,
    required this.filterValue,
  });

  @override
  List<Object> get props => [stablismentName, filterValue];
}

//Filter this month billings and display the total amount.
class FetchCurrentDayAndMonthBillings extends BillingEvents {
  /* final double totalEarningsPerMonthOrTotal;
  final double totalEarningsPerDay; */

  const FetchCurrentDayAndMonthBillings();

  @override
  List<Object> get props => [];
}

//Filter the billings created within a day and display the total amount.
class FetchBillingsByDay extends BillingEvents {
  final DateTime startDate;
  final DateTime endDate;

  const FetchBillingsByDay({
    required this.startDate,
    required this.endDate,
  });
}

//Get default filter text value
class UpdateDateFilter extends BillingEvents {
  final String dateText;

  const UpdateDateFilter(this.dateText);

  @override
  List<Object> get props => [dateText];
}

//Reset the UI.
class ResetBillings extends BillingEvents {}
