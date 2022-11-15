import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tailor_app/screens/customer_details/add_waist.dart';
import 'package:tailor_app/screens/customer_details/customer_personal_details.dart';
import 'package:tailor_app/utils/widgets.dart';

class AddChest extends StatefulWidget {
  const AddChest({Key? key}) : super(key: key);

  @override
  State<AddChest> createState() => _AddChestState();
}

class _AddChestState extends State<AddChest> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.addCustomerDetails(
        context: context,
        list: CommonWidgets.generateList(31, 28),
        stringAssetImg: 'assets/images/chest-removebg-preview.png',
        name: 'Chest',
        onPressed: (String? value) {
          setState(() {
            this.value = value;
          });
        },
        nextOnPressed: () {
          if (value == null || value!.isEmpty) {
            Fluttertoast.showToast(msg: 'Select Value');
          } else {
            CustomerPersonalDetails.modelAddCustomer.chest = value!;
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const AddWaist()));
          }
        },
        value: value);
  }
}
