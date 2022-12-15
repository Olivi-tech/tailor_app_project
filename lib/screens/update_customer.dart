import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/provider/change_pwd_icon.dart';
import 'package:tailor_app/screens/model_classes/model_add_customer.dart';
import 'package:tailor_app/utils/widgets.dart';

import 'dashboard.dart';

class UpdateCustomer extends StatefulWidget {
  Map<String, dynamic>? map = {};
  bool? editing;

  UpdateCustomer({Key? key, this.map}) : super(key: key);

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  final GlobalKey<FormState> _formKeyMeasurement = GlobalKey<FormState>();
  // // ChangeIcon _changeIcon = ChangeIcon();
  // late bool _statusCompleted;

  ///adding customer info///
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  ///adding customer's Measurements ///
  late final TextEditingController _neckController;
  late final TextEditingController _shoulderController;
  late final TextEditingController _chestController;
  late final TextEditingController _waistController;
  late final TextEditingController _armLengthController;
  late final TextEditingController _bicepsController;
  late final TextEditingController _wristController;
  late final TextEditingController _lengthController;
  late final TextEditingController _thighController;
  late final TextEditingController _inseamController;
  late final TextEditingController _calfController;

  @override
  void initState() {
    /// customer ///
    _firstNameController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyFirstName]);

    _lastNameController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyLastName]);

    _phoneController = TextEditingController(
        text: widget.map![ModelAddCustomer.keyPhoneNumber]);
    _addressController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyAddress]);

    ///customer's Measurements ///
    _neckController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyNeck]);
    _shoulderController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyShoulder]);
    _chestController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyChest]);
    _waistController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyWaist]);
    _armLengthController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyArmLength]);
    _bicepsController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyBiceps]);
    _wristController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyWrist]);
    _lengthController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyLength]);
    _thighController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyThigh]);
    _inseamController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyInseam]);
    _calfController =
        TextEditingController(text: widget.map![ModelAddCustomer.keyCalf]);

    _firstNameController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    ///customer /////
    _firstNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    ///customer's Measurements /////
    _neckController.dispose();
    _shoulderController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _armLengthController.dispose();
    _bicepsController.dispose();
    _wristController.dispose();
    _lengthController.dispose();
    _thighController.dispose();
    _inseamController.dispose();
    _calfController.dispose();

    super.dispose();
  }

  late ModelAddCustomer _modelAddCustomer;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // _statusCompleted =
    //     Provider.of<ChangeIcon>(context, listen: false).isCompleted;
    User? currentUser = FirebaseAuth.instance.currentUser;
    final customerCollection =
        FirebaseFirestore.instance.collection(currentUser!.uid);
    //////////
    print(
        '${Provider.of<ChangeIcon>(context, listen: false).isCompleted} before');
    Future<void> updateCustomer() async {
      _modelAddCustomer = ModelAddCustomer(
          orderStatus:
              Provider.of<ChangeIcon>(context, listen: false).isCompleted
                  ? 'Completed'
                  : 'Active',
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          neck: _neckController.text,
          armLength: _armLengthController.text,
          biceps: _bicepsController.text,
          calf: _calfController.text,
          chest: _chestController.text,
          inseam: _inseamController.text,
          length: _lengthController.text,
          shoulder: _shoulderController.text,
          thigh: _thighController.text,
          waist: _waistController.text,
          wrist: _wristController.text);
      return await customerCollection
          .doc(_phoneController.text)
          .set(_modelAddCustomer.toMap());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer'),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: ElevatedButton(
              onPressed: () async {
                if (_firstNameController.text.isEmpty ||
                    _lastNameController.text.isEmpty ||
                    _phoneController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _phoneController.text.isEmpty
                          ? 'phone can\'t be empty'
                          : 'Name can\'t be empty');
                } else if (_addressController.text.isEmpty ||
                    _neckController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _addressController.text.isEmpty
                          ? 'Address is empty'
                          : 'Neck measurement is empty');
                } else if (_shoulderController.text.isEmpty ||
                    _chestController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _shoulderController.text.isEmpty
                          ? 'Shoulder measurement is empty'
                          : 'Chest measurement is empty');
                } else if (_waistController.text.isEmpty ||
                    _armLengthController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _waistController.text.isEmpty
                          ? 'Waist measurement is empty'
                          : 'Arm Length measurement is empty');
                } else if (_bicepsController.text.isEmpty ||
                    _wristController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _bicepsController.text.isEmpty
                          ? 'Biceps measurement is empty'
                          : 'Wrist measurement is empty');
                } else if (_lengthController.text.isEmpty ||
                    _thighController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _lengthController.text.isEmpty
                          ? 'Length measurement is empty'
                          : 'Thigh measurement is empty');
                } else if (_inseamController.text.isEmpty ||
                    _calfController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: _inseamController.text.isEmpty ||
                              _calfController.text.isEmpty
                          ? 'Inseam measurement is empty'
                          : 'Calf measurement is empty');
                } else {
                  print('update customer is called');
                  updateCustomer();

                  log('${Provider.of<ChangeIcon>(context, listen: false).isCompleted} after');
                  switch (await InternetConnectionChecker().hasConnection) {
                    case true:
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
                        desc: _phoneController.text ==
                                widget.map![ModelAddCustomer.keyPhoneNumber]
                            ? 'Updated ${_firstNameController.text} Successfully'
                            : 'Updated ${_firstNameController.text} Successfully.' +
                                ' ' +
                                'InCase you change phone number of customer, He/She will be added as new customer. you will need to delete customer with past number manually',
                        descTextStyle: const TextStyle(color: Colors.black),
                        btnOkOnPress: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: const DashBoard(),
                              ),
                              (route) => false);
                        },
                        btnOkIcon: Icons.check_circle,
                        onDismissCallback: (type) {
                          Navigator.pop(context);
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
                        title: 'Updated In Current Device',
                        desc:
                            'Note:Customer is not Updated to cloud. Provide internet to this device to sync and if you change device later',
                        descTextStyle: const TextStyle(color: Colors.black),
                        btnOkOnPress: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: const DashBoard(),
                              ),
                              (route) => false);
                        },
                      ).show();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xD2EA4A26),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  // fixedSize: Size(80, 5),
                  minimumSize: const Size(80, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: const Text('Update'),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Mark Order as Completed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      Consumer<ChangeIcon>(
                        builder: (BuildContext context, value, Widget? child) {
                          log('checkbox is rebuilt');
                          return Checkbox(
                            value: value.isCompleted,
                            onChanged: (boxValue) {
                              Provider.of<ChangeIcon>(context, listen: false)
                                  .isCompleted = boxValue!;
                              log('on tap ${value.isCompleted}');
                              value.isCompleted
                                  ? AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                      headerAnimationLoop: true,
                                      animType: AnimType.scale,
                                      title: 'Please Note That:',
                                      desc:
                                          'Order marked as completed will be moved from Home Page to Completed Orders Page ',
                                      descTextStyle:
                                          const TextStyle(color: Colors.black),
                                      btnOkOnPress: () {
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     PageTransition(
                                        //       type: PageTransitionType
                                        //           .leftToRight,
                                        //       child: const DashBoard(),
                                        //     ),
                                        //     (route) => false);
                                      },
                                    ).show()
                                  : SizedBox();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonWidgets.customTextFormField(
                    hintText: 'First Name',
                    controller: _firstNameController,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9]'))
                    ],
                    prefixIcon: const Icon(Icons.person_add_alt_outlined),
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidgets.customTextFormField(
                    hintText: 'Last Name',
                    controller: _lastNameController,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9]'))
                    ],
                    prefixIcon: const Icon(Icons.person_add_alt_outlined),
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidgets.customTextFormField(
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'Phone Number',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: const Icon(Icons.phone_enabled_outlined),
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidgets.customTextFormField(
                    textInputType: TextInputType.streetAddress,
                    hintText: 'Address',
                    controller: _addressController,
                    prefixIcon:
                        const Icon(Icons.maps_home_work_outlined, size: 20),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Dress Measurements:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
              Form(
                  key: _formKeyMeasurement,
                  child: Column(
                    children: [
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/NeckMeasurement-removebg-preview.png',
                        title: 'Neck',
                        list: CommonWidgets.generateList(11, 12),
                        controller: _neckController,
                        initialValue: _neckController.text,
                        onChanged: (String? value) => setState(() {
                          _neckController.text = value!;
                        }),

                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(height: 10),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/shoulder-removebg-preview.png',
                        title: 'Shoulder',
                        controller: _shoulderController,
                        initialValue: _shoulderController.text,
                        list: CommonWidgets.generateList(9, 13),
                        onChanged: (String? value) => setState(() {
                          _shoulderController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/chest-removebg-preview.png',
                        title: 'Chest',
                        controller: _chestController,
                        initialValue: _chestController.text,
                        list: CommonWidgets.generateList(31, 28),
                        onChanged: (String? value) => setState(() {
                          _chestController.text = value!;
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/waist__1_-removebg-preview.png',
                        controller: _waistController,
                        title: 'Waist',
                        initialValue: _waistController.text,
                        list: CommonWidgets.generateList(23, 25),
                        onChanged: (String? value) => setState(() {
                          _waistController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/arm_length-removebg-preview.png',
                        title: 'Arm Length',
                        controller: _armLengthController,
                        initialValue: _armLengthController.text,
                        list: CommonWidgets.generateList(12, 20),
                        onChanged: (String? value) => setState(() {
                          _armLengthController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/biceps-removebg-preview.png',
                        title: 'Biceps',
                        controller: _bicepsController,
                        initialValue: _bicepsController.text,
                        list: CommonWidgets.generateList(9, 9),
                        onChanged: (String? value) => setState(() {
                          _bicepsController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/wrist-removebg-preview.png',
                        title: 'Wrist',
                        controller: _wristController,
                        initialValue: _wristController.text,
                        list: CommonWidgets.generateList(5, 5),
                        onChanged: (String? value) => setState(() {
                          _wristController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage: 'assets/images/shirt_length1.png',
                        title: 'Length',
                        controller: _lengthController,
                        initialValue: _lengthController.text,
                        list: CommonWidgets.generateList(11, 20),
                        onChanged: (String? value) => setState(() {
                          _lengthController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage: 'assets/images/thigh.png',
                        title: 'Thigh',
                        controller: _thighController,
                        initialValue: _thighController.text,
                        list: CommonWidgets.generateList(15, 14),
                        onChanged: (String? value) => setState(() {
                          _thighController.text = value!;
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/inseam-removebg-preview.png',
                        title: 'Inseam',
                        controller: _inseamController,
                        initialValue: _inseamController.text,
                        list: CommonWidgets.generateList(18, 23),
                        onChanged: (String? value) => setState(() {
                          _inseamController.text = value!;
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage:
                            'assets/images/calf-removebg-preview.png',
                        title: 'Calf',
                        controller: _calfController,
                        initialValue: _calfController.text,
                        list: CommonWidgets.generateList(10, 11),
                        onChanged: (String? value) => setState(() {
                          _calfController.text = value!;
                        }),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
