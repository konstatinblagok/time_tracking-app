import 'package:flutter/foundation.dart';
import 'package:timetrack/models/tracking_codes.dart';


class TrackingCodesProvider with ChangeNotifier {
  TrackingCodes _trackingCodes = new TrackingCodes();

  TrackingCodes get trackingCodes => _trackingCodes;

  void setTrackingCodes(TrackingCodes trackingCodes) {
    _trackingCodes = trackingCodes;
    notifyListeners();
  }

}