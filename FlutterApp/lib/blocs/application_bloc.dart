import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:timetrack/models/User.dart';
import 'package:timetrack/models/address_decoding.dart';
import 'package:timetrack/models/places_search.dart';
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/services/auth_service.dart';
import 'package:timetrack/services/geolocator_service.dart';
import 'package:timetrack/services/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timetrack/services/userpreference_service.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  LoggingIn,
  Registered,
  Authenticating,
  Registering,
  RegisteringError,
  LoggedOut,
  NotOtpVerified,
  OtpVerifying,
  OtpVerified,
}

enum Shipping{
 ShippingNotSubmitted,
 ShippingSubmitting,
 ShippingSubmitted
}

class Applicationbloc with ChangeNotifier{
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status _otpStatus = Status.NotOtpVerified;
  Shipping _shippingStatus = Shipping.ShippingNotSubmitted;

  late User user;
  var selectedTrackingCode;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  Status get otpStatus => _otpStatus;
  Shipping get shippingStatus => _shippingStatus;

  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();
  final authService = AuthService();
  List<Results> searchresults =[];
  List<PlacesSearch> searchcityresults =[];
  List<User> searchuserresults =[];
  var response;

  //variable
  late Position currentLocation;

  Applicationbloc(){
    setCurrentLocation();
  }

  setCurrentLocation() async{
    currentLocation = await geolocatorService.getCurrentLocation();
    notifyListeners();
  }

  Future searchPlaces(String searchTerm) async{
   var result;
    searchresults = await placesService.getAutocomplete(searchTerm);
   if(searchresults.length > 0 ) {
     result = {
       'status': true,
     };
   }else{
     searchresults = [];
     result = {
       'status': false,
       'message': "Something went Wrong"
     };
   }
   return result;
  }

  searchUsers(String searchTerm) async{
    searchuserresults = await authService.getUserAutocomplete(searchTerm, 'getUsers');
    notifyListeners();
  }

  searchCity(String searchTerm) async{
    searchcityresults = await placesService.getCityAutocomplete(searchTerm);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getLoggedInUser(apiurl) async{
    var result;
    response = await authService.getLoggedInUser(apiurl);
    notifyListeners();
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final user = (json.decode(response.body)['users']);
      final token = (json.decode(response.body)['token']);
      UserPreferences().saveToken(token);
      User authUser = User.fromJson(user);
      result = {'status': true, 'message': 'Successful', 'user': authUser};
      notifyListeners();
    } else {
      result = {
        'status': false,
        'message': "Something Went Wrong!"
      };
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> signIn(data, apiurl) async{
    var result;
    _loggedInStatus = Status.LoggingIn;
    notifyListeners();
    response = await authService.signup(data, apiurl);
    // response = await authService.signup(data, apiurl);
    print("data response -- ${response}");
    if (response.statusCode == 200) {
      final user = (json.decode(response.body)['user']);
      User authUser = User.fromJson(user);
      result = {'status': true, 'message': 'Successful', 'user': authUser};
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> signup(data, apiurl) async{
    var result;
    _registeredInStatus = Status.Registering;
    response = await authService.signup(data, apiurl);
    notifyListeners();
    if (response.statusCode == 200) {
      final userData = (json.decode(response.body)['user']);
      User authUser = User.fromJson(userData);
      result = {'status': true, 'message': 'Successful', 'user': authUser};
      _registeredInStatus = Status.Registered;
      notifyListeners();
    }else{
      _registeredInStatus = Status.RegisteringError;
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> update(data, apiurl) async{
    var result;
    _registeredInStatus = Status.Registering;
    response = await authService.update(data, apiurl);
    notifyListeners();
    if (response.statusCode == 200) {
      final userData = (json.decode(response.body)['user']);
      User authUser = User.fromJson(userData);
      result = {'status': true, 'message': 'Successful', 'user': authUser};
      _registeredInStatus = Status.Registered;
      notifyListeners();
    }else{
      _registeredInStatus = Status.RegisteringError;
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> verifyotp(data, apiurl) async{
    var result;
    // response = await authService.verifyOtp(data, apiurl);
    Response response = await authService.verifyOtp(data, apiurl);
    print('verify otp response -- ${response.statusCode}');
    _otpStatus = Status.OtpVerifying;
    notifyListeners();
    if (response.statusCode == 200) {
      final token = (json.decode(response.body)['token']);
      final user = (json.decode(response.body)['user']);
      UserPreferences().saveToken(token);
      User authUser = User.fromJson(user);
      result = {'status': true, 'message': 'Successful', 'user': authUser};
      _otpStatus = Status.OtpVerified;
      notifyListeners();
    } else {
      _otpStatus = Status.NotOtpVerified;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }
  //
  // Future logout(apiurl) async{
  //   var result;
  //   response = await authService.logout(apiurl);
  //   if (response.statusCode == 200) {
  //
  //     result = {
  //       'status': true,
  //       'message': "Successfully logged Out!"
  //     };
  //   } else {
  //     result = {
  //       'status': false,
  //       'message': json.decode(response.body)['message']
  //     };
  //   }
  //   return result;
  // }

  Future logout(apiurl) async{
    var result;
    response = await authService.logout(apiurl);
    if (response.statusCode == 200) {

      result = {
        'status': true,
        'message': "Successfully logged Out!"
      };
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future clearHistory(apiurl) async{
    var result;
    response = await authService.clearHistory(apiurl);;
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': "Successfully logged Out!"
      };
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future deleteAccount(apiurl) async{
    var result;
    response = await authService.deleteAccount(apiurl);
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': "Successfully deleted account!"
      };
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> postShippingDetails(data, apiurl) async{
    var result;
    response = await authService.postShipping(data, apiurl);
    _shippingStatus = Shipping.ShippingSubmitting;
    notifyListeners();
    if (response.statusCode == 200) {
      final trackingDetails = (json.decode(response.body)['shippingData']);
      ShippingData shippingData = ShippingData.fromJson(trackingDetails);
      result = {'status': true, 'message': 'Successful', 'trackingDetails': shippingData};
      _shippingStatus = Shipping.ShippingSubmitted;
      notifyListeners();
    } else {
      _shippingStatus = Shipping.ShippingNotSubmitted;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> shippingDetails(data, apiurl) async{
    var result;
    response = await authService.postShipping(data, apiurl);
    _shippingStatus = Shipping.ShippingSubmitting;
    notifyListeners();
    if (response.statusCode == 200) {

      final trackingDetails = (json.decode(response.body)['shippingData']);
      ShippingData shippingData = ShippingData.fromJson(trackingDetails);
      result = {'status': true, 'message': 'Successful', 'trackingDetails': shippingData};
      _shippingStatus = Shipping.ShippingSubmitted;
      notifyListeners();
    } else {
      _shippingStatus = Shipping.ShippingNotSubmitted;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> clearQueue(apiurl) async{
    var result;
    response = await authService.clearQueue(apiurl);
    _shippingStatus = Shipping.ShippingSubmitting;
    notifyListeners();
    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'Successful Cleared Queue',};
      _shippingStatus = Shipping.ShippingSubmitted;
      notifyListeners();
    } else {
      _shippingStatus = Shipping.ShippingNotSubmitted;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }


}