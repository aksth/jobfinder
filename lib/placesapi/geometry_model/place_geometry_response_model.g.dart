// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_geometry_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceGeometryResponse _$PlaceGeometryResponseFromJson(
    Map<String, dynamic> json) {
  return PlaceGeometryResponse(
    json['status'] as String,
    json['result'] == null
        ? null
        : Result.fromJson(json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlaceGeometryResponseToJson(
        PlaceGeometryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };
