import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'artifact.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Artifact {

  @JsonKey(name: '_id', readValue: objectIdToString)
  String? id;
  String title, type, description, createdBy;

  @JsonKey(includeIfNull: false)
  double? width, length;
  double lat, lng;

  @JsonKey(readValue: assignDateTime, includeIfNull: false)
  DateTime? createdAt;

  List<String> medias;

  Artifact({required this.title, required this.type, required this.description, required this.createdBy, required this.lat, required this.lng, this.width, this.length, this.createdAt, this.id, this.medias = const[]});

  factory Artifact.fromJson(Map<String, dynamic> json) => _$ArtifactFromJson(json);

  Map<String, dynamic> toJson() => _$ArtifactToJson(this);
}
