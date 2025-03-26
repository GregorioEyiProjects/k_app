import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/client/screens/billing/billingScreen.dart';
import 'package:k_app/client/screens/billing/seeAllBilling.dart';
import 'package:k_app/client/screens/edit/edit_appointment.dart';
import 'package:k_app/client/screens/home/home.dart';
import 'package:k_app/client/screens/home/homeScreen.dart';
import 'package:k_app/client/screens/home/index_page.dart';
import 'package:k_app/client/screens/login/Login.dart';
import 'package:k_app/client/screens/register/Register.dart';
import 'package:k_app/client/screens/welcome.dart';
import 'package:k_app/main.dart';
import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
import 'package:k_app/server/database/bloc/billing_bloc.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
//import 'package:k_app/server/provider/app_provider.dart';

// -------- Router Map --------
Map<String, WidgetBuilder> routes = {
  '/welcome': (context) => const Welcome(),
  '/login': (context) => const Login(),
  '/register': (context) => const Register(),
  '/home': (context) => const HomeScreen(),
  '/billing': (context) => const BillingScreen(),
  '/seeAllBilling': (context) => const SeeAllBillling(),
};

// -------- Router dynamic--------
Route<dynamic> generateRoute(RouteSettings settings) {
  return MaterialPageRoute(builder: (context) {
    final appointmentBloc =
        BlocProvider.of<AppointmentBloc>(context, listen: false);
    final billingBloc = BlocProvider.of<BillingBloc>(context, listen: false);

    switch (settings.name) {
      case '/':
        return const IndexPage();
      case '/welcome':
        return const Welcome();
      case '/login':
        return const Login();
      case '/register':
        return const Register();
      case '/home':
        return BlocProvider.value(
          value: appointmentBloc,
          child: const HomeScreen(),
        );
      case '/billing':
        return BlocProvider.value(
          value: appointmentBloc,
          child: BillingScreen(),
        );
      case 'editAppointment':
        //Get the arguments
        final args = settings.arguments as Map<String, dynamic>;

        //Get the appointment, the provider and the billing
        final Appointment? appointment = args['appointment'] as Appointment?;
        final Billing? billingList = args['billingList'] as Billing?;
        final String comingFrom = args['comingFrom'] as String;
        // final AppProvider provider = args['provider'] as AppProvider;

        return BlocProvider.value(
          value: appointmentBloc,
          child: EditAppointment(
            appointment: appointment,
            billing: billingList,
            comingFrom: comingFrom,
          ),
        );

      case '/seeAllBilling':
        final args = settings.arguments as Map<String, dynamic>;
        final String filterName = args['filterName'] as String;
        final bool isFilteredFromThePreviousScreen =
            args['isFilteredFromThePreviousScreen'] as bool;
        final List<Billing>? billingListToDisplay =
            args['billingList'] as List<Billing>?;

        if (billingListToDisplay != null) {
          debugPrint("billingListToDisplay IS NOT null in /seeAllBilling");
          return BlocProvider.value(
            value: billingBloc,
            child: SeeAllBillling(
              filterName: filterName,
              isFilteredFromThePreviousScreen: isFilteredFromThePreviousScreen,
              billingListToDisplay: billingListToDisplay,
            ),
          );
        }

        //ELSE ...
        debugPrint("billingListToDisplay IS NULL in /seeAllBilling");
        return BlocProvider.value(
          value: billingBloc,
          child: SeeAllBillling(
            filterName: filterName,
            isFilteredFromThePreviousScreen: isFilteredFromThePreviousScreen,
          ),
        );
      default:
        return const HomeScreen();
    }
  });
  //
}
