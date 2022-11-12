import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tailor_app/screens/model_classes/model_add_customer.dart';
import 'package:tailor_app/utils/widgets.dart';

class PhoneNumberAuth extends StatefulWidget {
  const PhoneNumberAuth({Key? key}) : super(key: key);
  final String title = 'Continue With Phone';
  static late TextEditingController nameController;
  static var modelAddCustomer = ModelAddCustomer.tailorDetails();

  @override
  PhoneNumberAuthState createState() => PhoneNumberAuthState();
}

class PhoneNumberAuthState extends State<PhoneNumberAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static late TextEditingController _smsController;
  late String _verificationId;
  final _formKey = GlobalKey<FormState>();
  late String tailorPhone;

  @override
  void initState() {
    super.initState();
    PhoneNumberAuth.nameController = TextEditingController();
    _smsController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    PhoneNumberAuth.nameController.dispose();
    _smsController.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: PhoneNumberAuth.nameController,
                            decoration: InputDecoration(
                                hintText: 'Enter Name',
                                contentPadding:
                                    const EdgeInsets.only(top: 15, bottom: 0),
                                constraints:
                                    const BoxConstraints(maxHeight: 70),
                                prefixIcon:
                                    const Icon(Icons.person_outline, size: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Empty Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          IntlPhoneField(
                            dropdownTextStyle: const TextStyle(fontSize: 16),
                            initialValue: '+92',
                            onChanged: (phone) {
                              tailorPhone = phone.completeNumber;
                            },
                            decoration: InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: const TextStyle(fontSize: 16),
                                contentPadding: const EdgeInsets.only(top: 13),
                                constraints:
                                    const BoxConstraints(maxHeight: 70),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CommonWidgets.customBtn(
                      name: 'Get OTP',
                      width: width,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          verifyPhoneNumber();
                        }
                      }),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  TextFormField(
                      controller: _smsController,
                      maxLength: 6,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: 'Verification code',
                          constraints: const BoxConstraints(maxHeight: 70),
                          contentPadding: const EdgeInsets.only(
                              left: 20, bottom: 0, top: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Phone Number';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CommonWidgets.customBtn(
                      name: 'Sign In',
                      width: width,
                      onPressed: () async {
                        print(
                            '////////////////////////$tailorPhone////////////////');
                        await signInWithPhoneNumber();
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ));
  }

  Future verifyPhoneNumber() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sending Code'),
        backgroundColor: Color(0xD2EA4A26),
      ),
    );
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {};
    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}'),
          backgroundColor: Colors.red));
    };
    //Callback for when the code is sent
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code'),
        backgroundColor: Color(0xD2EA4A26),
      ));
      _verificationId = verificationId;
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("verification code: $verificationId")));
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: tailorPhone,
          timeout: const Duration(minutes: 2),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Verify Phone Number: $e")));
    }
  }

  signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user!;
      _auth.currentUser!.updateDisplayName(PhoneNumberAuth.nameController.text);
      print(
          '/////////_auth.currentUser!.displayName = ${_auth.currentUser!.displayName}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xD2EA4A26),
          content: Text('Successfully signed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text('Failed to sign in: $e')));
    }
  }
}
