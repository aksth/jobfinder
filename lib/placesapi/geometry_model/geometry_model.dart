import 'location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geometry_model.g.dart';

@JsonSerializable()
class Geometry{

  Location location;

  Geometry(this.location);

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}