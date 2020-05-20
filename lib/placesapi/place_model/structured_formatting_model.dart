import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'structured_formatting_model.g.dart';

@JsonSerializable()
class StructuredFormatting{
  String mainText;

  StructuredFormatting(this.mainText);

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) => _$StructuredFormattingFromJson(json);
  Map<String, dynamic> toJson() => _$StructuredFormattingToJson(this);
}