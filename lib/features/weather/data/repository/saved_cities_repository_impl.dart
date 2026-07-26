import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/saved_cities_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/model/saved_city_model.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class SavedCitiesRepositoryImpl implements SavedCitiesRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final SavedCitiesLocalDataSource savedCitiesLocalDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;

  SavedCitiesRepositoryImpl({
    required this.remoteDataSource,
    required this.savedCitiesLocalDataSource,
    required this.weatherLocalDataSource,
  });

  @override
  Future<Either<Failure, List<SavedCity>>> getSavedCities({
    required int page,
    required int limit,
  }) async {
    try {
      final cached = await savedCitiesLocalDataSource.getSavedCities(
        page: page,
        limit: limit,
      );

      if (cached.isEmpty) {
        return const Right([]);
      }

      try {
        final unit = await weatherLocalDataSource.getTemperatureUnit();

        final refreshed = <SavedCityModel>[];
        for (final city in cached) {
          final weatherModel = await remoteDataSource.getCurrentWeather(
            city: city.cityName,
            unit: unit,
          );
          refreshed.add(SavedCityModel.fromWeatherModel(weatherModel));
        }

        // Write fresh weather through to the cache, then serve it.
        await savedCitiesLocalDataSource.cacheCities(refreshed);
        return Right(refreshed.map((m) => m.toEntity()).toList());
      } on ServerException {
        return Right(cached.map((m) => m.toEntity()).toList());
      } on NetworkException {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> saveCity(SavedCity city) async {
    try {
      await savedCitiesLocalDataSource.saveCity(
        SavedCityModel.fromEntity(city),
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> removeCity(String cityName) async {
    try {
      await savedCitiesLocalDataSource.removeCity(cityName);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    }
  }
}
