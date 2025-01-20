import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';

class ForecastEntity {
  final String cityName;
  final List<WeatherEntity> forecastDays;

  ForecastEntity({
    required this.cityName,
    required this.forecastDays,
  });
}
