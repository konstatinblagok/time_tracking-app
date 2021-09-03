import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:timetrack/models/User.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", user.username);
    prefs.setString("email", user.email);
    prefs.setString("phone_number", user.phone_number);
    if(user.token != null) {
      prefs.setString("token", user.token);
      prefs.setString("renewalToken", user.renewalToken);
    }
    return true;
  }

  Future<bool> saveToken(token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("token", token);
  }

  Future<bool> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("token");
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = await prefs.getString("username");
    final email = await prefs.getString("email");
    final phone_number = await prefs.getString("phone_number");
    final token = await prefs.getString("token");
    final renewalToken = await prefs.getString("renewalToken");

    return User(
        username: username,
        email: email,
        phone_number: phone_number,
        token: token,
        renewalToken: renewalToken);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("email");
    prefs.remove("phone_number");
    prefs.remove("token");
  }

   Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    return token;
  }
}