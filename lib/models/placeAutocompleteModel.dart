// To parse this JSON data, do

//

//     final placeAutocompleteModel = placeAutocompleteModelFromJson(jsonString);


import 'dart:convert';


List<PlaceAutocompleteModel> placeAutocompleteModelFromJson(String str) =>
    List<PlaceAutocompleteModel>.from(json.decode(str).map((x) => PlaceAutocompleteModel.fromJson(x)));


String placeAutocompleteModelToJson(List<PlaceAutocompleteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class PlaceAutocompleteModel {
  int placeId;
  String licence;
  String osmType;
  int osmId;
  String lat;
  String lon;
  String category;
  String type;
  int placeRank;
  double importance;
  String addresstype;
  String name;
  String displayName;
  List<String> boundingbox;

  PlaceAutocompleteModel({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.category,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addresstype,
    required this.name,
    required this.displayName,
    required this.boundingbox,
  });

  factory PlaceAutocompleteModel.fromJson(Map<String, dynamic> json) => PlaceAutocompleteModel(

        placeId: json["place_id"],

        licence: json["licence"],

        osmType: json["osm_type"],

        osmId: json["osm_id"],

        lat: json["lat"],

        lon: json["lon"],

        category: json["category"],

        type: json["type"],

        placeRank: json["place_rank"],

        importance: json["importance"]?.toDouble(),

        addresstype: json["addresstype"],

        name: json["name"],

        displayName: json["display_name"],

        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {

        "place_id": placeId,

        "licence": licence,

        "osm_type": osmType,

        "osm_id": osmId,

        "lat": lat,

        "lon": lon,

        "category": category,

        "type": type,

        "place_rank": placeRank,

        "importance": importance,

        "addresstype": addresstype,

        "name": name,

        "display_name": displayName,

        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
      };

}

