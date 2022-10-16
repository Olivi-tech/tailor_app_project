import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_app/screens/customer_details/add_neck.dart';
import 'package:tailor_app/screens/model_classes/model_add_customer.dart';
import 'package:tailor_app/utils/widgets.dart';

class CustomerPersonalDetails extends StatefulWidget {
  static final ModelAddCustomer modelAddCustomer = ModelAddCustomer();
  const CustomerPersonalDetails({Key? key}) : super(key: key);
  @override
  State<CustomerPersonalDetails> createState() =>
      _CustomerPersonalDetailsState();
}

class _CustomerPersonalDetailsState extends State<CustomerPersonalDetails> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // User? currentUser = FirebaseAuth.instance.currentUser;
    // final customerCollection =
    //     FirebaseFirestore.instance.collection(currentUser!.uid);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        // padding: EdgeInsets.only(right: 10, left: 0.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          color: Color(0xD2EA4A26),
                        )),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Add Customer Details',
                    style: TextStyle(
                        color: Color(0xD2EA4A26),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CommonWidgets.customTextFormField(
                      hintText: 'First Name',
                      controller: _firstNameController,
                      textInputType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z 0-9]'))
                      ],
                      prefixIcon: const Icon(Icons.person_add_alt_1_rounded)),
                  CommonWidgets.customTextFormField(
                      hintText: 'Last Name',
                      controller: _lastNameController,
                      textInputType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z 0-9]'))
                      ],
                      prefixIcon: const Icon(Icons.person_add_alt_1_rounded)),
                  CommonWidgets.customTextFormField(
                      hintText: 'Phone Number',
                      controller: _phoneController,
                      textInputType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: const Icon(Icons.phone_android)),
                  CommonWidgets.customTextFormField(
                      hintText: 'Address',
                      controller: _addressController,
                      textInputType: TextInputType.streetAddress,
                      prefixIcon: const Icon(Icons.place)),
                  const SizedBox(height: 16),
                  CommonWidgets.customBtn(
                    name: 'Add Measurements',
                    onPressed: () {
                      if (_firstNameController.text.isEmpty ||
                          _lastNameController.text.isEmpty ||
                          _phoneController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: _firstNameController.text.isEmpty ||
                                    _lastNameController.text.isEmpty
                                ? 'Enter Name'
                                : 'Enter Phone Number');
                      } else if (_addressController.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'Enter Address');
                      } else {
                        CustomerPersonalDetails.modelAddCustomer.firstName =
                            _firstNameController.text;
                        CustomerPersonalDetails.modelAddCustomer.lastName =
                            _lastNameController.text;
                        CustomerPersonalDetails.modelAddCustomer.phoneNumber =
                            _phoneController.text;
                        CustomerPersonalDetails.modelAddCustomer.address =
                            _addressController.text;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddNeck()));
                        // print(modelAddCustomer.toString());
                      }
                    },
                    width: width * 0.9,
                    height: height * 0.06,
                  ),
                  const SizedBox(height: 10),
                  CommonWidgets.customBtn(
                      name: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: width * 0.9,
                      height: height * 0.06)
                ]),
          ),
        ),
      ),
    );
  }
}
