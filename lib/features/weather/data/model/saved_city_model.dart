import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';

class SavedCityModel extends SavedCityEntity {
  const SavedCityModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.icon,
    required super.unitSymbol,
  });

  factory SavedCityModel.fromEntity(SavedCityEntity entity) => SavedCityModel(
        cityName: entity.cityName,
        temperature: entity.temperature,
        description: entity.description,
        icon: entity.icon,
        unitSymbol: entity.unitSymbol,
      );

  factory SavedCityModel.fromJson(Map<String, dynamic> json) => SavedCityModel(
        cityName: json['cityName'] as String,
        temperature: (json['temperature'] as num).toDouble(),
        description: json['description'] as String,
        icon: json['icon'] as String,
        unitSymbol: json['unitSymbol'] as String,
      );

  Map<String, dynamic> toJson() => {
        'cityName': cityName,
        'temperature': temperature,
        'description': description,
        'icon': icon,
        'unitSymbol': unitSymbol,
      };
}
