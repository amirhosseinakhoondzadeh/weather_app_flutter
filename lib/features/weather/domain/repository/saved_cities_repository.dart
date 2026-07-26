import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';

abstract class SavedCitiesRepository {
  /// Loads one page of saved cities. Network-first: refreshes each city's
  /// weather and writes it through to the cache; on a network/server error
  /// the cached page is returned instead so the screen works offline.
  Future<Either<Failure, List<SavedCity>>> getSavedCities({
    required int page,
    required int limit,
  });

  Future<Either<Failure, void>> saveCity(SavedCity city);

  Future<Either<Failure, void>> removeCity(String cityName);
}
