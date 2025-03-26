import 'dart:io';

import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/client/screen-components/billing/snackBar/customSnackBar.dart'
    show CustomSnackBar;
import 'package:k_app/client/screen-components/home/v2/customButton.dart';

import 'package:k_app/global.dart';
import 'package:k_app/server/models/billing-model.dart';
//import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';

class BillingList extends StatefulWidget {
  final List<Billing> billingList;
  const BillingList({super.key, required this.billingList});

  @override
  State<BillingList> createState() => _BillingListState();
}

class _BillingListState extends State<BillingList> {
  Offset _offset = Offset.zero;

  void _onTapDown(TapDownDetails tapPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    _offset = box.globalToLocal(tapPosition.globalPosition);
    print("Position: $_offset");
  }

  void _onLongPress(
    constext,
    Billing? billing,
  ) async {
    RenderObject? overlay = Overlay.of(context).context.findRenderObject();
/* 
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_offset.dx, _offset.dy, 10, 10),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          value: "Edit",
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Edit",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: "Delete",
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Delete",
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
    );
 */

    final result = await showMenu(
      context: context,
      menuPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      //clipBehavior: Clip.none,
      elevation: 2,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_offset.dx, _offset.dy, 10, 10),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          enabled: false, // Disable the default PopupMenuItem behavior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pick one",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, "Delete");
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, "Edit");
                    },
                    child: Container(
                      width: 65,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Edit",
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
              ),
            ],
          ),
        ),
      ],
    );

    switch (result) {
      case "Edit":
        debugPrint("Edit on id ${billing!.id}");
        navigatorKey.currentState?.pushNamed('editAppointment', arguments: {
          'appointment': null,
          'billingList': billing,
          'comingFrom': 'billing',
        });
        break;
      case "Delete":
        debugPrint("Delete on id ${billing!.id}");
        //Show a warning dialog
        _showDeleteDialog(billing.id!);
        break;
      default:
        debugPrint("Default");
        break;
    }
  }

  Future<dynamic> _showDeleteDialog(int id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text("Are you sure you want to delete this billing?"),
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
                  onPressed: () async {
                    debugPrint("Delete on id .... $id");
                    // bool wasItRemove = await appProvider.deleteBilling(id);
                    bool wasItRemove = true;
                    if (wasItRemove) {
                      //Show a snackbar
                      CustomSnackBar.show(
                        context,
                        title: "Success",
                        message: "Billing was delete",
                      );
                    } /* else {
                        //Show a snackbar
                        CustomSnackBar.show(
                          context,
                          title: "Error",
                          message: "Billing was not saved",
                        );
                      } */
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

  @override
  Widget build(BuildContext context) {
    //final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    debugPrint(
        "BillingList length in the BillingList : ${widget.billingList.length}");
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.billingList.length,
      itemBuilder: (context, index) {
        Billing billing = widget.billingList[index];
        //print("Billing appointmentDate: ${billing.appointmentDate}");
        //print("Billing name: ${billing.customerName}");
        //print("Billing amount: ${billing.amount}");
        return Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: GestureDetector(
            onTapDown: (position) {
              //Get the details of the tap

              _onTapDown(position);
            },
            onLongPress: () {
              //final int? id = billing.id;

              //Billing object
              //Billing billing = widget.billingList[index];
              _onLongPress(context, billing);
            },
            child: _listContainer(billing, context),
          ),
        );
      },
    );
  }

  Container _listContainer(Billing billing, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.greyColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "🧑🏻 ${billing.customerName}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                //Establish the Name

                //Icon(Icons.arrow_forward_ios),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${billing.amount} THB",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      billing.establismentName ?? "No Establishment",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              color: AppColors.greyColor,
              thickness: 1,
            ),
            //Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📅",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      formatDate(billing.appointmentDate.toLocal()),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                // Right Column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🕞",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      Billing.stringToTimeOfDay(billing.appointmentTime)
                          .format(context),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
