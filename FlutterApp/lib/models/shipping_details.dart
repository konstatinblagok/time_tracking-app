class TrackingDetails {
  ShippingData? shippingData;
  String? message;

  TrackingDetails({this.shippingData, this.message});

  TrackingDetails.fromJson(Map<String, dynamic> json) {
    shippingData = json['shippingData'] != null
        ? new ShippingData.fromJson(json['shippingData'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingData != null) {
      // data['shippingData'] = this.shippingData!.toJson();
    }
    data['message'] = this.message;
    return data;
  }

  @override
  String toString() {
    return 'TrackingDetails{message: $message}';
  }
}

class ShippingData {
  int? senderId;
  int? receiverId;
  String? receiverName;
  String? phoneNumber;
  String? location;
  String? note;
  String? eTA;
  String? trackingId;
  double? longitude;
  double? latitude;
  int? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  ShippingData(
      {this.senderId,
        this.receiverId,
        this.receiverName,
        this.phoneNumber,
        this.location,
        this.note,
        this.eTA,
        this.trackingId,
        this.longitude,
        this.latitude,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id});

  factory ShippingData.fromJson(Map<String, dynamic> json) {
    return new ShippingData(
    senderId :json['sender_id'],
    receiverId : json['receiver_id'],
    receiverName : json['receiver_name'],
    phoneNumber : json['phone_number'],
    location : json['location'],
    note : json['note'],
    eTA : json['ETA'],
    trackingId : json['tracking_id'],
    longitude : json['longitude'],
    latitude : json['latitude'],
    status : json['status'],
    updatedAt : json['updated_at'],
    createdAt : json['created_at'],
    id : json['id']
    );
    }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['receiver_name'] = this.receiverName;
    data['phone_number'] = this.phoneNumber;
    data['location'] = this.location;
    data['note'] = this.note;
    data['ETA'] = this.eTA;
    data['tracking_id'] = this.trackingId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }

  @override
  String toString() {
    return 'ShippingData{senderId: $senderId, receiverId: $receiverId, receiverName: $receiverName, phoneNumber: $phoneNumber, location: $location, note: $note, eTA: $eTA, trackingId: $trackingId, longitude: $longitude, latitude: $latitude, status: $status, updatedAt: $updatedAt, createdAt: $createdAt, id: $id}';
  }
}
