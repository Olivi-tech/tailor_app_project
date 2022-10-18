import 'package:flutter/cupertino.dart';

class SearchProvider extends ChangeNotifier {
  String _searchedText = '';
  String get searchedText => _searchedText;
  set searchedText(value) {
    _searchedText = value;
    notifyListeners();
  }

  void clearText() {
    searchedText = '';
    // print('////VALUE///////////$value/////////////////');
    print(
        '////searchedt=Text//////isempty/////${searchedText.isEmpty}/////////////////');

    notifyListeners();
  }
}
