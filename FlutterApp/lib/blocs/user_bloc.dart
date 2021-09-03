import 'package:flutter/foundation.dart';
import 'package:timetrack/models/User.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();
  String? _phonenumber;

  User get user => _user;
  String? get phone_number => _phonenumber;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setPhoneNumber(String phoneno) {
    _phonenumber = phoneno;
    notifyListeners();
  }
}