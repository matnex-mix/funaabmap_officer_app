// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artifact _$ArtifactFromJson(Map<String, dynamic> json) => Artifact(
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      createdBy: json['created_by'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      createdAt: assignDateTime(json, 'created_at') == null
          ? null
          : DateTime.parse(assignDateTime(json, 'created_at') as String),
      id: objectIdToString(json, '_id') as String?,
      medias: (json['medias'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ArtifactToJson(Artifact instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'title': instance.title,
    'type': instance.type,
    'description': instance.description,
    'created_by': instance.createdBy,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('width', instance.width);
  writeNotNull('length', instance.length);
  val['lat'] = instance.lat;
  val['lng'] = instance.lng;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  val['medias'] = instance.medias;
  return val;
}
