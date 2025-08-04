// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  id: (json['id'] as num).toInt(),
  itemId: (json['itemId'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  content: json['content'] as String,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'id': instance.id,
  'itemId': instance.itemId,
  'userId': instance.userId,
  'content': instance.content,
  'createdAt': instance.createdAt,
};
