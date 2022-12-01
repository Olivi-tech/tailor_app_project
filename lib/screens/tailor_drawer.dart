import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../account_creations/login_provider.dart';

class TailorDrawer {
  static Widget myCustomDrawer(
      {required BuildContext context, required User? user}) {
    String tailorImg =
        'https://images.unsplash.com/photo-1584184924103-e310d9dc82fc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';

    String? accountMailOrNbr = user!.email ?? user.phoneNumber;
    return Drawer(
        semanticLabel: 'Details',
        backgroundColor: Colors.pink.shade200,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                currentAccountPictureSize: const Size(90, 90),
                accountName: Text(user.displayName ?? ''),
                accountEmail: Text(accountMailOrNbr!),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.red.shade400,
                    Colors.pink.shade400,
                  ]),
                  color: Colors.deepPurple,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.amber,
                  backgroundImage: CachedNetworkImageProvider(
                    user.photoURL ?? tailorImg,
                  ),
                )),
            ListTile(
              textColor: Colors.white,
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout_sharp),
              onTap: () async {
                if (await InternetConnectionChecker().hasConnection) {
                  final status = await LoginProvider.logout(context: context);
                  await LoginProvider.customSnackBar(
                      status: status, context: context);
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    dismissOnTouchOutside: true,
                    dismissOnBackKeyPress: true,
                    headerAnimationLoop: true,
                    animType: AnimType.scale,
                    title: 'No Internet',
                    desc: 'Please make sure you are connected to internet',
                    descTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: true,
                    btnOkOnPress: () {},
                  ).show();
                }
              },
            ),
          ],
        ));
  }
}
