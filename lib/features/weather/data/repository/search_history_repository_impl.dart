import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/search_history_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/model/search_history_entry_model.dart';
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final SearchHistoryLocalDataSource searchHistoryLocalDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;

  SearchHistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.searchHistoryLocalDataSource,
    required this.weatherLocalDataSource,
  });

  @override
  Future<Either<Failure, List<SearchHistoryEntry>>> getSearchHistory({
    required int page,
    required int limit,
  }) async {
    try {
      final cached = await searchHistoryLocalDataSource.getSearchHistory(
        page: page,
        limit: limit,
      );

      if (cached.isEmpty) {
        return const Right([]);
      }

      try {
        final unit = await weatherLocalDataSource.getTemperatureUnit();

        // Network-first: refresh each entry, reusing one response per city so a
        // page with repeat searches doesn't make redundant calls. Each entry
        // keeps its own search time.
        final weatherByCity = <String, WeatherModel>{};
        final refreshed = <SearchHistoryEntryModel>[];
        for (final entry in cached) {
          var weather = weatherByCity[entry.cityName];
          if (weather == null) {
            weather = await remoteDataSource.getCurrentWeather(
              city: entry.cityName,
              unit: unit,
            );
            weatherByCity[entry.cityName] = weather;
          }
          refreshed.add(SearchHistoryEntryModel.fromWeatherModel(
            weather,
            searchedAt: entry.searchedAt,
          ));
        }

        // Write fresh weather through to the cache, then serve it.
        await searchHistoryLocalDataSource.cacheEntries(refreshed);
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
  Future<Either<Failure, void>> recordSearch(SearchHistoryEntry entry) async {
    try {
      await searchHistoryLocalDataSource.recordSearch(
        SearchHistoryEntryModel.fromEntity(entry),
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? ''));
    }
  }
}
