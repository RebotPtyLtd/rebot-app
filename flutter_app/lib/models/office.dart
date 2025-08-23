import 'package:json_annotation/json_annotation.dart';
import 'package:rebot_flutter_app/models/item.dart';

part 'office.g.dart';

@JsonSerializable(explicitToJson: true)
class Office {
  final int id;
  final String name;
  final String address;
  final OfficeSettings settings;

  @JsonKey(defaultValue: [])
  final List<Item> items;

  Office({
    required this.id,
    required this.name,
    required this.address,
    required this.settings,
    this.items = const [],
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}

@JsonSerializable()
class OfficeSettings {
  final int maxItemsPerUser;
  final String timezone;

  OfficeSettings({required this.maxItemsPerUser, required this.timezone});

  factory OfficeSettings.fromJson(Map<String, dynamic> json) =>
      _$OfficeSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeSettingsToJson(this);
}
