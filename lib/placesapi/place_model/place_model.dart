import 'package:flutter/cupertino.dart';
import 'package:jobfinder/placesapi/geometry_model/location_model.dart';
import 'package:jobfinder/placesapi/place_model/structured_formatting_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_model.g.dart';

@JsonSerializable()
class Place{

  final String placeId;
  final String description;
  StructuredFormatting structuredFormatting;
  Location location;

  Place({
    @required this.placeId,
    @required this.description,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

}