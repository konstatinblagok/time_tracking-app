import 'dart:convert';
import 'dart:convert' as convert ;
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/services/userpreference_service.dart';

class AuthService{
  var token = UserPreferences().getToken();
  var headers;

  signup(data, apiUrl) async
  {
    var fullurl = BASE_API_URL + apiUrl;
    var response = await http.post(Uri.parse(fullurl),
    body: jsonEncode(data),
      headers: _setHeaders()
    );
    return (response);
  }
  Dio dio = new Dio();

  verifyOtp(data, apiUrl) async
  {
    var fullurl = BASE_API_URL + apiUrl;
    // final response = await dio.post(fullurl,data: data,options: Options(headers: _setHeaders(),method: "POST",responseType: ResponseType.plain));
    var response = await http.post(Uri.parse(fullurl),
        // body: data,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
    return (response);
  }

  postShipping(data, apiUrl) async
  {
    var token = await UserPreferences().getToken();
    var fullurl = BASE_API_URL + apiUrl;
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    return (response);
  }

  update(data, apiUrl) async
  {
    var token = await UserPreferences().getToken();
    var fullurl = BASE_API_URL + apiUrl;
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    return (response);
  }

  Future updateShippingStatus(data, apiurl) async{
    var token = await UserPreferences().getToken();
    var result;
    var fullurl = BASE_API_URL + apiurl;
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    if(response.statusCode == 200){
      result = {
        'status': true,
        'message': "Successfully Delivered Message"
      };
    }else{
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future saveCards(data, apiurl) async{
    var token = await UserPreferences().getToken();
    var fullurl = BASE_API_URL + apiurl;
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    return response;
  }

  Future deleteCards(data, apiurl) async{
    var token = await UserPreferences().getToken();
    var fullurl = BASE_API_URL + apiurl;
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    log("response ============  ${response.body}");
    log("response ============  ${json.decode(response.body)['message']}");
    return json.decode(response.body);
  }

  Future<List<ShippingData>> getShippingList(apiUrl) async {
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.get(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['shippingData'];
      List<ShippingData> sData = [];
      body.forEach((item) {
        sData.add(new ShippingData(trackingId:item['tracking_id'], receiverName: item['receiver_name'], phoneNumber: item['phone_number'], location: item['location'], status: item['status'] ));
      });
      return sData;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future searchByTracking(data, apiUrl) async {
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        headers: _setHeaders(token:token),
        body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  getPayments(apiUrl) async{
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.get(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  _setHeaders({token}) {
    if (token != null) {
      headers = {
        'content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      log("setheader token $token");
    } else {
      headers = {
        'content-type': 'application/json',
        'Accept': 'application/json'
      };
    }
   return headers;
  }


  Future saveCheckout(data, apiUrl) async{
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future savePayAsYouGo(data, apiUrl) async{
    var result;
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(data),
        headers: _setHeaders(token:token)
    );
    if(response.statusCode == 200){
      result = {
        'status': true,
        'message': "Successfully Delivered Message"
      };
    }else{
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future logout(apiUrl) async{
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    print(token);
    var response = await http.post(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
 
    return response;
  }

  Future deleteAccount(apiUrl) async{
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  getUserAutocomplete(data, apiUrl) async {
    var fullurl = BASE_API_URL + apiUrl;
    var postdata={
      "phone_number":data.toString()
    };
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        body: jsonEncode(postdata),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      final parsed = List<Map<String, dynamic>>.from(convert.jsonDecode(response.body)['users']);
      log("datatatatat =$parsed");

      return parsed.map((user) => User.fromJson(user)).toList();
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  getLoggedInUser(apiUrl) async{
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.get(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
   return response;
  }

  Future<List<ShippingData>> getShippingHistory(apiUrl) async {
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.get(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['shippingData'];
      List<ShippingData> sData = [];
      body.forEach((item) {
        sData.add(new ShippingData(trackingId:item['tracking_id'], receiverName: item['receiver_name'], phoneNumber: item['phone_number'], eTA: item['ETA'], location: item['location'], status: item['status'] ));
      });
      return sData;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  clearHistory(apiUrl) async {
    var fullurl = BASE_API_URL + apiUrl;
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  clearQueue(apiurl) async {
    var fullurl = BASE_API_URL + apiurl;
    var token = await UserPreferences().getToken();
    var response = await http.post(Uri.parse(fullurl),
        headers: _setHeaders(token:token)
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}