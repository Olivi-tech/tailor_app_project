import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/account_creations/login_provider.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({super.key});
  static final DatabaseReference reference =
      FirebaseDatabase.instance.ref('tailor');

  final tailorImg =
      'https://images.unsplash.com/photo-1584184924103-e310d9dc82fc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String img = user!.photoURL ?? tailorImg;
    String? tailorNameByProvider = user.displayName;
    print('////////////////////////$tailorNameByProvider//////////////');
    String? accountMail = user.email ?? user.phoneNumber;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.7,
        height: height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.deepOrange,
                  Colors.amberAccent,
                ]),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 0,
                  //right: width * 0.2,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      minRadius: 60,
                      backgroundColor: Colors.greenAccent,
                      backgroundImage: NetworkImage(img),
                    ),
                    SizedBox(
                      height: height * 0.009,
                    ),
                    FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: reference,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        print(
                            '//////////////animated list $tailorNameByProvider//////////');
                        String? name = tailorNameByProvider ??
                            snapshot.child('name').value.toString();

                        print(
                            '///////////////////////name = ${snapshot.child('name').value.toString}//////////////////');
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          tileColor: Colors.red,
                          title: Text(name),
                          subtitle: Text(accountMail!),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Text('Logout'),
              onTap: () async {
                final status = await LoginProvider.logout(context: context);
                await LoginProvider.customSnackBar(
                    status: status, context: context);
              },
            ),
          ],
        ));
  }
}
