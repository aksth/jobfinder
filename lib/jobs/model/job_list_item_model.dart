import 'package:flutter/cupertino.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_list_item_model.g.dart';

@JsonSerializable()
class JobListItem{

  String id;
  var createdAt;
  String company;
  String location;
  String title;
  String companyLogo;
  String url;
  ProviderType providerType;
  DateTime createdAtDateTime;
  String createdAtTimeAgo;

  JobListItem({@required this.id, this.createdAt, this.company,
    this.location, this.title, this.companyLogo, this.url, this.providerType
  });

  factory JobListItem.fromJson(Map<String, dynamic> json) => _$JobListItemFromJson(json);
  Map<String, dynamic> toJson() => _$JobListItemToJson(this);

}