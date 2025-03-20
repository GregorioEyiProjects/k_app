import 'package:flutter/material.dart';

//Global variables
double allMargin = 20;
double allTop = 20;
double marginleft = 20;
double marginRigth = 20;
double customVerticalMargin = 2;
double customHorizontallMargin = 5;

double marginLeftInTheBottomSheet = 20;
//-------- Base url --------
String baseURL = 'http://localhost:4000';

// -------- Global navigator key --------
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// -------- Based on the  user state --------
bool isLoggedIn = false;
bool isFirstTime = true;

// -------- Login variables --------
final usernameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final token = '';

// --------  Register variables --------
final registerUsernameController = TextEditingController();
final registerEmailController = TextEditingController();
final registerPasswordController = TextEditingController();

//-------- Home Screen variables --------

//  --------  Custom route --------
Route createRoute(
    Widget page, double beginFirstValue, double beginSecondValue) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = Offset(beginFirstValue,
          beginSecondValue); //  from the right (1.0, 0.0) to the left//// Form the left to the right (-1.0, 0.0)
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

// --------  Format date --------
//This one does the same as above
formatDate(DateTime selectedDate) {
  const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final String month = months[selectedDate.month - 1];
  return '$month ${selectedDate.day}';
}
