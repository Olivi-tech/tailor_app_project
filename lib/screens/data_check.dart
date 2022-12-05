import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/provider/change_pwd_icon.dart';
import 'package:tailor_app/screens/dashboard.dart';
import '../account_creations/login.dart';

class DataCheck extends StatelessWidget {
  const DataCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChangeIcon()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.red,
            appBarTheme: const AppBarTheme(
                centerTitle: true, backgroundColor: Color(0xD2EA4A26)),
            textTheme: GoogleFonts.tinosTextTheme(
              Theme.of(context).textTheme.copyWith(
                  bodyText2: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyText1: const TextStyle(color: Colors.black)),
            )),
        home: StreamBuilder(
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
              return Login();
            }),
      ),
    );
  }
}
