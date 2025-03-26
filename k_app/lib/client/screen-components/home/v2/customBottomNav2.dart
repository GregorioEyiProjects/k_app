import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/client/screens/billing/billingScreen.dart';
import 'package:k_app/client/screens/home/homeScreen.dart';
import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
import 'package:k_app/server/database/bloc/billing_bloc.dart';
import 'package:k_app/server/database/bloc/events/appointment_events.dart';
import 'package:k_app/server/database/bloc/events/billing_events.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CustomBottomNav2 extends StatefulWidget {
  const CustomBottomNav2({super.key});

  @override
  State<CustomBottomNav2> createState() => _CustomBottomNav2State();
}

class _CustomBottomNav2State extends State<CustomBottomNav2> {
  PersistentTabController? _controller;

//List of items in the bottom navigation bar
  final List<PersistentBottomNavBarItem> _navBarsItems = [
    PersistentBottomNavBarItem(
      contentPadding: 5.0,
      icon: const Icon(
        Icons.home,
      ),
      title: "Home",
      textStyle: TextStyle(
        color: Colors.black,
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      activeColorPrimary: Colors.blue,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.grey,
      /* routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/home": (final context) => HomeScreen(),
        },
      ), */
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.payment),
      title: ("Billing"),
      textStyle: TextStyle(
        color: Colors.black,
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      activeColorPrimary: Colors.blue,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.grey,
      /* routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/billing": (final context) => BillingScreen(),
        },
      ), */
    ),
  ];

//List of the screens to be displayed
  List<Widget> _buildScreens(BuildContext content) {
    final appointmentBloc =
        BlocProvider.of<AppointmentBloc>(context, listen: false);

    return [
      BlocProvider.value(
          value: appointmentBloc,
          child: HomeScreen(key: ValueKey("HomeScreen"))),
      BlocProvider.value(
          value: appointmentBloc,
          child: BillingScreen(key: ValueKey("BillingScreen"))),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller!,
      screens: _buildScreens(context),
      items: _navBarsItems,
      backgroundColor: Colors.white54,
      hideNavigationBarWhenKeyboardAppears: true,

      //lazyLoad: false, // Forces the screens to rebuild when switching tabs // IT DOESN'T WORK
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style10,
      onItemSelected: (index) {
        if (index == 0) {
          //context.read<AppointmentBloc>().add(ResetAppointments());
          context.read<AppointmentBloc>().add(FetchAppointments());
        } else if (index == 1) {
          // Reset the BillingBloc when navigating to the BillingScreen
          //context.read<BillingBloc>().add(ResetBillings());
          /**/
          context.read<BillingBloc>().add(FetchBillings());
          //context.read<BillingBloc>().add(FetchCurrentDayAndMonthBillings());
          //context.read<BillingBloc>().add(UpdateDateFilter("Filter"));
        }
      },
    );
  }
}
