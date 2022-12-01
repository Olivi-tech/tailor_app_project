import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tailor_app/account_creations/login_provider.dart';
import 'package:tailor_app/utils/widgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final String resetImg = 'assets/images/resetpwd.png';
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    double width = MediaQuery.of(ctx).size.width;
    double height = MediaQuery.of(ctx).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.pink,
          ),
          onPressed: () {
            Navigator.pop(ctx);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.1),
              SizedBox(
                  width: width,
                  height: height * 0.3,
                  child: Image(
                    image: AssetImage(resetImg),
                    fit: BoxFit.fitWidth,
                  )),
              SizedBox(
                height: height * 0.05,
              ),
              CommonWidgets.customTextFormField(
                hintText: 'Enter Email',
                controller: _emailController,
                prefixIcon: const Icon(Icons.email),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CommonWidgets.customBtn(
                name: 'Send Link',
                height: 40,
                width: width,
                onPressed: () async {
                  late var status;
                  if (_emailController.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'put email');
                  } else if (!_emailController.text.contains('.') ||
                      !_emailController.text.contains('@')) {
                    Fluttertoast.showToast(msg: 'Invalid email');
                  } else if (!await InternetConnectionChecker().hasConnection) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      dismissOnTouchOutside: true,
                      dismissOnBackKeyPress: true,
                      headerAnimationLoop: true,
                      animType: AnimType.scale,
                      title: 'No Internet 😟',
                      desc: 'Please make sure you are connected to internet',
                      descTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnOkOnPress: () {},
                    ).show();
                  } else {
                    status = await LoginProvider.resetPWD(
                      email: _emailController.text,
                      context: ctx,
                    );
                    if (status == 'password reset link sent successfully') {
                      AwesomeDialog(
                        context: ctx,
                        animType: AnimType.leftSlide,
                        headerAnimationLoop: false,
                        dialogType: DialogType.success,
                        showCloseIcon: true,
                        title: 'Link Sent',
                        titleTextStyle: TextStyle(color: Colors.black),
                        desc: 'Please Check your mail box',
                        descTextStyle: TextStyle(color: Colors.black),
                        btnOkOnPress: () {
                          debugPrint('OnClcik');
                        },
                        btnOkIcon: Icons.check_circle,
                        onDismissCallback: (type) {
                          debugPrint('Dialog Dissmiss from callback $type');
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: ctx,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        headerAnimationLoop: false,
                        title: 'Error 😟',
                        titleTextStyle: TextStyle(color: Colors.black),
                        desc: status == 'user-not-found'
                            ? '${_emailController.text} Doesn\'t exist in our database '
                            : 'Error Sending link',
                        descTextStyle: TextStyle(color: Colors.black),
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red,
                      ).show();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
