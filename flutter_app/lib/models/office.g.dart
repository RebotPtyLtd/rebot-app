// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Office _$OfficeFromJson(Map<String, dynamic> json) => Office(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String,
  settings: OfficeSettings.fromJson(json['settings'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$OfficeToJson(Office instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'settings': instance.settings.toJson(),
  'items': instance.items.map((e) => e.toJson()).toList(),
};

OfficeSettings _$OfficeSettingsFromJson(Map<String, dynamic> json) =>
    OfficeSettings(
      maxItemsPerUser: (json['maxItemsPerUser'] as num).toInt(),
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$OfficeSettingsToJson(OfficeSettings instance) =>
    <String, dynamic>{
      'maxItemsPerUser': instance.maxItemsPerUser,
      'timezone': instance.timezone,
    };
