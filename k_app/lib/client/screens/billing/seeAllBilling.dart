import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/filter/filterSection.dart';
import 'package:k_app/client/screen-components/billing/listContainers/billingList.dart';
import 'package:k_app/global.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SeeAllBillling extends StatefulWidget {
  final List<Billing>? billingList;
  final AppProvider? provider;
  final String? filterName;
  final bool? isFilteredFromThePreviousScreen;

  const SeeAllBillling({
    super.key,
    this.billingList,
    this.provider,
    this.filterName,
    this.isFilteredFromThePreviousScreen,
  });

  @override
  State<SeeAllBillling> createState() => _SeeAllBilllingState();
}

class _SeeAllBilllingState extends State<SeeAllBillling> {
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

    if (widget.billingList != null) {
      //Fetch the data
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // await Provider.of<AppProvider>(context, listen: false).fetchEvents();
        //print("Billing List length: ${widget.billingList?.length}");
        setState(() {
          reversedBillingList = widget.billingList!.reversed.toList();
          filterNameText = widget.filterName ?? "All";
        });
      });
    } else {
      setState(() {
        reversedBillingList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    billingList = reversedBillingList ?? [];
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          appBarTitle!,
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: true,
      ),
      body: billingList!.isEmpty
          ? defaultContainer()
          : Padding(
              padding: EdgeInsets.only(left: marginleft, right: marginRigth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Filter
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterSection(
                          isFilteredFromThePreviousScreen:
                              widget.isFilteredFromThePreviousScreen,
                          onTapped: (value) async {
                            setState(() {
                              //defaultDateText = value;
                              //print("Value: $value");
                            });

                            DateTime now = DateTime.now();
                            DateTime startDate;
                            DateTime endDate = DateTime(
                                now.year, now.month, now.day, 23, 59, 59);
                            // DateTime endDate = now;
                            //Filter the items
                            switch (value) {
                              case "Today":
                                startDate = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                );
                                print("Today: ");
                                break;
                              case "Yesterday":
                                startDate = DateTime(
                                  now.year,
                                  now.month,
                                  now.day - 1,
                                );
                                print("Yesterday: ");

                                break;
                              case "Last 7 days":
                                startDate = DateTime(
                                  now.year,
                                  now.month,
                                  now.day - 7,
                                );
                                print("Last 7 days: ");
                                //dateToFilter = "Last 7 days";
                                break;
                              case "Last 30 days":
                                startDate = DateTime(
                                  now.year,
                                  now.month,
                                  now.day - 30,
                                );
                                print("Last 30 days: ");
                                break;
                              default:
                                startDate = DateTime(
                                    2000); // Default to a very early date
                                print("Default: $startDate");
                                break;
                            }

                            print("Start Date: $startDate");
                            print("End Date: $endDate");

                            //Get the items from yesterday
                            final appointmentsByDate = await widget.provider
                                ?.getBillingByDate(startDate, endDate);

                            //Update the list
                            setState(() {
                              reversedBillingList =
                                  appointmentsByDate?.reversed.toList();

                              print(
                                  "New amount of items in See All  ${reversedBillingList!.length}");
                              print("billingList See All $reversedBillingList");
                            });
                          },
                        ),

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
                      billingList: billingList!,
                    ),
                  )
                ],
              ),
            ),
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
