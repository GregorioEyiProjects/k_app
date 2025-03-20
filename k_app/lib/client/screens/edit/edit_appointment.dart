import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart';
import 'package:k_app/global.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EditAppointment extends StatefulWidget {
  final Appointment? appointment;
  final Billing? billing;
  final String? comingFrom;

  const EditAppointment(
      {super.key, this.appointment, this.billing, this.comingFrom});

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  // Variables with the values coming from the other screen
  TextEditingController? textEditorController = TextEditingController();
  TextEditingController? amountController = TextEditingController();
  int? billingID;
  int? appointmentID;
  String? oldCustomerName;
  String? oldPlace;
  DateTime? oldDate;
  TimeOfDay? oldTime;
  double? oldAmount;

  //New variables
  String? newCustomerName;
  String? newPlace;
  DateTime? newDate;
  TimeOfDay? newTime;
  double? newAmount;

  //Defailt values for the palces
  DateTime? now = DateTime.now();
  TimeOfDay nowTime = TimeOfDay.now();
  DateTime? selectedDate;
  final String nightMarket = "Night Market";
  final String nawamim = "Nawamim";
  bool isReadyToSave = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.billing != null) {
      //Fetch the data
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint(
            "Appointment ID on the EditAppointment screen: ${widget.billing?.id}");
        debugPrint("Coming from: ${widget.comingFrom}");

        // Fill up the the fields
        setState(() {
          textEditorController!.text = widget.billing!.customerName;
          billingID = widget.billing!.id;
          appointmentID = widget.billing!.appointmentID;
          oldCustomerName = widget.billing!.customerName;
          oldDate = widget.billing!.appointmentDate;
          oldTime = Billing.stringToTimeOfDay(widget.billing!.appointmentTime);
          oldPlace = widget.billing!.establismentName;
          debugPrint("TextEditorController: ${textEditorController!.text}");
          debugPrint("Date: $oldDate");
          debugPrint("Time: $oldTime");
        });

        if (widget.comingFrom == "billing") {
          oldAmount = widget.billing!.amount;
          debugPrint("Amount: $oldAmount");
        }
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    //get the size of the screen
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Edit Appointment",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: marginleft, right: marginRigth, top: 25),
        child: SingleChildScrollView(
          child: Container(
            //width: size.width * 0.9,
            width: double.infinity,
            //height: size.height * 0.62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: Colors.blueAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(100),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  //Just a text
                  Text(
                    "Enter the new details",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Space
                  SizedBox(height: 20),

                  //Text field for the customer name
                  TextField(
                    controller: textEditorController,
                    decoration: InputDecoration(
                      /*  helperStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ), */
                      hintText: textEditorController!.text,
                      /**/ hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: "Customer Name",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          newCustomerName = oldCustomerName;
                          isReadyToSave = false;
                        });
                        return;
                      } else {
                        setState(() {
                          newCustomerName = value;
                          print("New customer name: $newCustomerName");
                          isReadyToSave = true;
                        });
                      }
                    },
                    onEditingComplete: () {
                      print("Editing complete");
                      //Close the keyboard
                      FocusScope.of(context).unfocus();
                    },
                  ),

                  //Space
                  SizedBox(height: 20),

                  //Place container
                  Text(
                    "Select the new place",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Space
                  SizedBox(height: 10),

                  //Row with the places
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              oldPlace = nightMarket; //to update the UI
                              newPlace =
                                  nightMarket; //to update the new value to be saved
                              isReadyToSave = true; //to enable the save button
                            });
                          },
                          child: _placeContainer(nightMarket)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              oldPlace = nawamim; //to update the UI
                              newPlace =
                                  nawamim; //to update the new value to be saved
                              isReadyToSave = true; //to enable the save button
                            });
                          },
                          child: _placeContainer(nawamim)),
                    ],
                  ),

                  //Space
                  SizedBox(height: 25),

                  //Text
                  Text(
                    "Tap to change the date",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Space
                  SizedBox(height: 10),

                  //Calendar
                  GestureDetector(
                    onTap: () {
                      _showCalendar(context, oldDate!);

                      setState(() {
                        isReadyToSave = true; //to enable the save button
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Text(
                        oldDate == null
                            ? "Select the date"
                            : formatDate(oldDate!.toLocal()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //Space
                  SizedBox(height: 20),

                  //Text
                  Text(
                    "Tap to change the time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Space
                  SizedBox(height: 10),

                  //Date picker
                  GestureDetector(
                    onTap: () async {
                      _showTimePicker(context, oldTime!);

                      setState(() {
                        isReadyToSave = true; //to enable the save button
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Text(
                        oldTime == null
                            ? "Select the time"
                            : Billing.timeOfDayToString(oldTime!),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //Space
                  SizedBox(height: 20),

                  widget.comingFrom == "billing"
                      ? _amounAndButton(appProvider, size, context)
                      : _justButton(appProvider),

                  //Amount
                  // _justButton(),

                  //Amount and save button

                  //_amounAndButton(size, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _justButton(AppProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Text
        _saveButton(provider, horizontalPadding: 100, verticalPadding: 13),
      ],
    );
  }

  Column _amounAndButton(
      AppProvider provider, Size size, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter the new amount",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),

        //Space
        SizedBox(height: 10),

        //Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Text
            SizedBox(
              width: size.width * 0.4,
              height: 50,
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                  //FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  hintText: "${oldAmount.toString()} THB",
                  labelText: "${oldAmount.toString()} THB",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      newAmount = oldAmount;
                      isReadyToSave = false;
                    });
                    return;
                  } else {
                    setState(() {
                      newAmount = double.parse(value);

                      isReadyToSave = true; //to enable the save button
                    });
                  }
                },
                onEditingComplete: () {
                  print("Editing complete");
                  //Close the keyboard
                  FocusScope.of(context).unfocus();
                },
              ),
            ),

            //Save button
            _saveButton(provider),
          ],
        ),
      ],
    );
  }

  GestureDetector _saveButton(AppProvider provider,
      {double horizontalPadding = 20, double verticalPadding = 15}) {
    return GestureDetector(
      onTap: isReadyToSave
          ? () async {
              //Save the data

              final customerNameToSave = newCustomerName ?? oldCustomerName;
              final placeToSave = newPlace ?? oldPlace;
              final dateToSave = newDate ?? oldDate;
              final timeToSave = newTime ?? oldTime;
              final amountToSave = newAmount ?? oldAmount;

              /*  debugPrint("Place is $newPlace");
              debugPrint("Date is $newDate");
              debugPrint("Time is $newTime");
              debugPrint("Amount is $newAmount");

              debugPrint("customer Name To Save $customerNameToSave");
              debugPrint("customer Place To Save $placeToSave");
              debugPrint("customer date To Save $dateToSave");
              debugPrint("customer time To Save $timeToSave");
              debugPrint("customer amount To Save $amountToSave");*/

              //Check if the new values are not null
              if (isReadyToSave) {
                debugPrint("Is ready to save");
                //debugPrint("Billing ID: $billingID");

                Billing billing = Billing(
                  id: billingID,
                  appointmentID: appointmentID!,
                  customerName: customerNameToSave!,
                  appointmentDate: dateToSave!,
                  appointmentTime: Billing.timeOfDayToString(timeToSave!),
                  amount: amountToSave!,
                  establismentName: placeToSave!,
                );
                debugPrint("Billing: ${billing.toPrint()}");

                //Save the billing
                Billing? billingSave =
                    await provider.updateBillingTo(billingID!, billing);
                debugPrint("Billing save: ${billingSave!.toPrint()}");

                if (billingSave.id == null) {
                  debugPrint("Billing not saved");
                  //Show a snackbar
                  CustomSnackBar.show(
                    context,
                    title: "Error",
                    message: "Billing was not saved",
                    backgroundColor: Colors.red,
                    contentType: ContentType.failure,
                  );
                  return;
                }

                //Show a snackbar for success
                CustomSnackBar.show(
                  context,
                  title: "Success",
                  message: "Billing updated successfully",
                  //backgroundColor: Colors.green,
                  contentType: ContentType.success,
                );

                Future.delayed(Duration(seconds: 1), () {
                  //Navigate back
                  navigatorKey.currentState!.pop();
                });

                return;
              }

              print("Saving the data");
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isReadyToSave ? Colors.blue : Colors.grey,
        ),
        child: Text(
          "Save",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container _placeContainer(String placeComing) {
    //Night Market
    //Nawamim
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: oldPlace == placeComing
            ? Border.all(color: Colors.black, width: 1)
            : Border.all(color: Colors.grey, width: 1),
      ),
      child: Text(
        placeComing,
        //textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: oldPlace == placeComing ? Colors.black : Colors.grey,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCalendar(BuildContext context, DateTime previousDate) {
    debugPrint("Today is is $now");
    debugPrint("Previous time is $previousDate");

    //Show a dialog on a Dialog
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Close the dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: Icon(Icons.close)),
                    ),
                  ],
                ),
                TableCalendar(
                  focusedDay: now!,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(day, previousDate);
                  },
                  onDaySelected: (selectedDate, focusedDay) {
                    setState(() {
                      oldDate = selectedDate;
                      newDate = selectedDate;
                      print("New date is: $newDate");
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showTimePicker(BuildContext context, TimeOfDay previousTime) async {
    final timePicked =
        await showTimePicker(context: context, initialTime: previousTime);

    if (timePicked != null) {
      setState(() {
        oldTime = timePicked;
        newTime = timePicked;
        print("New time is: $newTime");
      });
    }
  }
}
