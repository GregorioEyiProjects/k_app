import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/home/v2/customBottomNav.dart';
import 'package:k_app/client/screen-components/home/v2/customBottomNav2.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/screen-components/home/v2/customCalendar.dart';
import 'package:k_app/client/screen-components/home/v2/customEventList.dart';
import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
import 'package:k_app/server/database/bloc/events/appointment_events.dart';
import 'package:k_app/server/database/bloc/states/appointment_state.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
//import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<HomeScreen> {
  List<Appointment>? listOfEvents; //Main list of events
  List<Appointment>? listOfEventsToUse; //List use to filter the events
  String? filterValue;
  bool isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filterValue = 'All';

    //Fetch the data (with Bloc)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<AppointmentBloc>().add(FetchAppointments());
    });
  }

  void _toggleEvents(bool expand) {
    setState(() {
      isExpanded = expand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          //Check the states
          if (state is AppointmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AppointmentLoaded) {
            listOfEvents = state.appointments;
            return _homeScreenContent();
          } else if (state is AppointmentFiltered) {
            return _homeScreenContent();
          } else if (state is AppointmentError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Initial state',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }
        },
      ),
    );
  }

//Home screen content
  Widget _homeScreenContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    /*debugPrint("Screen height: $screenHeight");
    final screenWidth = MediaQuery.of(context).size.width;
    debugPrint("Screen width: $screenWidth");
    debugPrint("Screen height * 0.4 : ${screenHeight * 0.44}");
    debugPrint("Screen height * 0.8 : ${screenHeight * 0.8}"); */
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: marginleft, right: marginRigth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // /SizedBox(height: 20),
                // Calendar
                CustomCalendar(),
                //SizedBox(height: 5),
                // Events title
                //SizedBox(height: 20),
                // Filter section (dropdown)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Appointmentss 📅',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    //Filter
                    _filterSection(filterValue!),
                  ],
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: 0,
            right: 0,
            bottom: isExpanded ? 0 : -(screenHeight * 0.44),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                //debugPrint("${details.delta.dy}");
                debugPrint("${details.primaryDelta}");
                if (details.primaryDelta! < -10) {
                  debugPrint("Swipe up");
                  _toggleEvents(true); // Swipe up
                } else if (details.primaryDelta! > 10) {
                  debugPrint("Swipe down");
                  _toggleEvents(false); // Swipe down
                }
              },
              child: Container(
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: marginleft, right: marginRigth),
                  child: Column(
                    children: [
                      //Icon to swipe up and down
                      GestureDetector(
                        onTap: () {
                          _toggleEvents(!isExpanded);
                        },
                        child: Center(
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            size: 30,
                            color: AppColors.blackColor.withOpacity(0.6),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      // Events list
                      listOfEvents!.isEmpty
                          ? defaultContainer()
                          : Expanded(child: CustomEventlist()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Filter section (dropdown). Method inside the home screen content
  DropdownButton<int> _filterSection(String currentFilter) {
    return DropdownButton(
      hint: filterValue == null
          ? Text(
              currentFilter,
              style: TextStyle(
                color: AppColors.blackColor.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            )
          : Text(
              filterValue!,
              style: TextStyle(
                color: AppColors.blackColor.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
      items: [
        DropdownMenuItem(
          value: 1,
          child: Text(
            'All',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text(
            'Nawamim',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DropdownMenuItem(
          value: 3,
          child: Text(
            'Night Market',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      onChanged: (value) {
        print("Value: $value");
        switch (value) {
          case 1:
            setState(() {
              filterValue = 'All';
            });
            break;
          case 2:
            setState(() {
              filterValue = 'Nawamim';
            });
            break;
          case 3:
            setState(() {
              filterValue = 'Night Market';
            });
            break;
        }

        //Fetch the data (with Bloc)
        context
            .read<AppointmentBloc>()
            .add(FilterAppointmentsByEstablishmentName(filterValue!));
      },
    );
  }

//Default container. Method inside the home screen content as empty appointments
  Widget defaultContainer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Text(
          "No appoiments krup!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
