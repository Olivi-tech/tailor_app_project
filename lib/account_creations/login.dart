import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/account_creations/login_provider.dart';
import 'package:tailor_app/account_creations/reset_pwd.dart';
import 'package:tailor_app/provider/change_pwd_icon.dart';
import 'package:tailor_app/screens/dashboard.dart';
import 'package:tailor_app/account_creations/phone_verification.dart';
import 'package:tailor_app/utils/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'sign_up.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    print('/////////////////////build///////////////////////////');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: <Widget>[
          SizedBox(
            width: width,
            height: height * 0.4,
            child: const Image(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/logo.png',
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CommonWidgets.customTextFormField(
                    hintText: 'Email',
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined)),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Consumer<ChangeIcon>(
                      builder: (context, value, child) =>
                          CommonWidgets.customTextFormField(
                              hintText: 'Password',
                              obscureText: isObscured,
                              controller: _pwdController,
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  isObscured = !isObscured;
                                  value.changeIcon(isObsecured: isObscured);
                                },
                                icon: value.isObsecure
                                    ? const Icon(Icons.visibility_off_sharp)
                                    : const Icon(Icons.visibility_outlined),
                              ),
                              textInputType: TextInputType.visiblePassword),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.55, top: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPassword(),
                          ));
                    },
                    child: const Text('Forgot Password?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            color: Colors.teal)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                CommonWidgets.customBtn(
                    onPressed: () async {
                      if (!_emailController.text.contains('@') ||
                          !_emailController.text.contains('.') ||
                          _emailController.text.isEmpty ||
                          _pwdController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: !_emailController.text.contains('@') ||
                                  !_emailController.text.contains('.') ||
                                  _emailController.text.isEmpty
                              ? 'Invalid or Empty Email'
                              : 'Password can\'t be Empty',
                          backgroundColor: Colors.black,
                        );
                      } else {
                        bool isAvailable =
                            await InternetConnectionChecker().hasConnection;
                        log('/////////////////internet is available = $isAvailable');
                        switch (isAvailable) {
                          case true:
                            final status =
                                await LoginProvider.signInWithEmailAndPWD(
                                    email: _emailController.text,
                                    password: _pwdController.text);
                            LoginProvider.customSnackBar(
                                status: status, context: context);
                            if (status == 'Signed In Successfully') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DashBoard()));
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
                    name: 'Login',
                    height: height * 0.06,
                    width: width),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: CommonWidgets.customBtn(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      name: 'Register Email',
                      height: height * 0.06,
                      width: width),
                )
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Divider(
                color: Color(0xD2EA4A26),
                indent: 50,
                endIndent: 50,
                thickness: 1,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundColor: const Color(0xD2EA4A26),
                    radius: 25,
                    child: IconButton(
                        onPressed: () async {
                          final status = await LoginProvider.signInWithGoogle();
                          LoginProvider.customSnackBar(
                              status: status, context: context);
                        },
                        icon: const Icon(FontAwesomeIcons.google,
                            color: Colors.white))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: IconButton(
                    onPressed: () async {
                      final status = await LoginProvider.signInWithFacebook(
                          context: context);
                      LoginProvider.customSnackBar(
                          status: status, context: context);
                    },
                    iconSize: 50,
                    icon: const Icon(
                      FontAwesomeIcons.facebook,
                      color: Color(0xD2EA4A26),
                      size: 50,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: const Color(0xD2EA4A26),
                  radius: 25,
                  child: IconButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PhoneNumberAuth()));
                      },
                      icon: const Icon(FontAwesomeIcons.phone,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ]),
      )),
    ));
  }
}
