class CardDetails {
  String? card_no;
  int? expiry_month;
  int? expiry_year;
  int? cvv;

  CardDetails({this.card_no, this.expiry_month, this.expiry_year, this.cvv});

  CardDetails.fromJson(Map<String, dynamic> json) {
    card_no = json['card_no'];
    expiry_month = json['expiry_month'];
    expiry_year = json['expiry_year'];
    cvv = json['cvv'];
  }

  @override
  String toString() {
    return 'CardDetails{card_no: $card_no, expiry_month: $expiry_month, expiry_year: $expiry_year, cvv: $cvv}';
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['price'] = (this.price);
//   data['no_tracking_codes'] = this.no_tracking_codes;
//   data['message'] = this.message;
//   return data;
// }
}

