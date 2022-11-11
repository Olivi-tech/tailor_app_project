import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tailor_app/account_creations/login_provider.dart';
import 'package:tailor_app/screens/model_classes/model_add_customer.dart';
import 'package:tailor_app/utils/widgets.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);
  static var modelAddCustomer = ModelAddCustomer.tailorDetails();
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String _title = 'Sign Up';
  late final TextEditingController _userNameController;
  late final TextEditingController _userEmailController;
  late final TextEditingController _userPWDController;
  late final TextEditingController _userPWDConfirmController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _userEmailController = TextEditingController();
    _userPWDController = TextEditingController();
    _userPWDConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPWDController.dispose();
    _userPWDConfirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shadowColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xD2EA4A26),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(_title,
                      textScaleFactor: 3,
                      style: const TextStyle(
                        color: Color(0xD2EA4A26),
                      )),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CommonWidgets.customTextFormField(
                          hintText: 'User Name',
                          controller: _userNameController,
                          prefixIcon: const Icon(Icons.person_outline)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: CommonWidgets.customTextFormField(
                          hintText: 'User Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          controller: _userEmailController,
                          textInputType: TextInputType.emailAddress,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: CommonWidgets.customTextFormField(
                          hintText: 'Password',
                          obscureText: true,
                          controller: _userPWDController,
                          prefixIcon: const Icon(Icons.password),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: CommonWidgets.customTextFormField(
                            hintText: 'Confirm Password',
                            obscureText: true,
                            prefixIcon: const Icon(Icons.password),
                            controller: _userPWDConfirmController)),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: CommonWidgets.customBtn(
                        onPressed: () async {
                          if (_userNameController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'Empty Name');
                          } else if (_userEmailController.text.isEmpty ||
                              !_userEmailController.text.contains('@') ||
                              !_userEmailController.text.contains('.')) {
                            Fluttertoast.showToast(
                                msg: _userEmailController.text.isEmpty
                                    ? 'Email Can\'t Be Empty'
                                    : 'Invalid Email');
                          } else if (_userPWDController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Password can\'t be empty');
                          } else if (_userPWDConfirmController.text.isEmpty ||
                              _userPWDController.text !=
                                  _userPWDConfirmController.text) {
                            Fluttertoast.showToast(
                                msg: _userPWDConfirmController.text.isEmpty
                                    ? 'Confirm Password Can\'t Be Empty'
                                    : 'Password doesn\'t match');
                          } else {
                            bool isAvailable =
                                await InternetConnectionChecker().hasConnection;
                            log('//////////////internet is available = $isAvailable//////');
                            switch (isAvailable) {
                              case true:
                                final status =
                                    await LoginProvider.signUpWithEmail(
                                  password: _userPWDController.text,
                                  email: _userEmailController.text,
                                  name: _userNameController.text,
                                );
                                LoginProvider.customSnackBar(
                                    status: status, context: context);
                                if (status == 'Account Created Successfully') {
                                  Navigator.pop(context);
                                }
                                break;
                              case false:
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  dismissOnTouchOutside: true,
                                  dismissOnBackKeyPress: true,
                                  headerAnimationLoop: true,
                                  animType: AnimType.scale,
                                  title: 'No Internet',
                                  desc:
                                      'Please make sure you are connected to internet',
                                  descTextStyle:
                                      const TextStyle(color: Colors.black),
                                  showCloseIcon: true,
                                  btnOkOnPress: () {},
                                ).show();
                            }
                          }
                        },
                        name: 'Sign Up',
                        height: height * 0.06,
                        width: width,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 30, right: 30),
                    child: Divider(
                      color: Color(0xD2EA4A26),
                      thickness: 1.0,
                      indent: 5,
                      endIndent: 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: height * 0.06,
                      width: width,
                      child: CommonWidgets.customBtn(
                          name: 'Go to SignIn Page',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
