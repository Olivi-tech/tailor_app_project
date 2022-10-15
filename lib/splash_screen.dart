import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/data_check.dart';

import 'firebase_options.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('Come', textStyle: textStyle()),
              TyperAnimatedText('for', textStyle: textStyle()),
              TyperAnimatedText('design', textStyle: textStyle()),
            ],
            totalRepeatCount: 1,
            onFinished: (() async {
              WidgetsFlutterBinding.ensureInitialized();
              await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataCheck(),
                  ));
            }),
          ),
        ));
  }

  TextStyle textStyle() {
    // ignore: prefer_const_constructors
    return TextStyle(
        color: Colors.amber, decorationStyle: TextDecorationStyle.wavy);
  }
}
