import 'package:json_annotation/json_annotation.dart';

part 'job_detail_model.g.dart';

@JsonSerializable()
class JobDetailModel{
  String id;
  String type;
  String companyUrl = "";
  String location;
  String description;
  String howToApply;
  String url;

  JobDetailModel({this.id, this.type, this.companyUrl, this.location, this.description, this.howToApply, this.url});

  factory JobDetailModel.fromJson(Map<String, dynamic> json) => _$JobDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobDetailModelToJson(this);
}