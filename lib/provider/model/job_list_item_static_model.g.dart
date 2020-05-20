// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_list_item_static_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobListItemStatic _$JobListItemStaticFromJson(Map<String, dynamic> json) {
  return JobListItemStatic(
    id: json['id'] as String,
  )
    ..createdAt = json['created_at']
    ..company = json['company'] as String
    ..location = json['location'] as String
    ..title = json['title'] as String
    ..companyLogo = json['company_logo'] as String;
}

Map<String, dynamic> _$JobListItemStaticToJson(JobListItemStatic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'company': instance.company,
      'location': instance.location,
      'title': instance.title,
      'company_logo': instance.companyLogo,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ProviderEnumMap = {
  ProviderType.GITHUB: 'GITHUB',
  ProviderType.STATIC: 'STATIC',
  ProviderType.ALL: 'ALL',
};
