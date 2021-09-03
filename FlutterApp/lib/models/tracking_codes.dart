class TrackingCodes {
  int? price;
  int? no_tracking_codes;
  String? message;
  bool? isPayAsYouGo;

  TrackingCodes({this.price, this.no_tracking_codes, this.message, this.isPayAsYouGo});

  TrackingCodes.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    no_tracking_codes = json['no_tracking_codes'];
    message = json['isSelected'];
    isPayAsYouGo = json['isPayAsYouGo'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['price'] = (this.price);
  //   data['no_tracking_codes'] = this.no_tracking_codes;
  //   data['message'] = this.message;
  //   return data;
  // }
}

