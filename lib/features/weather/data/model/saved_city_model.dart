import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';

part 'saved_city_model.g.dart';

@JsonSerializable()
class SavedCityModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  SavedCityModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory SavedCityModel.fromJson(Map<String, dynamic> json) =>
      _$SavedCityModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedCityModelToJson(this);

  factory SavedCityModel.fromEntity(SavedCity city) => SavedCityModel(
        cityName: city.cityName,
        temperature: city.temperature,
        description: city.description,
        icon: city.icon,
      );

  /// Snapshot built from a fresh remote weather response (write-through cache).
  factory SavedCityModel.fromWeatherModel(WeatherModel model) => SavedCityModel(
        cityName: model.name,
        temperature: model.main.temp,
        description: model.weather.first.description,
        icon: model.weather.first.icon,
      );

  factory SavedCityModel.fromWeatherEntity(WeatherEntity entity) =>
      SavedCityModel(
        cityName: entity.cityName,
        temperature: entity.temperature,
        description: entity.description,
        icon: entity.icon,
      );

  SavedCity toEntity() => SavedCity(
        cityName: cityName,
        temperature: temperature,
        description: description,
        icon: icon,
      );
}
