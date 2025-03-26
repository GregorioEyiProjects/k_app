import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/filter/filterSection.dart';
import 'package:k_app/client/screen-components/billing/listContainers/billingList.dart';
import 'package:k_app/client/screen-components/billing/seeAllBillings/custom_cart.dart';
import 'package:k_app/global.dart';
import 'package:k_app/server/database/bloc/billing_bloc.dart';
import 'package:k_app/server/database/bloc/events/billing_events.dart';
import 'package:k_app/server/database/bloc/states/billing_state.dart';
import 'package:k_app/server/models/billing-model.dart';
//import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SeeAllBillling extends StatefulWidget {
  final String? filterName;
  final bool? isFilteredFromThePreviousScreen;
  final List<Billing>? billingListToDisplay;

  const SeeAllBillling({
    super.key,
    this.filterName,
    this.isFilteredFromThePreviousScreen,
    this.billingListToDisplay,
  });

  @override
  State<SeeAllBillling> createState() => _SeeAllBilllingState();
}

class _SeeAllBilllingState extends State<SeeAllBillling> {
  late BillingBloc billingBloc;
  //Variables
  String? appBarTitle;
  String? defaultDateText;
  // Reverse the list to display the last items first
  List<Billing>? reversedBillingList; //reversed list
  List<Billing>? billingList; //main list
  String? filterNameText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    appBarTitle = "All incomes";
    defaultDateText = "Today";

    if (widget.billingListToDisplay != null) {
      debugPrint("BillingListToDisplay IS NOT NULL");
      billingList = widget.billingListToDisplay!.reversed.toList();
      reversedBillingList = billingList!.reversed.toList();
    } else {
      debugPrint("BillingListToDisplay IS NULL");
      //Fetch the data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //context.read<BillingBloc>().add(FetchBillings());
        //debugPrint("Done Fetching billings");
      });

      setState(() {
        filterNameText = widget.filterName ?? "All";
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save the BillingBloc reference
    billingBloc = context.read<BillingBloc>();
  }

  @override
  void dispose() {
    // Reset the Bloc state to default when leaving the screen
    billingBloc.add(FetchBillings());
    debugPrint("Resetting BillingBloc state to default");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: kMinInteractiveDimension,
        /* title: Text(
          appBarTitle!,
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ), */
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<BillingBloc, BillingState>(
        builder: (context, state) {
          if (state is BillingLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FetchBillingLoaded) {
            if (widget.isFilteredFromThePreviousScreen == false) {
              debugPrint("State is BillingLoaded SeeAllBillling");
              billingList = state.billingsLoaded;
              reversedBillingList = billingList!.reversed.toList();
              filterNameText = widget.filterName ?? "All";
              debugPrint("BillingList lenght: ${billingList!.length}");
              return _seeAllContainer();
            }

            //ELSE ...
            return _seeAllContainer();
          } else if (state is BillingsByDayLoaded) {
            billingList = state.billingsFound;
            reversedBillingList = billingList!.reversed.toList();
            filterNameText = widget.filterName ?? "All";

            return _seeAllContainer();
          } else if (state is BillingError) {
            // Handle error state
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          } else {
            debugPrint("State is NOT BillingLoaded in SeeAllBillling");
            return defaultContainer();
          }
        },
        listener: (context, state) {},
      ),
    );
  }

  //billingList!.isEmpty ? defaultContainer() : _seeAllContainer(),

  Padding _seeAllContainer() {
    debugPrint("BillingList lenght: ${billingList!.length}");
    debugPrint("ReversedBillingList lenght: ${reversedBillingList!.length}");
    /**/ debugPrint(
        "widget.isFilteredFromThePreviousScreen : ${widget.isFilteredFromThePreviousScreen}");
    return Padding(
      padding: EdgeInsets.only(left: marginleft, right: marginRigth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Space
          //SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Weekly income",
                //textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),

          //Space
          SizedBox(height: 20),

          //Chart
          CustomChart(
            billingList: reversedBillingList ?? [],
          ),

          //Space
          SizedBox(width: 20),

          //Filter section
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Filter container
                _filterSection(),

                //Filter name
                Text(
                  filterNameText ?? "All",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),

          //List of billing
          Expanded(
            child: BillingList(
              billingList: reversedBillingList ?? [],
            ),
          )
        ],
      ),
    );
  }

  FilterSection _filterSection() {
    return FilterSection(
      isFilteredFromThePreviousScreen: widget.isFilteredFromThePreviousScreen,
      onTapped: (value) async {
        setState(() {
          defaultDateText = value;
          //debugPrint("Value: $value");
        });

        DateTime now = DateTime.now();
        DateTime startDate;
        DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        // DateTime endDate = now;
        //Filter the items
        switch (value) {
          case "Today":
            startDate = DateTime(
              now.year,
              now.month,
              now.day,
            );
            debugPrint("Today: ");
            break;
          case "Yesterday":
            startDate = DateTime(
              now.year,
              now.month,
              now.day - 1,
            );
            debugPrint("Yesterday: ");

            break;
          case "Last 7 days":
            startDate = DateTime(
              now.year,
              now.month,
              now.day - 7,
            );
            debugPrint("Last 7 days: ");
            //dateToFilter = "Last 7 days";
            break;
          case "Last 30 days":
            startDate = DateTime(
              now.year,
              now.month,
              now.day - 30,
            );
            debugPrint("Last 30 days: ");
            break;
          default:
            startDate = DateTime(2000); // Default to a very early date
            debugPrint("Default: $startDate");
            break;
        }

        // debugPrint("Start Date: $startDate");
        //debugPrint("End Date: $endDate");

        //Get the items from yesterday
        context.read<BillingBloc>().add(
              FetchBillingsByDay(
                startDate: startDate,
                endDate: endDate,
              ),
            );
      },
    );
  }

  Widget defaultContainer() {
    return Center(
      child: Text(
        "No billing data available",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
