import 'dart:math';

import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/filter/filterSection.dart';
import 'package:k_app/client/screen-components/billing/listContainers/billingList.dart';
import 'package:k_app/client/screen-components/billing/totalEarnings/totalEarnings.dart';
import 'package:k_app/client/screen-components/home/v2/customBottomNav.dart';
import 'package:k_app/global.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  String? defaultDateText;
  DateTime? dateToFilter;
  List<Billing>? billingList; // main list
  List<Billing>? billingListToUse; // reversed list
  Color? establishedmentColor;
  String? establishedmentName;
  double? totalNawamimAmount;
  double? totalNightMarketAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    defaultDateText = 'Today';
    establishedmentColor = AppColors.greyColor;

    //Get the total amount for each establishment
    //getTheTotalAmountForEachEstablisment(billingList!);
  }

  void getTheTotalAmountForEachEstablisment(List<Billing> billingList) {
    //Get the total amount for each establishment

    totalNawamimAmount = billingList
        .where((item) => item.establismentName == 'Nawamim')
        .map((item) => item.amount)
        .fold(0.0, (value, item) => value! + item);

    print("Total Nawamim Amount: $totalNawamimAmount");

    totalNightMarketAmount = billingList
        .where((item) => item.establismentName == 'Night Market')
        .map((item) => item.amount)
        .fold(0.0, (value, item) => value! + item);

    print("Total Night Market Amount: $totalNightMarketAmount");
  }

  /*
    NOTE:
    This line "billingListToUse ??= billingList?.reversed.toList() ?? [];" allows me tho avoid the rebuilding the entire widget tree whenever the 
    AppProvider notifies listeners, which causes the billingList and billingListToUse to be reset
      to the full list of items and i could not assign the new list to new billingListToUse list.
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                'Income 💵',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          billingList = appProvider.billingList;
          billingListToUse ??= billingList?.reversed.toList() ?? [];
          getTheTotalAmountForEachEstablisment(billingListToUse!);

          return SingleChildScrollView(
            padding: EdgeInsets.only(left: marginleft, right: marginRigth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),

                //Total earnings
                TotalEarnings(
                  billingList: billingListToUse ?? [],
                  provider: appProvider,
                ),
                SizedBox(height: 5),
                Divider(
                  color: AppColors.greyColor,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                Text(
                  '$defaultDateText ☀️',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),

                //Filter and see all items
                _filterAndSeeAllSection(context, billingList!, appProvider),

                // Billing list

                billingList!.isEmpty
                    ? _defaultBillingContainer()
                    : _customBillingList(billingListToUse ?? [], appProvider),

                SizedBox(height: 15),

                // Summarize the total amount of items
                Text(
                  'Earnings 💵',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),

                //Taps (NAWAMIM and NIGHT MARKET)
                billingList!.isEmpty
                    ? _defaultBillingContainer(text: "No earings yet krup!")
                    : _establisments(appProvider, context),
              ],
            ),
          );
        },
        child: Text('Billing Screen'),
      ),
      //bottomNavigationBar: CustomBottomNav(page: 1),
    );
  }

//Earnings - Establisments
  Row _establisments(AppProvider appProvider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //NAWAMIM
        GestureDetector(
          onTap: () {
            setState(() {
              establishedmentName = 'NAWAMIM';
            });

            final filterName = 'Nawamim';

            //Get the list of items for the selected establishment

            final listOfNawamimItems = billingList!
                .where((item) => item.establismentName == 'Nawamim')
                .toList();

            final args = {
              'billingList': listOfNawamimItems,
              'provider': appProvider,
              "filterName": filterName,
              "isFilteredFromThePreviousScreen": true,
            };
            navigatorKey.currentState?.pushNamed(
              '/seeAllBilling',
              arguments: args,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.36,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: establishedmentName == 'NAWAMIM'
                    ? AppColors.pinkAccent
                    : AppColors.greyColor,
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'NAWAMIM 🏢',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),

                SizedBox(height: 10),

                //Amount
                Text(
                  '$totalNawamimAmount THB',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),

        //NIGHT MARKET
        GestureDetector(
          onTap: () {
            setState(() {
              establishedmentName = 'NIGHT MARKET';
            });

            final filterName = 'Night Market';

            //Get the items for the selected establishment
            final listOfNightMarketItems = billingList!
                .where((item) => item.establismentName == 'Night Market')
                .toList();

            final args = {
              'billingList': listOfNightMarketItems,
              'provider': appProvider,
              "filterName": filterName,
              "isFilteredFromThePreviousScreen": true,
            };
            navigatorKey.currentState?.pushNamed(
              '/seeAllBilling',
              arguments: args,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: establishedmentName == 'NIGHT MARKET'
                    ? AppColors.pinkAccent
                    : AppColors.greyColor,
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'NIGHT MARKET 🏢',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),

                SizedBox(height: 10),

                //Amount
                Text(
                  '$totalNightMarketAmount THB',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// See all Items and Filter them
  Row _filterAndSeeAllSection(BuildContext context, List<Billing> myBillingList,
      AppProvider appProvider) {
    //return FilterAndSeeAll()

    print("Amount of items >>>  ${myBillingList.length}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Filter section
        FilterSection(
          isFilteredFromThePreviousScreen: false,
          onTapped: (value) async {
            setState(() {
              defaultDateText = value;
              //print("Value: $value");
            });

            DateTime now = DateTime.now();
            DateTime startDate;
            //DateTime endDate = now;
            DateTime endDate =
                DateTime(now.year, now.month, now.day, 23, 59, 59);
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
                startDate = DateTime(2000); // Default to a very early date
                print("Default: $startDate");
                break;
            }

            print("Start Date: $startDate");
            print("End Date: $endDate");

            //Get the items by date
            final appointmentsByDate =
                await appProvider.getBillingByDate(startDate, endDate);

            if (appointmentsByDate.reversed.toList().isEmpty) {
              billingListToUse = [];
            } else {
              //Update the list
              setState(() {
                //billingList = appointmentsByDate;
                billingListToUse = appointmentsByDate.reversed.toList();

                print("New amount of items  ${billingListToUse!.length}");
                print("billingListToUse  $billingListToUse");
              });
            }
          },
        ),

        //See all items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                //Navigate to the appointments screen
                //Navigate to the see all billing screen
                //navigatorKey.currentState?.pushNamed('/seeAllBilling', arguments: myBillingList, provider: appProvider);

                final args = {
                  'billingList': myBillingList,
                  'provider': appProvider,
                  'filterName': "All",
                  "isFilteredFromThePreviousScreen": false,
                };
                navigatorKey.currentState
                    ?.pushNamed('/seeAllBilling', arguments: args);
              },
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //Navigate to the see all billing screen
                final args = {
                  'billingList': myBillingList,
                  'provider': appProvider,
                  'filterName': "All",
                  "isFilteredFromThePreviousScreen": false,
                };
                navigatorKey.currentState
                    ?.pushNamed('/seeAllBilling', arguments: args);
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.blackColor,
                size: 16,
              ),
            )
          ],
        ),
      ],
    );
  }

  // Custom Billing List
  Container _customBillingList(myReversedBillingList, AppProvider appProvider) {
    print(
        "Amount of items in the _customBillingList >>>  ${myReversedBillingList.length}");
    const int maxItems = 3;

    // Reverse the list to display the last items first
    //List<Billing> reversedBillingList = myBillingList.reversed.toList();

    //Take the fist 3 items
    List<Billing> limitedBillingList =
        myReversedBillingList.take(maxItems).toList();

    return Container(
      height: 260,
      child: limitedBillingList.isEmpty
          ? _defaultBillingContainer(text: 'No income $defaultDateText')
          : BillingList(billingList: limitedBillingList),
    );
  }

  Widget _defaultBillingContainer({String? text = 'No income today'}) {
    return Center(
        child: Text(
      text!,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
    ));
  }
}
