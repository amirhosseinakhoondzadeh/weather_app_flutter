// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedCityModel _$SavedCityModelFromJson(Map<String, dynamic> json) =>
    SavedCityModel(
      cityName: json['cityName'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$SavedCityModelToJson(SavedCityModel instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'temperature': instance.temperature,
      'description': instance.description,
      'icon': instance.icon,
    };
