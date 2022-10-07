import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_app/screens/dashboard.dart';
import 'package:tailor_app/screens/model_add_customer.dart';
import 'package:tailor_app/utils/widgets.dart';

class UpdateCustomer extends StatefulWidget {
  Map<String, dynamic>? map = {};
  bool? editing;

  UpdateCustomer({Key? key, this.map}) : super(key: key);

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  //static String firstName = widget.map![ModelAddCustomer.keyArmLength];
  // final String title = widget.editing! ? 'Update Customer': 'Add Customer';
  final GlobalKey<FormState> _formKeyCustomer = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyMeasurement = GlobalKey<FormState>();

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
    // print(
    //     '////////empty=${_firstNameController.text.isEmpty}///////////////////');
    // print('//////empty=${_addressController.text.isEmpty}///////////////////');
    // print('/////empty=${_phoneController.text.isEmpty}///////////////////');
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

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final customerCollection =
        FirebaseFirestore.instance.collection(currentUser!.uid);
    Future<void> updateCustomer() async {
      var obj = ModelAddCustomer(
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
          .set(obj.toMap());
    }

    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer'),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: ElevatedButton(
              onPressed: () {
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
                  updateCustomer().whenComplete(() {
                    AwesomeDialog(
                      width: width,
                      context: context,
                      animType: AnimType.scale,
                      headerAnimationLoop: true,
                      dialogType: DialogType.success,
                      showCloseIcon: false,
                      dismissOnTouchOutside: false,
                      autoDismiss: false,
                      // autoHide: const Duration(seconds: 3),
                      title: 'Success',
                      desc: 'Updated ${_firstNameController.text}',
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
                        Navigator.pop(context);
                      },
                    ).show().onError((error, stackTrace) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        headerAnimationLoop: true,
                        dialogType: DialogType.error,
                        showCloseIcon: true,
                        autoDismiss: false,
                        autoHide: const Duration(seconds: 4),
                        title: 'Error',
                        desc: 'Error while adding. Check internet & try again',
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
                          Navigator.pop(context);
                        },
                      ).show();
                    });
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  //  primary: Colors.indigoAccent,
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
          //  reverse: true,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Info :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonWidgets.customTextFormField(
                    hintText: 'First Name',
                    controller: _firstNameController,
                    //  maxLength: 18,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9]'))
                    ],
                    prefixIcon: const Icon(Icons.person_add_alt_outlined),
                    // validator: (value) {
                    //   return CommonWidgets.customValidator('$value');
                    // }
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidgets.customTextFormField(
                    hintText: 'Last Name',
                    controller: _lastNameController,
                    //initialValue: widget.map![ModelAddCustomer.keyFirstName],
                    //  maxLength: 18,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9]'))
                    ],
                    prefixIcon: const Icon(Icons.person_add_alt_outlined),
                    // validator: (value) {
                    //   return CommonWidgets.customValidator('$value');
                    // }
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidgets.customTextFormField(
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'Phone Number',
                    //   maxLength: 13,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: const Icon(Icons.phone_enabled_outlined),
                    // validator: (value) {
                    //   return CommonWidgets.customValidator('$value');
                    // }
                  ),
                  const SizedBox(height: 10.0),
                  CommonWidgets.customTextFormField(
                    textInputType: TextInputType.streetAddress,
                    hintText: 'Address',
                    //    maxLength: 30,
                    controller: _addressController,
                    prefixIcon:
                        const Icon(Icons.maps_home_work_outlined, size: 20),
                    // validator: (value) {
                    //   return CommonWidgets.customValidator('$value');
                    // }
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
                        stringAssetImage: 'assets/images/neck.jpg',
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
                        stringAssetImage: 'assets/images/shoulder.jpg',
                        title: 'Shoulder',
                        controller: _shoulderController,
                        initialValue: _shoulderController.text,
                        list: CommonWidgets.generateList(9, 13),
                        onChanged: (String? value) => setState(() {
                          _shoulderController.text = value!;
                        }), // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage: 'assets/images/chest.jpg',
                        title: 'Chest',
                        controller: _chestController,
                        initialValue: _chestController.text,
                        list: CommonWidgets.generateList(31, 28),
                        onChanged: (String? value) => setState(() {
                          _chestController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasur
                        //       ementTile(value);
                        // }
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
                        stringAssetImage: 'assets/images/arm_length.jpg',
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
                        stringAssetImage: 'assets/images/biceps.jpg',
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
                        stringAssetImage: 'assets/images/wrist.jpg',
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
                        stringAssetImage: 'assets/images/shirt_length.jpg',
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
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonWidgets.customMeasurementTile(
                        stringAssetImage: 'assets/images/inseam.jpg',
                        title: 'Inseam',
                        controller: _inseamController,
                        initialValue: _inseamController.text,
                        list: CommonWidgets.generateList(18, 23),
                        onChanged: (String? value) => setState(() {
                          _inseamController.text = value!;
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
                        stringAssetImage: 'assets/images/calf.png',
                        title: 'Calf',
                        controller: _calfController,
                        initialValue: _calfController.text,
                        list: CommonWidgets.generateList(10, 11),
                        onChanged: (String? value) => setState(() {
                          _calfController.text = value!;
                        }),
                        // validator: (value) {
                        //   return CommonWidgets
                        //       .customValidatorForMeasurementTile(value);
                        // }
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
