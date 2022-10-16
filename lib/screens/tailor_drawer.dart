import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/account_creations/login_provider.dart';

class TailorDrawer {
  static Widget myCustomDrawer(
      {required BuildContext context, required User? user}) {
    String tailorImg =
        'https://images.unsplash.com/photo-1584184924103-e310d9dc82fc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';
    // var tailorImg =
    //     'https://images.unsplash.com/photo-1584184924103-e310d9dc82fc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';

    // String customerName = '';

    // String? providerID = user!.providerData.first.providerId;
    // print(
    //     '//////////////////////////customerName = $customerName///////////////////');
    // late Widget name;
    // switch (providerID) {
    //   case 'google.com':
    //     name = Text(user!.displayName!);
    //     break;
    //   case 'facebook.com':
    //     name = Text(user!.displayName!);
    //     break;
    //   case 'password':
    //     name = drawerNameList();
    //     break;
    //   case 'phone':
    //     name = drawerNameList();
    // }

    // var data = FirebaseFirestore.instance
    //     .collection(ModelAddCustomer.keytailorEmail)
    //     .doc(ModelAddCustomer.keyTailorName);
    // print(
    //     '////////user!.displayName/////${user!.displayName}/////////tailorName = $tailorName////////////////////////');

    String? accountMailOrNbr = user!.email ?? user.phoneNumber;
    print(
        '////////accountMailOrNbr/////$accountMailOrNbr/////////////////////////////////');
    print(
        '////////currentUser/////${user!.displayName}/////////////////////////////////');
    return Drawer(
        semanticLabel: 'Details',
        backgroundColor: Colors.deepPurpleAccent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                currentAccountPictureSize: const Size(90, 90),
                accountName: Text(user!.displayName ?? ''),
                // accountName: user!.displayName == null
                //     ? StreamBuilder(
                //         stream: FirebaseFirestore.instance
                //             .collection(accountMailOrNbr!)
                //             .snapshots(),
                //         builder: (context, snapshot) {
                //           if (snapshot.hasData) {
                //             var data = snapshot.data!.docs;
                //             var foo = data[0]
                //                 [ModelAddCustomer.keyTailorName.toString()];
                //             print('.....................foo..........$foo');
                //             return Text(foo);
                //           } else {
                //             print('.....................foo.........');
                //             return const SizedBox();
                //           }
                //         })
                //     : Text(user!.displayName!.toString()),
                accountEmail: Text(accountMailOrNbr!),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.deepOrangeAccent,
                    Colors.yellow,
                  ]),
                  color: Colors.deepPurple,
                ),
                arrowColor: Colors.pink,
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.amber,
                  backgroundImage: CachedNetworkImageProvider(
                    user!.photoURL ?? tailorImg,
                  ),
                )),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
              title: const Text('Title'),
              textColor: Colors.white,
              trailing: const Text('Trailing'),
              tileColor: Colors.lightGreen.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                title: const Text('Title'),
                textColor: Colors.white,
                trailing: const Text('Trailing'),
                tileColor: Colors.lightGreen.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ListTile(
                textColor: Colors.white,
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                title: const Text('Logout'),
                trailing: const Text('Logout'),
                tileColor: Colors.lightGreen.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onTap: () async {
                  final status = await LoginProvider.logout(context: context);
                  await LoginProvider.customSnackBar(
                      status: status, context: context);
                },
              ),
            ),
          ],
        ));
  }
}
