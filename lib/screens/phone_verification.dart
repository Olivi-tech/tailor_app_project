import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tailor_app/utils/widgets.dart';

class PhoneNumberAuth extends StatefulWidget {
  const PhoneNumberAuth({Key? key}) : super(key: key);
  final String title = 'Continue With Phone';
  static late TextEditingController nameController;

  @override
  PhoneNumberAuthState createState() => PhoneNumberAuthState();
}

class PhoneNumberAuthState extends State<PhoneNumberAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static late TextEditingController _phoneController;
  static late TextEditingController _smsController;
  late String _verificationId;
  final SmsAutoFill _smsAutoFill = SmsAutoFill();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    PhoneNumberAuth.nameController = TextEditingController();
    _phoneController = TextEditingController();
    _smsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    PhoneNumberAuth.nameController.dispose();
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
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
                                      EdgeInsets.only(top: 15, bottom: 0),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: const Icon(Icons.person_outline,
                                      size: 20),
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
                              height: height * 0.03,
                            ),
                            IntlPhoneField(
                              dropdownTextStyle: const TextStyle(fontSize: 16),
                              controller: _phoneController,
                              initialValue: '+92',
                              onChanged: (value) {
                                print(
                                    '////////////////////value = $value//////////////////////////////');
                                // _phoneController.text = value;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: const TextStyle(fontSize: 16),
                                  contentPadding:
                                      const EdgeInsets.only(top: 13),
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
                            print(
                                '//////////////////${_phoneController.text}/////////////////////////');
                            verifyPhoneNumber();
                          }
                        }),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFormField(
                        controller: _smsController,
                        maxLength: 4,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: 'Verification code',
                            constraints: const BoxConstraints(maxHeight: 70),
                            contentPadding: const EdgeInsets.only(
                                left: 20, bottom: 0, top: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone Number';
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
                              '////////////////////////${_phoneController.text}////////////////');
                          await signInWithPhoneNumber();
                          Navigator.pop(context);
                        })
                  ],
                ),
              )),
        ));
  }

  Future verifyPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}")));
    };
    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}')));
    };
    //Callback for when the code is sent
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please check your phone for the verification code.')));
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
          phoneNumber: _phoneController.text,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to Verify Phone Number: $e")));
    }
  }

  signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user!;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successfully signed')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
    }
  }
}
