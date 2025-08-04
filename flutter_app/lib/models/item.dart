import 'package:json_annotation/json_annotation.dart';
import 'comment.dart';

part 'item.g.dart';

/// Converts either an int **or** a numeric string to int.
int _toInt(dynamic v) => v is int ? v : int.parse(v as String);

/// Pass-through for `toJson` so we still emit a number.
dynamic _identity(dynamic v) => v;

@JsonSerializable(explicitToJson: true)
class Item {
  @JsonKey(fromJson: _toInt, toJson: _identity)
  final int id;
  final String title;
  final String description;
  final int createdBy;
  final String createdAt;
  final String? updatedAt;

  @JsonKey(defaultValue: [])
  final List<Comment> comments;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.comments = const [],
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
