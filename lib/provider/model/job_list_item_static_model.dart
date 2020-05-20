import 'package:flutter/cupertino.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_list_item_static_model.g.dart';

@JsonSerializable()
class JobListItemStatic{

  String id;
  var createdAt;
  String company;
  String location;
  String title;
  String companyLogo;
  ProviderType providerType;

  JobListItemStatic({@required this.id});

  factory JobListItemStatic.fromJson(Map<String, dynamic> json) => _$JobListItemStaticFromJson(json);
  Map<String, dynamic> toJson() => _$JobListItemStaticToJson(this);

}