import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneNumberAuth extends StatefulWidget {
  const PhoneNumberAuth({Key? key}) : super(key: key);
  final String title = 'Verify Phone';

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
    _phoneController = TextEditingController();
    _smsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone Number';
                          }
                          return null;
                        },
                        controller: _phoneController,
                        autofocus: true,
                        decoration: const InputDecoration(
                            //   border: OutlineInputBorder(),
                            fillColor: Colors.deepOrange,
                            labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          child: const Text("Get current number"),
                          onPressed: () async => {
                            _phoneController.text = (await _smsAutoFill.hint)!
                          },
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text("Verify Number"),
                        onPressed: () async {
                          verifyPhoneNumber();
                        },
                      ),
                    ),
                    TextFormField(
                        controller: _smsController,
                        decoration: const InputDecoration(
                          labelText: 'Verification code',
                          //   border: OutlineInputBorder()
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone Number';
                          }
                          return null;
                        }),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () async {
                            await signInWithPhoneNumber();
                            Navigator.pop(context);

                            // Navigator.pushNamed(context, '/signed_in_page');
                          },
                          child: const Text("Sign in")),
                    ),
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully signed in UID: ${user.uid}')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
    }
  }
}
