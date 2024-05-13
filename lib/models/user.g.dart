// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['username'] as String,
      json['full_name'] as String,
    )
      ..id = objectIdToString(json, '_id') as String?
      ..lastLogin = assignDateTime(json, 'last_login') == null
          ? null
          : DateTime.parse(assignDateTime(json, 'last_login') as String)
      ..createdAt = assignDateTime(json, 'created_at') == null
          ? null
          : DateTime.parse(assignDateTime(json, 'created_at') as String);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'full_name': instance.fullName,
      'last_login': instance.lastLogin?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
