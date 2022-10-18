import 'package:flutter/material.dart';

class ChangeIcon with ChangeNotifier {
  // bool isInvisible = true;
  Icon? _iconVisible;
  Icon? _iconInVisible;
  get iconVisible {
    return _iconVisible;
  }

  set iconVisible(value) {
    _iconVisible = value;
    notifyListeners();
  }

  get iconInVisible {
    return _iconInVisible;
  }

  set iconInVisible(value) {
    _iconInVisible = value;
    notifyListeners();
  }
}
