import 'dart:developer';

import 'package:flutter/material.dart';

class ChangeIcon with ChangeNotifier {
  bool _isCompleted = false;
  get isCompleted => _isCompleted;

  set isCompleted(value) {
    _isCompleted = value;
    log('change icon is completed: $_isCompleted');
    notifyListeners();
  }

  bool isObsecure = true;
  changeIcon({required bool isObsecured}) {
    isObsecure = isObsecured;
    notifyListeners();
  }
}
