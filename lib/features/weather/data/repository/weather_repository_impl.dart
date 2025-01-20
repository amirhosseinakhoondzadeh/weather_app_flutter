import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/model/forecast_model.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';
import 'package:weather_app_flutter/features/weather/utils/date_time_converter.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String city) async {
    try {
      final temperatureUnit = await localDataSource.getTemperatureUnit();

      final weatherModel = await remoteDataSource.getCurrentWeather(
        city: city,
        unit: temperatureUnit,
      );

      final weatherEntity = WeatherEntity(
        cityName: weatherModel.name,
        temperature: weatherModel.main.temp,
        description: weatherModel.weather.first.description,
        humidity: weatherModel.main.humidity,
        pressure: weatherModel.main.pressure,
        windSpeed: weatherModel.wind.speed,
        icon: weatherModel.weather.first.icon,
        date: DateTimeConverter.fromUnixTimestamp(weatherModel.dt),
        tempMax: weatherModel.main.temp_max,
        tempMin: weatherModel.main.temp_min,
      );

      return Right(weatherEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? ''));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForecastEntity>> getWeatherForecast(
      String city) async {
    try {
      final temperatureUnit = await localDataSource.getTemperatureUnit();
      final forecastModel = await remoteDataSource.getWeatherForecast(
        city: city,
        unit: temperatureUnit,
      );

      // Group forecasts by day and aggregate min/max temperatures
      final Map<DateTime, List<ForecastList>> groupedByDay = {};

      for (final item in forecastModel.list) {
        final day = DateTimeConverter.fromUnixTimestamp(item.dt).toLocal();
        final date =
            DateTime(day.year, day.month, day.day); // Normalize to day level

        if (!groupedByDay.containsKey(date)) {
          groupedByDay[date] = [];
        }

        groupedByDay[date]?.add(item);
      }

      // Aggregate data for each day
      final aggregatedForecasts = groupedByDay.entries.map((entry) {
        final date = entry.key;
        final forecasts = entry.value;

        final minTemperature = forecasts
            .map((f) => f.main.temp_min)
            .reduce((a, b) => a < b ? a : b);
        final maxTemperature = forecasts
            .map((f) => f.main.temp_max)
            .reduce((a, b) => a > b ? a : b);
        final description = forecasts.first.weather.first.description;
        final icon = forecasts.first.weather.first.icon;
        final temperature = forecasts.first.main.temp;
        final humidity = forecasts.first.main.humidity;
        final pressure = forecasts.first.main.pressure;
        final windSpeed = forecasts.first.wind.speed;

        return WeatherEntity(
          date: date,
          description: description,
          icon: icon,
          tempMax: maxTemperature,
          tempMin: minTemperature,
          temperature: temperature,
          humidity: humidity,
          pressure: pressure,
          windSpeed: windSpeed,
          cityName: forecastModel.city.name,
        );
      }).toList();

      // Create a ForecastEntity
      final forecastEntity = ForecastEntity(
        cityName: forecastModel.city.name,
        forecastDays: aggregatedForecasts,
      );

      return Right(forecastEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? ''));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTemperatureUnit(String unit) async {
    try {
      await localDataSource.saveTemperatureUnit(unit);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTemperatureUnit() async {
    try {
      final unit = await localDataSource.getTemperatureUnit();
      return Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
