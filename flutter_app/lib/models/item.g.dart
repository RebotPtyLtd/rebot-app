// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  id: _toInt(json['id']),
  title: json['title'] as String,
  description: json['description'] as String,
  createdBy: (json['createdBy'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String?,
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'id': _identity(instance.id),
  'title': instance.title,
  'description': instance.description,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'comments': instance.comments.map((e) => e.toJson()).toList(),
};
