import 'package:flutter/material.dart';

class ChangeIcon with ChangeNotifier {
  bool isObsecure = true;
  changeIcon({required bool isObsecured}) {
    isObsecure = isObsecured;
    notifyListeners();
  }
}
