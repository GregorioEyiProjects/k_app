import 'package:flutter/material.dart';
import 'package:k_app/client/screens/billing/billingScreen.dart';
import 'package:k_app/client/screens/billing/seeAllBilling.dart';
import 'package:k_app/client/screens/edit/edit_appointment.dart';
import 'package:k_app/client/screens/home/home.dart';
import 'package:k_app/client/screens/home/homeScreen.dart';
import 'package:k_app/client/screens/login/Login.dart';
import 'package:k_app/client/screens/register/Register.dart';
import 'package:k_app/client/screens/welcome.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:k_app/server/provider/app_provider.dart';

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
  switch (settings.name) {
    case '/welcome':
      return MaterialPageRoute(builder: (context) => const Welcome());
    case '/login':
      return MaterialPageRoute(builder: (context) => const Login());
    case '/register':
      return MaterialPageRoute(builder: (context) => const Register());
    case '/home':
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case '/billing':
      return MaterialPageRoute(builder: (context) => const BillingScreen());
    case 'editAppointment':

      //Get the arguments
      final args = settings.arguments as Map<String, dynamic>;

      //Get the appointment, the provider and the billing
      final Appointment? appointment = args['appointment'] as Appointment?;
      final Billing? billingList = args['billingList'] as Billing?;
      final String comingFrom = args['comingFrom'] as String;
      // final AppProvider provider = args['provider'] as AppProvider;

      return MaterialPageRoute(
        builder: (context) => EditAppointment(
          appointment: appointment,
          billing: billingList,
          comingFrom: comingFrom,
        ),
      );

    case '/seeAllBilling':
      final args = settings.arguments as Map<String, dynamic>;
      final billingList = args['billingList'] as List<Billing>;
      final AppProvider provider = args['provider'] as AppProvider;
      final String filterName = args['filterName'] as String;
      final bool isFilteredFromThePreviousScreen =
          args['isFilteredFromThePreviousScreen'] as bool;
      return MaterialPageRoute(
        builder: (context) => SeeAllBillling(
          billingList: billingList,
          provider: provider,
          filterName: filterName,
          isFilteredFromThePreviousScreen: isFilteredFromThePreviousScreen,
        ),
      );
    default:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
