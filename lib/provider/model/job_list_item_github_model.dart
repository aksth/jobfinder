import 'package:flutter/cupertino.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_list_item_github_model.g.dart';

@JsonSerializable()
class JobListItemGithub{

  String id;
  var createdAt;
  String company;
  String location;
  String title;
  String companyLogo;
  String url;
  ProviderType providerType;

  JobListItemGithub({@required this.id});

  factory JobListItemGithub.fromJson(Map<String, dynamic> json) => _$JobListItemGithubFromJson(json);
  Map<String, dynamic> toJson() => _$JobListItemGithubToJson(this);

}