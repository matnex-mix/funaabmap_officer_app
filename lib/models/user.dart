import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {

  @JsonKey(name: '_id', readValue: objectIdToString)
  String? id;

  String username, fullName;

  @JsonKey(readValue: assignDateTime)
  DateTime? lastLogin, createdAt;

  User(this.username, this.fullName);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}