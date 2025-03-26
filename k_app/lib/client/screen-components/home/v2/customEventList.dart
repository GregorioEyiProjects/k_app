import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart';
import 'package:k_app/client/screen-components/home/v2/customButton.dart';
import 'package:k_app/client/screen-components/welcome/button.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/models/home/v2/event.dart';
import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
import 'package:k_app/server/database/bloc/events/appointment_events.dart';
import 'package:k_app/server/database/bloc/states/appointment_state.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:provider/provider.dart';
//import 'package:k_app/server/provider/app_provider.dart';

class CustomEventlist extends StatefulWidget {
  const CustomEventlist({super.key});

  @override
  State<CustomEventlist> createState() => _CustomEventlistState();
}

class _CustomEventlistState extends State<CustomEventlist> {
  final TextEditingController amountController = TextEditingController();
  double? amount;
  bool isReadyToSave = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    amount = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentBloc appointmentBloc = context.read<AppointmentBloc>();

    return BlocConsumer<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoaded) {
          //Get the list of appointments
          final List<Appointment> appointments =
              state.appointments.reversed.toList();

          return _listContainer(appointments, appointmentBloc);
        } else if (state is AppointmentFiltered) {
          final List<Appointment> appointmentsFiltered =
              state.filteredAppointments.reversed.toList();
          return _listContainer(appointmentsFiltered, appointmentBloc);
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
      listener: (context, state) {
        if (state is AppointmentDeleted) {
          if (state.isDeleted) {
            /* CustomSnackBar.show(
              context,
              title: 'Appointment',
              message: "Appointment deleted 🚮",
              contentType: ContentType.success,
            ); */
          } else {
            CustomSnackBar.show(
              context,
              title: 'Appointment',
              message: "Failed to delete appointment",
              contentType: ContentType.failure,
            );
          }
        } else if (state is AppointmentPaid) {
          CustomSnackBar.show(
            context,
            title: 'Appointment',
            message: "Appointment Paid ✅",
            contentType: ContentType.success,
          );
        }
      },
    );
  }

//List of appointments
  Container _listContainer(
      List<Appointment> appointments, AppointmentBloc appointmentBloc) {
    return Container(
      height: 300, // I need to come up with something better that this
      color: AppColors.backgroundColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          //Get the appointment
          Appointment appointment = appointments[index];

          //debugPrint("Here is the appointment name ${appointment.userName}");
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15, //
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Left side
                  _leftSide(appointment),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.11, // Adjust the height as needed
                    child: VerticalDivider(
                      color: AppColors.greyColor,
                      thickness: 2,
                    ),
                  ),
                  //Right side
                  _rightSide(context, appointment, appointmentBloc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

//Left side
  Column _leftSide(Appointment event) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Date",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          "${formatDate(event.appointmentDate.toLocal())}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Place",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          event.establishmentName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        )
      ],
    );
  }

//Right side
  Expanded _rightSide(
    BuildContext context,
    Appointment event,
    AppointmentBloc appointmemtBloc,
  ) {
    return Expanded(
      key: Key('appointmentInfo'),
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*   Text(
            "Customer",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ), */
          Text(
            event.userName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          RichText(
            key: Key('appointmentInfo'),
            text: TextSpan(
              text: 'at:  ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: Appointment.stringToTimeOfDay(event.appointmentTime)
                      .format(context),
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          //Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton2(
                //btnTitle: "Delete",
                textIcon: "🗑️",
                width: 5,
                height: 5,
                fontSize: 14,
                backgroungColor: AppColors.textColor.withOpacity(0.8),
                onPressed: () {
                  //Delete the appointment
                  _showDeleteAppointmentDialog(event, () {
                    print("Event ID ${event.id!}");
                    appointmemtBloc
                        .add(DeleteAppointment(appointmentId: event.id!));
                    //appProvider.deleteEventToObjexBox(event.id!);
                  });
                },
              ),
              CustomButton2(
                //btnTitle: "Done",
                textIcon: "💵",
                fontSize: 18,
                width: 5,
                height: 5,
                backgroungColor: AppColors.greenAccent.withOpacity(0.7),
                onPressed: () {
                  //Show payment dialog
                  _showPaymentDialog(
                    context,
                    event,
                    appointmemtBloc,
                    //appProvider,
                    /* () {
                      //Delete the appointment
                      appointmemtBloc
                          .add(DeleteAppointment(appointmentId: event.id!));
                      //appProvider.deleteEventToObjexBox(event.id!);
                    }, */
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

//_AppointmentInfo(event, context)
  Column _AppointmentInfo(Appointment event, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.userName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 10),
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: _appoimentInfo(event),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: _timeInfo(event, context),
            ),
          ],
        ),
      ],
    );
  }

  Row _appoimentInfo(Appointment event) {
    return Row(
      children: [
        //Icon(Icons.calendar_today, size: 16),
        Text("📅"),
        SizedBox(width: 5),
        Text(
          '${formatDate(event.appointmentDate.toLocal())}',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Row _timeInfo(Appointment event, BuildContext context) {
    return Row(
      children: [
        //Icon(Icons.access_time, size: 16),
        Text("🕔"),
        SizedBox(width: 5),
        Text(
          Appointment.stringToTimeOfDay(event.appointmentTime).format(context),
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

//Show payment dialog
  void _showPaymentDialog(
    BuildContext context,
    Appointment event,
    AppointmentBloc appointmemtBloc,
    //VoidCallback onDelete,
  ) {
    amountController.clear();
    amount = 0.0;
    String? defauflValue = 'Payment';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                "$amount THB",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Enter the amount
                  Text(
                    "Enter the amount",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  //Customer Ammount
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isReadyToSave = true;
                            amount = double.parse(value);
                          });
                        } else {
                          setState(() {
                            isReadyToSave = false;
                            amount = 0.0;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Amount",
                        border: InputBorder.none,
                        icon: Text(
                          "💵",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Space
                  SizedBox(width: 10),
                  Divider(
                    color: AppColors.greyColor,
                    thickness: 1,
                  ),

                  //Space
                  SizedBox(width: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Appointment details ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                            fontFamily: 'Poppins',
                          ),
                        ),

                        //Space
                        SizedBox(height: 10),

                        Text(
                          "🧑🏻: ${event.userName}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        //Amount
                        Text(
                          "💵 : ${amount ?? 0.0} THB",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Cancel button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    //Save button
                    GestureDetector(
                      onTap: isReadyToSave
                          ? () {
                              setState(
                                () {
                                  debugPrint("Amount: ${amount}");
                                  //Create a billing object
                                  Billing billing = Billing(
                                    appointmentID: event.id!,
                                    customerName: event.userName,
                                    appointmentDate: event.appointmentDate,
                                    appointmentTime: event.appointmentTime,
                                    amount: amount ?? 0.0,
                                    establismentName: event.establishmentName,
                                  );

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "คุณแน่ใจว่าต้องการชำระเงินนี้หรือไม่?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins",
                                            )),
                                        content: Text(
                                          "$amount THB",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        actions: [
                                          CustomButton2(
                                            btnTitle: "Cancel",
                                            //textIcon: "🗑️",
                                            width: 10,
                                            height: 10,
                                            fontSize: 16,
                                            backgroungColor: AppColors.textColor
                                                .withOpacity(0.7),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          CustomButton2(
                                            btnTitle: "Save",
                                            //textIcon: "💵",
                                            fontSize: 16,
                                            width: 10,
                                            height: 10,
                                            backgroungColor: AppColors
                                                .greenAccent
                                                .withOpacity(0.8),
                                            onPressed: () {
                                              //Make payment
                                              appointmemtBloc
                                                  .add(MakePayement(billing));
                                              // to exit the current dialog
                                              Navigator.of(context).pop();
                                              //to exit the previous dialog
                                              _onSavePressed(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              );

                              //Navigator.of(context).pop();
                            }
                          : null,
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isReadyToSave ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Save",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteAppointmentDialog(Appointment event, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Appointment",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Customer's name
              Text(
                "Are you sure you want to delete ${event.userName}'s appointment?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton2(
                  btnTitle: "Cancel",
                  //textIcon: "🗑️",
                  width: 10,
                  height: 10,
                  fontSize: 16,
                  backgroungColor: AppColors.greenAccent.withOpacity(0.7),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CustomButton2(
                  btnTitle: "Delete",
                  //textIcon: "💵",
                  fontSize: 16,
                  width: 10,
                  height: 10,
                  backgroungColor: AppColors.textColor.withOpacity(0.8),
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }
}

void _onSavePressed(BuildContext context) {
  Navigator.of(context).pop();
}
