// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_list_item_github_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobListItemGithub _$JobListItemGithubFromJson(Map<String, dynamic> json) {
  return JobListItemGithub(
    id: json['id'] as String,
  )
    ..createdAt = json['created_at']
    ..company = json['company'] as String
    ..location = json['location'] as String
    ..title = json['title'] as String
    ..companyLogo = json['company_logo'] as String
    ..url = json['url'] as String
    ..providerType = _$enumDecodeNullable(_$ProviderEnumMap, json['provider']);
}

Map<String, dynamic> _$JobListItemGithubToJson(JobListItemGithub instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'company': instance.company,
      'location': instance.location,
      'title': instance.title,
      'company_logo': instance.companyLogo,
      'url': instance.url,
      'provider': _$ProviderEnumMap[instance.providerType],
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
