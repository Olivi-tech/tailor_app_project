import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/data_check.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ErrorWidget.builder = (FlutterErrorDetails details) => Material(
  //       color: Colors.green.shade200,
  //       child: Center(
  //         child: Text(
  //           details.exception.toString(),
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //       ),
  //     );
  runApp(MaterialApp(
      home: const DataCheck(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      )));
}
