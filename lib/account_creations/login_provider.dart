import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider {
  static late FirebaseAuth auth;
  static late String _verificationId;

  static Future<String> verifyPhoneNumber(
      {required String phoneNumber, required BuildContext context}) async {
    auth = FirebaseAuth.instance;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await auth.signInWithCredential(phoneAuthCredential);
            customSnackBar(status: 'Signed In Successfully', context: context);
          },
          verificationFailed: (FirebaseAuthException authException) {
            customSnackBar(
                status:
                    'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
                context: context);
          },
          codeSent: (String verificationId, [int? forceResendingToken]) async {
            LoginProvider.customSnackBar(
                status: 'Please check your phone for the verification code.',
                context: context);
            _verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            LoginProvider.customSnackBar(
                status: 'verification code: $verificationId', context: context);
            _verificationId = verificationId;
          });
    } catch (e) {
      LoginProvider.customSnackBar(
          status: "Failed to Verify Phone Number: $e", context: context);
    }
    return LoginProvider.customSnackBar(
        status: 'Something has went wrong', context: context);
  }

  static Future<String> signInWithPhoneNumber(
      {required String smsCode, required BuildContext context}) async {
    try {
      PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);
      return 'Signed In Successfully';
    } catch (e) {
      customSnackBar(status: '$e', context: context);
    }
    return 'Something has went wrong';
  }

  static Future<String> signInWithFacebook(
      {required BuildContext context}) async {
// Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.success) {
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      print(
          '${credential.idToken}//////////////credential.idToken/////////////////');
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        return 'Signed In Successfully';
        //  print();
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        return '$e';
      } catch (e) {
        print(e.toString());
        return '$e';
        // manage other exceptions
      }
    }
    return 'Something has went wrong';
    // Create a credential from the access token
  }

  static Future<String> logout({required BuildContext context}) async {
    var providerID =
        FirebaseAuth.instance.currentUser?.providerData.first.providerId;
    print('////////////////providerID = $providerID/////////////////');
    switch (providerID) {
      case 'google.com':
        print(' ///////////////case google.com//////////////////////');
        try {
          await GoogleSignIn().disconnect().whenComplete(() async {
            await FirebaseAuth.instance.signOut();
          });
          // Navigator.pop(context);
          return 'Logged out Successfully';
        } catch (e) {
          return 'Could not Logged out';
        }
      case 'facebook.com':
        print('///////////////// case facebook.com//////////////////');
        try {
          await FacebookAuth.instance.logOut().whenComplete(() async {
            FirebaseAuth.instance.signOut();
          });
          Navigator.pop(context);
          return 'Logged out Successfully';
        } catch (e) {
          return 'Could not Logged out';
        }
      case 'phone':
        print('///////////////// case phone//////////////////');
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          return 'Logged out Successfully';
        } catch (e) {
          return 'Could not Logged out';
        }
      case 'password':
        print('/////////////////case password//////////////////');
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          return 'Logged out Successfully';
        } catch (e) {
          return 'Could not Logged out';
        }
    }
    return 'SomeThing Went Wrong';
  }

  static Future<String> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return 'Signed In Successfully';
    } catch (e) {
      return 'Something went wrong';
    }
  }

  static Future<String> signInWithEmailAndPWD({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Signed In Successfully');
      return 'Signed In Successfully';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for this email.');
        return 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'wrong-password';
      }
    }
    return 'try again later';
  }

  static Future<String> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      return 'Account Created Successfully';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //  print('weak-password');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        //   print(e.toString());
        return 'The account already exists for this email.';
      }
    } catch (e) {
      //  print(e);
      return 'Error: $e';
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SomeThing Went Wrong')));
    }
    return 'SomeThing Went Wrong';
  }

  static Future<String> resetPWD(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      log('///////////////////sent /////////////');
      return 'password reset link sent successfully';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('user-not-found');
        return 'user-not-found';
      } else {
        log('$e');
        return '$e';
      }
    }
  }

  static Future<String> customSnackBar(
      {required String status, required BuildContext context}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(status),
      backgroundColor: status == 'Signed In Successfully' ||
              status == 'Logged out Successfully' ||
              status == 'Account Created Successfully' ||
              status == 'password reset link sent successfully'
          ? const Color(0xD2EA4A26)
          : Colors.red,
    ));
    return 'error';
  }
}
