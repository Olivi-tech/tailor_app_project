import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_app/account_creations/login_provider.dart';
import 'package:tailor_app/utils/widgets.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final String _title = 'Sign Up';
  static TextStyle textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPWDController = TextEditingController();
  final TextEditingController _userPWDConfirmController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: SingleChildScrollView(
          //   reverse: true,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    _title,
                    textScaleFactor: 3,
                    style: textStyle,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: CommonWidgets.customTextFormField(
                          hintText: 'User Email',
                          hintStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(Icons.person_add_alt_1),
                          controller: _userEmailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email Can\'t Be Empty';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CommonWidgets.customTextFormField(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.black),
                          obscureText: true,
                          controller: _userPWDController,
                          prefixIcon: const Icon(Icons.password),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password Can\'t Be Empty';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CommonWidgets.customTextFormField(
                            hintText: 'Confirm Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password Can\'t Be Empty';
                              } else if (value != _userPWDController.text) {
                                return 'Password doesn\'t match';
                              }
                              return null;
                            },
                            obscureText: true,
                            prefixIcon: const Icon(Icons.password),
                            controller: _userPWDConfirmController)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CommonWidgets.customBtn(
                        onPressed: () async {
                          if (_userEmailController.text.isEmpty ||
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
                            final status = await LoginProvider.signUpWithEmail(
                              password: _userPWDController.text,
                              email: _userEmailController.text,
                            );
                            LoginProvider.customSnackBar(
                                status: status, context: context);
                            if (status == 'Account Created Successfully') {
                              Navigator.pop(context);
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
                    padding: EdgeInsets.only(top: 18.0),
                    child: Divider(
                      color: Colors.black,
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
