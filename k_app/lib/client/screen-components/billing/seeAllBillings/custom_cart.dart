import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/server/models/billing-model.dart';

class CustomChart extends StatefulWidget {
  final List<Billing>? billingList;
  const CustomChart({super.key, required this.billingList});

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  List<Billing>? billingListFilled;
  double totalAmount = 0; //
  double mondayAmount = 0;
  double tuesdayAmount = 0;
  double wednesdayAmount = 0;
  double thursdayAmount = 0;
  double fridayAmount = 0;
  double saturdayAmount = 0;
  double sundayAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.billingList != null) {
        debugPrint("What is the billing list: ${widget.billingList}");
        setState(() {
          billingListFilled = widget.billingList;
        });
        calculateTotalAmount(billingListFilled!);
      } else {
        setState(() {
          billingListFilled = [];
        });
        debugPrint("The billing list is null");
      }
    });
  }

  //Calculate the total amount
  void calculateTotalAmount(List<Billing> billingListFilled) {
    //Get the current date and Monday date
    //final DateTime now = DateTime.now();
    //final DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    //
    Map<int, double> weeklyAmounts = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
    };

    //
    for (var billing in billingListFilled) {
      final int weekday = billing.appointmentDate.weekday;
      debugPrint("What is the weekday: $weekday");

      if (weeklyAmounts.containsKey(weekday)) {
        weeklyAmounts[weekday] = weeklyAmounts[weekday]! + billing.amount;
      }
    }

    setState(() {
      mondayAmount = weeklyAmounts[1]!;
      tuesdayAmount = weeklyAmounts[2]!;
      wednesdayAmount = weeklyAmounts[3]!;
      thursdayAmount = weeklyAmounts[4]!;
      fridayAmount = weeklyAmounts[5]!;
      saturdayAmount = weeklyAmounts[6]!;
      sundayAmount = weeklyAmounts[7]!;

      /*  debugPrint("What is the total amount for mondayAmount: $mondayAmount");
      debugPrint("What is the total amount for tuesdayAmount: $tuesdayAmount");
      debugPrint(
          "What is the total amount for wednesdayAmount: $wednesdayAmount");
      debugPrint(
          "What is the total amount for thursdayAmount: $thursdayAmount");
      debugPrint("What is the total amount for fridayAmount: $fridayAmount");
      debugPrint(
          "What is the total amount for saturdayAmount: $saturdayAmount");
      debugPrint("What is the total amount for sundayAmount: $sundayAmount"); */
    });
  }

  //
  List<FlSpot> getSpots() {
    return [
      FlSpot(0, mondayAmount),
      FlSpot(1, tuesdayAmount),
      FlSpot(2, wednesdayAmount),
      FlSpot(3, thursdayAmount),
      FlSpot(4, fridayAmount),
      FlSpot(5, saturdayAmount),
      FlSpot(6, sundayAmount),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return billingListFilled != null
        ? _lineChartContent()
        : _defaultConatiner();
  }

//Line chart content
  AspectRatio _lineChartContent() {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            //show: false
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (double value, TitleMeta titleMeta) {
                  //debugPrint("What is the value: ${value.toInt()}");
                  return Text(
                    "${value.toInt()}",
                    //titleMeta.formattedValue,
                    //value.toString(),
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),

            topTitles: AxisTitles(
              axisNameSize: 20, //Not working
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            rightTitles: AxisTitles(
              axisNameWidget: Text(
                "Amount",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            bottomTitles: AxisTitles(
              //Not working
              axisNameWidget: Text(
                "Days of the week",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              axisNameSize: 20, //Not working
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta titleMeta) {
                  const weekdays = [
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun"
                  ];
                  return Text(
                    weekdays[value.toInt() % 7],
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: AppColors.textColor,
              width: 1,
            ),
          ),
          minY: 0,
          //maxY: 0,
          //clipData: FlClipData.all(),
          lineBarsData: [
            LineChartBarData(
              spots: getSpots(),
              //color: AppColors.pinkAccent,
              gradient: LinearGradient(
                colors: [
                  AppColors.pinkAccent,
                  AppColors.blueColor.withOpacity(0.3),
                ],
              ),
              barWidth: 5,
              isCurved: true,
              preventCurveOverShooting: true,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: AppColors.pinkAccent,
                    strokeWidth: 2,
                    strokeColor: AppColors.textColor,
                  );
                },
              ),
              //isStrokeJoinRound: true,

              aboveBarData: BarAreaData(
                show: true,
                color: AppColors.greenAccent.withOpacity(0.5),
              ),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.pinkAccent.withOpacity(0.5),
                    AppColors.blueColor.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Default container
  Widget _defaultConatiner() {
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(
          "Chart not available",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
