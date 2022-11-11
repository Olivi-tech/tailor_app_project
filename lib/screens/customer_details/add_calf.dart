import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tailor_app/screens/customer_details/customer_personal_details.dart';
import 'package:tailor_app/screens/dashboard.dart';
import 'package:tailor_app/utils/widgets.dart';

class AddCalf extends StatefulWidget {
  const AddCalf({Key? key}) : super(key: key);

  @override
  State<AddCalf> createState() => _AddCalfState();
}

class _AddCalfState extends State<AddCalf> {
  String? value;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String collection = FirebaseAuth.instance.currentUser!.uid;
    return CommonWidgets.addCustomerDetails(
      context: context,
      list: CommonWidgets.generateList(10, 11),
      stringAssetImg: 'assets/images/calf-removebg-preview.png',
      name: 'Add Calf',
      value: value,
      onPressed: (String? value) {
        setState(() {
          this.value = value;
        });
      },
      nextOnPressed: () async {
        if (value == null || value!.isEmpty) {
          Fluttertoast.showToast(msg: 'Select Value');
        } else {
          CustomerPersonalDetails.modelAddCustomer.calf = value!;
          bool isAvailable = await InternetConnectionChecker().hasConnection;
          log('//////////internet isavailable = $isAvailable////////////');
          switch (isAvailable) {
            case true:
              await FirebaseFirestore.instance
                  .collection(collection)
                  .doc(CustomerPersonalDetails.modelAddCustomer.phoneNumber)
                  .set(CustomerPersonalDetails.modelAddCustomer.toMap());
              AwesomeDialog(
                width: width,
                context: context,
                animType: AnimType.scale,
                headerAnimationLoop: true,
                dialogType: DialogType.success,
                showCloseIcon: false,
                dismissOnTouchOutside: false,
                autoDismiss: false,
                title: 'Success',
                desc:
                    'Added ${CustomerPersonalDetails.modelAddCustomer.firstName}',
                descTextStyle: const TextStyle(color: Colors.black),
                btnOkOnPress: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashBoard(),
                      ),
                      (route) => false);
                },
                btnOkIcon: Icons.check_circle,
                onDismissCallback: (type) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashBoard(),
                      ),
                      (route) => false);
                },
              ).show();
              break;
            case false:
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                headerAnimationLoop: true,
                animType: AnimType.scale,
                title: 'Added In Current Device',
                desc:
                    'Note:Customer is not added to cloud. Provide internet to this device to sync and if you chnage device later',
                descTextStyle: const TextStyle(color: Colors.black),
                btnOkOnPress: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashBoard(),
                      ),
                      (route) => false);
                },
              ).show();
          }
        }
      },
    );
  }
}
