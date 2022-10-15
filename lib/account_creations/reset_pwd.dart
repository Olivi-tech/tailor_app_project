import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
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
              SizedBox(
                  width: width,
                  height: height * 0.3,
                  child: Image(
                    image: AssetImage(resetImg),
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high,
                    // loadingBuilder: (BuildContext context, Widget child,
                    //     ImageChunkEvent? loadingProgress) {
                    //   return const Center(child: CircularProgressIndicator());
                    // },
                  )),
              SizedBox(
                height: height * 0.05,
              ),
              CommonWidgets.customTextFormField(
                hintText: 'Enter Email',
                controller: _emailController,
                prefixIcon: const Icon(Icons.email),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'put email';
                //   }
                //   return null;
                // },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CommonWidgets.customBtn(
                name: 'Send Link',
                height: 40,
                width: width,
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'put email');
                  } else {
                    print('////////////email = ${_emailController.text}//////');
                    var status = await LoginProvider.resetPWD(
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
                        title: 'Succes',
                        desc: 'Link sent successfully',
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
                        title: 'Error',
                        desc: 'Error Sending Link',
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
