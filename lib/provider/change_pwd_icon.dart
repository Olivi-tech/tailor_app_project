import 'package:flutter/material.dart';

class ChangeIcon with ChangeNotifier {
  bool _isActive = true;
  get isActive => _isActive;

  set isActive(value) {
    _isActive = value;
    notifyListeners();
  }

  bool isObsecure = true;
  changeIcon({required bool isObsecured}) {
    isObsecure = isObsecured;
    notifyListeners();
  }
}
