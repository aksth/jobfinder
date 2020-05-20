import 'package:jobfinder/placesapi/geometry_model/result_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_geometry_response_model.g.dart';

@JsonSerializable()
class PlaceGeometryResponse{

  String status;
  Result result;

  PlaceGeometryResponse(this.status, this.result);

  factory PlaceGeometryResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceGeometryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceGeometryResponseToJson(this);
}