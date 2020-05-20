// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placesapi_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacesApiResponse _$PlacesApiResponseFromJson(Map<String, dynamic> json) {
  return PlacesApiResponse(
    status: json['status'] as String,
    predictions: (json['predictions'] as List)
        ?.map(
            (e) => e == null ? null : Place.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    error_message: json['error_message'] as String,
  );
}

Map<String, dynamic> _$PlacesApiResponseToJson(PlacesApiResponse instance) =>
    <String, dynamic>{
      'error_message': instance.error_message,
      'predictions': instance.predictions,
      'status': instance.status,
    };
