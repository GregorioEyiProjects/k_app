import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/filter/filterSection.dart';
import 'package:k_app/client/screen-components/billing/listContainers/billingList.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart';
import 'package:k_app/client/screen-components/billing/totalEarnings/totalEarnings.dart';
//import 'package:k_app/client/screen-components/home/v2/customBottomNav.dart';
import 'package:k_app/global.dart';
//import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
//import 'dart:math';
import 'package:k_app/server/database/bloc/billing_bloc.dart';
import 'package:k_app/server/database/bloc/events/billing_events.dart';
import 'package:k_app/server/database/bloc/states/billing_state.dart';
//import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:provider/provider.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late BillingBloc billingBloc;
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

    //Fetch the data (with Bloc) so it can stop using the initial state
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<BillingBloc>().add(FetchBillings());
      //context.read<BillingBloc>().add(FetchCurrentDayAndMonthBillings());
    });
  }

  void getTheTotalAmountForEachEstablisment(List<Billing> billingList) {
    //Get the total amount for each establishment

    totalNawamimAmount = billingList
        .where((item) => item.establismentName == 'Nawamim')
        .map((item) => item.amount)
        .fold(0.0, (value, item) => value! + item);

    debugPrint("Total Nawamim Amount: $totalNawamimAmount");

    totalNightMarketAmount = billingList
        .where((item) => item.establismentName == 'Night Market')
        .map((item) => item.amount)
        .fold(0.0, (value, item) => value! + item);

    debugPrint("Total Night Market Amount: $totalNightMarketAmount");
  }

  /*
    NOTE:
    This line "billingListToUse ??= billingList?.reversed.toList() ?? [];" allows me tho avoid the rebuilding the entire widget tree whenever the 
    AppProvider notifies listeners, which causes the billingList and billingListToUse to be reset
      to the full list of items and i could not assign the new list to new billingListToUse list.
  */

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    billingBloc = context.read<BillingBloc>();
  }

  @override
  void dispose() {
    //billingBloc.add(FetchBillings());
    //debugPrint("Resetting BillingBloc state to default");
    super.dispose();
  }

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
      body: BlocConsumer<BillingBloc, BillingState>(
        builder: (context, state) {
          if (state is BillingInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FetchBillingLoaded) {
            debugPrint("state is FetchBillingLoaded in BillingScreen");

            billingList = state.billingsLoaded;
            billingListToUse = billingList?.reversed.toList() ?? [];
            //Get the total amount for each establishment
            getTheTotalAmountForEachEstablisment(billingList!);

            return _billingScreenContent(context, state);
          }
          if (state is FilterCurrentMonthBillingsLoaded) {
            debugPrint(
                "state is FilterCurrentMonthBillingsLoaded in BillingScreen");

            //debugPrint("FilterCurrentMonthBillingsLoaded in Builder");
            billingList = state.originalCachedBillings;
            billingListToUse = billingList?.reversed.toList() ?? [];
            getTheTotalAmountForEachEstablisment(billingList!);

            return _billingScreenContent(context, state);
          }
          if (state is FetchBillingsByEstablishmentAndMonthLoaded) {
            debugPrint(
                "state is FilterCurrentMonthBillingsLoaded in BillingScreen");

            billingList = state.billingsFound;
            billingListToUse = billingList?.reversed.toList() ?? [];
            getTheTotalAmountForEachEstablisment(billingList!);

            return _billingScreenContent(context, state);
          }
          if (state is BillingsByDayLoaded) {
            debugPrint("BillingsByDayLoaded in BillingScreen");
            billingList = state.billingsFound;
            billingListToUse = billingList?.reversed.toList() ?? [];
            debugPrint(
                "Amount of items in the BillingsByDayLoaded >>>  ${billingListToUse!.length}");
            getTheTotalAmountForEachEstablisment(billingList!);

            return _billingScreenContent(context, state);
          } else {
            debugPrint("No STATE FOUND in BillingScreen");
            return Center(
              child: Text(
                "No data krup 😊!",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
        listener: (context, state) {},
      ),
    );
  }

//Billing Screen Content
  SingleChildScrollView _billingScreenContent(
    BuildContext context,
    state,
  ) {
    final billingBlocProvider = context.read<BillingBloc>();
    //final billingProvider = Provider.of<BillingBloc>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: marginleft, right: marginRigth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          //Total earnings
          TotalEarnings(),
          SizedBox(height: 5),
          Divider(
            color: AppColors.greyColor,
            thickness: 1,
          ),
          SizedBox(height: 10),
          Text(
            state.selectedDateText + ' ☀️',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),

          //Filter and see all items
          _filterAndSeeAllSection(
            context,
            billingBlocProvider,
            state.selectedDateText,
          ),

          // Billing list
          billingList!.isEmpty
              ? _defaultBillingContainer()
              : _customBillingList(
                  billingListToUse ?? [],
                ),

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
              : _establisments(context),
        ],
      ),
    );
  }

// See all Items and Filter them
  Row _filterAndSeeAllSection(
    BuildContext context,
    BillingBloc billingBloc,
    String selectedDateText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Filter section
        FilterSection(
          isFilteredFromThePreviousScreen: false,
          hintText: selectedDateText,
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

            debugPrint("Start Date: $startDate");
            debugPrint("End Date: $endDate");

            //Get the items by date
            billingBloc.add(
              FetchBillingsByDay(
                startDate: startDate,
                endDate: endDate,
              ),
            );
          },
        ),

        //See all items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                //billingBloc.add(FetchBillings());
                debugPrint(
                    "Navigate to the see all billing screen with the billingListToUse length: ${billingListToUse?.length}");
                final args = {
                  'filterName': "All",
                  "isFilteredFromThePreviousScreen": false,
                  "alllBillingListForThisMonth": billingListToUse ?? [],
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
                debugPrint(
                    "Navigate to the see all billing screen with the billingListToUse length: ${billingListToUse?.length}");
                final args = {
                  'filterName': "All",
                  "isFilteredFromThePreviousScreen": false,
                  "alllBillingListForThisMonth": billingListToUse ?? [],
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
  Container _customBillingList(myReversedBillingList) {
    debugPrint(
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

//Earnings - Establisments
  Row _establisments(BuildContext context) {
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
