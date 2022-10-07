import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/dashboard.dart';
import '../account_creations/login.dart';

class DataCheck extends StatelessWidget {
  const DataCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    //     // double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Some Thing Has Went Wrong',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    backgroundColor: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            return const DashBoard();
          }
          return const Login();
        });
    // return Login();
  }
}
