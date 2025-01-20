import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String city);
  Future<Either<Failure, ForecastEntity>> getWeatherForecast(String city);
  Future<Either<Failure, void>> saveTemperatureUnit(String unit);
  Future<Either<Failure, String>> getTemperatureUnit();
}
