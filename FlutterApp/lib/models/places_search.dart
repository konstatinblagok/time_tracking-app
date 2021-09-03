class PlacesSearch{
   final String description;
   final String placeId;

  PlacesSearch({required this.description, required this.placeId});

  factory PlacesSearch.fromJson(Map<String, dynamic> json){
    return PlacesSearch(description: json['description']??'', placeId: json['placeId']??'');
  }

}