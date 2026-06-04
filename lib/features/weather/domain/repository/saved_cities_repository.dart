import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';

abstract class SavedCitiesRepository {
  /// Saves [city], replacing any previously saved entry with the same name.
  Future<Either<Failure, void>> saveCity(SavedCityEntity city);

  /// Removes the saved city with the given [cityName].
  Future<Either<Failure, void>> deleteSavedCity(String cityName);

  /// Returns a page of saved cities, newest first, starting at [offset] and
  /// containing at most [limit] entries. Reads from local storage only, so it
  /// succeeds with no network connection.
  Future<Either<Failure, List<SavedCityEntity>>> getSavedCities({
    required int offset,
    required int limit,
  });
}
