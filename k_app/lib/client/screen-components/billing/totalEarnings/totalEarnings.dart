import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart';
import 'package:k_app/global.dart';
import 'package:k_app/server/database/bloc/billing_bloc.dart';
import 'package:k_app/server/database/bloc/events/billing_events.dart';
import 'package:k_app/server/database/bloc/states/billing_state.dart';
import 'package:k_app/server/models/billing-model.dart';
//import 'package:k_app/server/provider/app_provider.dart';

class TotalEarnings extends StatefulWidget {
  const TotalEarnings({super.key});

  @override
  State<TotalEarnings> createState() => _TotalEarningsState();
}

class _TotalEarningsState extends State<TotalEarnings> {
  double? totalEarningsPerMonthOrTotal;
  double? totalEarningsPerDay;
  String? establishmentName;
  String? monthSelected;
  String? totalBalanceText;

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    establishmentName = null;
    monthSelected = 'Select the month';
    totalBalanceText = "My total balance";
    totalEarningsPerMonthOrTotal = 0.0;
    totalEarningsPerDay = 0.0;
  }

//Update the total balance text (Used when the user filters the data)
  void _updateTotalBalanceTextAndFilterData(
      BillingBloc bloc, VoidCallback onComplete, ValueChanged onError) async {
    if (establishmentName == null && monthSelected == null) {
      onError("Establishment name  and  monthSelected is NOT selected");
      print("Establishment name  or  monthSelected is null");
      return;
    }

    if (establishmentName == null) {
      onError("Establishment name is empty");
      print("Establishmen is NOT selected!");
      return;
    }

    if (monthSelected == null || monthSelected == 'Select the month') {
      onError("Month is NOT selected!");
      //print("Month is no selected!");
      return;
    }

    setState(() {
      totalBalanceText = "$establishmentName earnings \non $monthSelected";
    });

    debugPrint("Here is the total balance text $monthSelected");
    debugPrint("Here is the establishment name $establishmentName");

    try {
      // Get the list of billings
      bloc.add(FetchBillingsByEstablishmentAndMonth(
        stablismentName: establishmentName!,
        filterValue: monthSelected!,
      ));
/* 
      final totalAmount = billingListResponse.fold(
          0.0, (previousValue, element) => previousValue + element.amount);
      print("Here is the total amount with fold $totalAmount"); */

/*       setState(() {
        totalEarningsPerMonthOrTotal = totalAmount;
      }); */

      debugPrint("Returning from filtering . . .");
      onComplete();
    } catch (e) {
      debugPrint("Error fetching billings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillingBloc, BillingState>(
      builder: (context, state) {
        if (state is FetchBillingLoaded) {
          debugPrint("BillingLoaded in TotalEarnings");
          totalEarningsPerMonthOrTotal = state.totalEarningsPerMonthOrTotal;
          totalEarningsPerDay = state.totalEarningsPerDay;
          return _totalEariningsContainer(context);
        } else if (state is FilterCurrentMonthBillingsLoaded) {
          debugPrint("FilterCurrentMonthBillingsLoaded in TotalEarnings");
          totalEarningsPerMonthOrTotal = state.totalEarningsPerMonthOrTotal;
          totalEarningsPerDay = state.totalEarningsPerDay;
          return _totalEariningsContainer(context);
        } else if (state is FetchBillingsByEstablishmentAndMonthLoaded) {
          debugPrint("BillingsByEstablishmentAndMonthLoaded in TotalEarnings");
          totalEarningsPerMonthOrTotal = state.totalEarningsPerMonthOrTotal;
          return _totalEariningsContainer(context);
        } else if (state is BillingsByDayLoaded) {
          debugPrint("BillingsByEstablishmentAndMonthLoaded in TotalEarnings");
          //totalEarningsPerMonthOrTotal = state.totalEarningsPerMonthOrTotal;

          //debugPrint("Here is the total amount $totalEarningsPerMonthOrTotal");
          //debugPrint("Here is the total amount $totalEarningsPerMonthOrTotal");

          return _totalEariningsContainer(context);
        } else if (state is BillingError) {
          return Center(
            child: Text("Error: ${state.message}"),
          );
        } else {
          return Center(
            child: Text("No data found (..)!"),
          );
        }
      },
    );
  }

//Total Earinings Containers
  Container _totalEariningsContainer(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade200.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //Above row
            _aboveRow(context),
            //Space
            const SizedBox(height: 20),
            //Below Component
            _bellowContent()
          ],
        ),
      ),
    );
  }

//Above row
  Row _aboveRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //Money icon
            Container(
              decoration: BoxDecoration(
                color: Colors.purpleAccent.shade100.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: customHorizontallMargin,
                    vertical: customVerticalMargin),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "💰",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ),

            //Space
            const SizedBox(width: 20),

            //Total earnings per month
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$totalEarningsPerMonthOrTotal THB",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
                Text(
                  totalBalanceText!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ],
        ),

        //Filter per month
        GestureDetector(
          onTap: () {
            establishmentName = null;
            monthSelected = 'Select the month';
            //Display the filter dialog
            _showModalBottomSheet(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purpleAccent.shade100.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: customHorizontallMargin,
                  vertical: customVerticalMargin),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "🔎",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

//Below content
  Column _bellowContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$totalEarningsPerDay THB",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
        Text(
          "Today total earnings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            fontFamily: "Poppins",
          ),
        )
      ],
    );
  }

  Future<dynamic> _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 300,
              width: double.infinity,
              child: Container(
                //height: 310,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: marginLeftInTheBottomSheet),
                            child: Text(
                              'Filter',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.close),
                              iconSize: 18,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //Select the place text
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Text(
                          'Select the place',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      //Place
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  establishmentName = "All";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: establishmentName == "All"
                                      ? Border.all(
                                          color: AppColors.lightBlueAccent,
                                          width: 1.5,
                                        )
                                      : Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: SizedBox(
                                  height: 40,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "All",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  establishmentName = "Nawamim";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: establishmentName == "Nawamim"
                                      ? Border.all(
                                          color: AppColors.lightBlueAccent,
                                          width: 1.5,
                                        )
                                      : Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: SizedBox(
                                  height: 40,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Nawamim",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  establishmentName = "Night Market";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: establishmentName == "Night Market"
                                      ? Border.all(
                                          color: AppColors.lightBlueAccent,
                                          width: 1.5,
                                        )
                                      : Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: SizedBox(
                                  height: 40,
                                  width: 79,
                                  child: Center(
                                    child: Text(
                                      "Night Market",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Space
                      SizedBox(height: 10),

                      //Select the Month text
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Text(
                          'Select the month',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      //Select the Month Dropdown
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Row(
                          children: [
                            //First month
                            Expanded(
                              child: Container(
                                //width: double.infinity / 2.5,
                                //color: AppColors.greyColor,
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(0.3),
                                  //border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 2.0),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                      monthSelected!,
                                      //textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: AppColors.blackColor
                                            .withOpacity(0.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    items: months.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          "$value 📆",
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        //monthSelected = value.toString();
                                        monthSelected = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Space
                      SizedBox(height: 10),

                      //Button to filter
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            final bloc = BlocProvider.of<BillingBloc>(context,
                                listen: false);

                            //Filter the data
                            _updateTotalBalanceTextAndFilterData(
                              bloc,
                              () {
                                Navigator.of(context).pop();
                              },
                              (value) {
                                Navigator.of(context).pop();
                                CustomSnackBar.show(context,
                                    title: "Something went wrong!",
                                    message: value,
                                    contentType: ContentType.failure);
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 35.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
