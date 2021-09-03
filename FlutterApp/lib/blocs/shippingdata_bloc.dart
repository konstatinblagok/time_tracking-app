import 'package:flutter/foundation.dart';
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/services/auth_service.dart';
import 'dart:convert';

class ShippingDetailsProvider with ChangeNotifier {
  ShippingData _trackingDetails = new ShippingData();
  final authService = AuthService();
  String? _trackingId;
  String? _screen;

  var response;

  ShippingData get trackingDetails => _trackingDetails;
  String? get trackingId => _trackingId;
  String? get screen => _screen;

  void setShippingData(ShippingData trackingDetails) {
    _trackingDetails = trackingDetails;
    notifyListeners();
  }

  void setTrackingId(String trackingID) {
    _trackingId = trackingID;
    notifyListeners();
  }

  void setScreen(String screen) {
    _screen = screen;
    notifyListeners();
  }

  Future<Map<String, dynamic>> searchByTracking(data, apiurl) async{
    var result;
    response = await authService.searchByTracking(data, apiurl);
    notifyListeners();

    if (response.statusCode == 200) {
      final trackingDetails = (json.decode(response.body)['shippingData']);
      ShippingData shippingData = ShippingData(id: trackingDetails['id'], receiverName: trackingDetails['receiver_name'],
        phoneNumber: trackingDetails['phone_number'], note: trackingDetails['note'], latitude: double.parse(trackingDetails['latitude']),
        longitude: double.parse(trackingDetails['longitude']), trackingId: trackingDetails['tracking_id'],
        eTA: trackingDetails['ETA']
      );
      this.setShippingData(shippingData);
      result = {'status': true, 'message': 'Successful', 'trackingDetails': shippingData};
      notifyListeners();
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }
}