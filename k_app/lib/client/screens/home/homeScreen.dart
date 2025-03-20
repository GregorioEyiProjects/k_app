import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/home/v2/customBottomNav.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/screen-components/home/v2/customCalendar.dart';
import 'package:k_app/client/screen-components/home/v2/customEventList.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:k_app/server/provider/app_provider.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filterValue = 'All';

    //Fetch the data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AppProvider>(context, listen: false).fetchEvents();
    });
    //get the data
    //listOfEvents = Provider.of<AppProvider>(context, listen: false).listOfEvents
    //print("Here is the list coming from the provider ${listOfEvents.toString()}");
  }

  void filterAppointmentsByEstablishmentName(List<Appointment> listOfEvents) {
    final result = listOfEvents
        .where((item) => item.establishmentName == filterValue)
        .toList();

    if (filterValue == 'All') {
      setState(() {
        listOfEventsToUse = listOfEvents.reversed.toList();
      });
      return;
    }

    //setState(() {});
    listOfEventsToUse = result.reversed.toList();
    print("Here is the filtered value ${listOfEventsToUse!.length}");
    print("Here is the filtered list ${listOfEventsToUse.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          listOfEvents = appProvider.listOfEvents;

          // Update listOfEventsToUse whenever listOfEvents changes
          if (filterValue == 'All') {
            listOfEventsToUse = listOfEvents?.reversed.toList() ?? [];
          } else {
            filterAppointmentsByEstablishmentName(listOfEvents!);
          }
          //listOfEventsToUse ??= listOfEvents?.reversed.toList() ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.only(left: marginleft, right: marginRigth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Calendar
                CustomCalendar(),
                //SizedBox(height: 5),
                // Events title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Appointments 📅',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    //Filter
                    _filterSection(),
                  ],
                ),
                //SizedBox(height: 5),
                // Events list
                listOfEvents!.isEmpty
                    ? defaultContainer()
                    : CustomEventlist(
                        events: listOfEventsToUse!, appProvider: appProvider),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(page: 0),
    );
  }

  DropdownButton<int> _filterSection() {
    return DropdownButton(
      hint: filterValue == null
          ? Text(
              'Filter',
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
            //print('Today');
            setState(() {
              filterValue = 'All';
              //appProvider.filterEvents('Nawamim');
            });
            break;
          case 2:
            //print('Yesterday');
            setState(() {
              filterValue = 'Nawamim';
              //appProvider.filterEvents('Night Market');
            });
            break;
          case 3:
            //print('Yesterday');
            setState(() {
              filterValue = 'Night Market';
              //appProvider.filterEvents('Night Market');
            });
            break;
        }

        filterAppointmentsByEstablishmentName(listOfEvents!);

        // filterAppointmentsByEstablishmentName(listOfEvents!);
      },
    );
  }

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
