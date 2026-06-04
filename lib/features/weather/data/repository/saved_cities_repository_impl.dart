import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/saved_cities_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/model/saved_city_model.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class SavedCitiesRepositoryImpl implements SavedCitiesRepository {
  final SavedCitiesLocalDataSource localDataSource;

  SavedCitiesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveCity(SavedCityEntity city) async {
    try {
      await localDataSource.saveCity(SavedCityModel.fromEntity(city));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedCity(String cityName) async {
    try {
      await localDataSource.deleteSavedCity(cityName);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedCityEntity>>> getSavedCities({
    required int offset,
    required int limit,
  }) async {
    try {
      final cities = await localDataSource.getSavedCities(
        offset: offset,
        limit: limit,
      );
      return Right(cities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
