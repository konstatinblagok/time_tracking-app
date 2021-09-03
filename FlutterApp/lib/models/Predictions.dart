class Predictions {
  final String description;
  final String placeId;
  final String reference;


  Predictions(
      {required this.description,
        required this.placeId,
        required this.reference});

  factory Predictions.fromJson(Map<String, dynamic> json) => Predictions(description:json['description'],placeId:json['place_id'],reference:json['reference']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    return data;
  }
}

