import 'package:flutter/cupertino.dart';
import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'placesapi_response_model.g.dart';

@JsonSerializable()
class PlacesApiResponse{
  String error_message;
  List<Place> predictions;
  String status;

  PlacesApiResponse({
    @required this.status,
    this.predictions,
    this.error_message
  });

  factory PlacesApiResponse.fromJson
      (Map<String, dynamic> json) => _$PlacesApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesApiResponseToJson(this);
}