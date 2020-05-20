// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    placeId: json['place_id'] as String,
    description: json['description'] as String,
  )
    ..structuredFormatting = json['structured_formatting'] == null
        ? null
        : StructuredFormatting.fromJson(
            json['structured_formatting'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'place_id': instance.placeId,
      'description': instance.description,
      'structured_formatting': instance.structuredFormatting,
    };
