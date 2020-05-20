// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDetailModel _$JobDetailModelFromJson(Map<String, dynamic> json) {
  return JobDetailModel(
    id: json['id'] as String,
    type: json['type'] as String,
    companyUrl: json['company_url'] as String,
    location: json['location'] as String,
    description: json['description'] as String,
    howToApply: json['how_to_apply'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$JobDetailModelToJson(JobDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'company_url': instance.companyUrl,
      'location': instance.location,
      'description': instance.description,
      'how_to_apply': instance.howToApply,
      'url': instance.url,
    };
