import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tailor_app/screens/customer_details/add_shoulder.dart';
import 'package:tailor_app/screens/customer_details/customer_personal_details.dart';
import 'package:tailor_app/utils/widgets.dart';

class AddNeck extends StatefulWidget {
  const AddNeck({Key? key}) : super(key: key);

  @override
  State<AddNeck> createState() => _AddNeckState();
}

class _AddNeckState extends State<AddNeck> {
  String? value;
  late TextEditingController _neckController;

  @override
  void initState() {
    super.initState();
    _neckController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _neckController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonWidgets.addCustomerDetails(
      context: context,
      list: CommonWidgets.generateList(11, 12),
      stringAssetImg: 'assets/images/NeckMeasurement-removebg-preview.png',
      name: 'Neck',
      value: value,
      onPressed: (String? value) {
        setState(() {
          this.value = value;
        });
      },
      nextOnPressed: () {
        if (value == null || value!.isEmpty) {
          Fluttertoast.showToast(msg: 'Select Value');
        } else {
          //   _neckController.text = value!;
          CustomerPersonalDetails.modelAddCustomer.neck = value!;
          // print('///////////////////////////$value/////////////////////');
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const AddShoulder()));
        }
      },
    );
  }
}
