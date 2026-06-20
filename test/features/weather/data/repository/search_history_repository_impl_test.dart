import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/data/model/search_history_entry_model.dart';
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart';
import 'package:weather_app_flutter/features/weather/data/repository/search_history_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late SearchHistoryRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemote;
  late MockSearchHistoryLocalDataSource mockSearchHistoryLocal;
  late MockWeatherLocalDataSource mockWeatherLocal;

  setUp(() {
    mockRemote = MockWeatherRemoteDataSource();
    mockSearchHistoryLocal = MockSearchHistoryLocalDataSource();
    mockWeatherLocal = MockWeatherLocalDataSource();

    repository = SearchHistoryRepositoryImpl(
      remoteDataSource: mockRemote,
      searchHistoryLocalDataSource: mockSearchHistoryLocal,
      weatherLocalDataSource: mockWeatherLocal,
    );
  });

  final searchedAt = DateTime.fromMillisecondsSinceEpoch(1700000000000);
  final cached = SearchHistoryEntryModel(
    cityName: 'Berlin',
    temperature: 10.0,
    description: 'cached clouds',
    icon: '04d',
    searchedAt: searchedAt,
  );

  group('getSearchHistory', () {
    test(
        'returns the refreshed page (Right) and writes through when the network refreshes',
        () async {
      final weatherModel =
          WeatherModel.fromJson(json.decode(fixture('current_weather.json')));

      when(mockSearchHistoryLocal.getSearchHistory(page: 0, limit: 10))
          .thenAnswer((_) async => [cached]);
      when(mockWeatherLocal.getTemperatureUnit())
          .thenAnswer((_) async => 'metric');
      when(mockRemote.getCurrentWeather(city: 'Berlin', unit: 'metric'))
          .thenAnswer((_) async => weatherModel);
      when(mockSearchHistoryLocal.cacheEntries(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.getSearchHistory(page: 0, limit: 10);

      expect(result.isRight(), isTrue);
      // Fresh weather, but the original search time is preserved.
      expect(
        result.getOrElse(() => []),
        [
          SearchHistoryEntry(
            cityName: 'Berlin',
            temperature: 34.66,
            description: 'clear sky',
            icon: '01n',
            searchedAt: searchedAt,
          ),
        ],
      );
      // Fresh weather is persisted before being served.
      verify(mockSearchHistoryLocal.cacheEntries(any)).called(1);
    });

    test(
        'offline: when remote throws NetworkException, returns cached data as Right',
        () async {
      when(mockSearchHistoryLocal.getSearchHistory(page: 0, limit: 10))
          .thenAnswer((_) async => [cached]);
      when(mockWeatherLocal.getTemperatureUnit())
          .thenAnswer((_) async => 'metric');
      when(mockRemote.getCurrentWeather(city: 'Berlin', unit: 'metric'))
          .thenThrow(const NetworkException(message: 'offline'));

      final result = await repository.getSearchHistory(page: 0, limit: 10);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [cached.toEntity()]);
      verifyNever(mockSearchHistoryLocal.cacheEntries(any));
    });

    test('offline: when remote throws ServerException, returns cached data',
        () async {
      when(mockSearchHistoryLocal.getSearchHistory(page: 0, limit: 10))
          .thenAnswer((_) async => [cached]);
      when(mockWeatherLocal.getTemperatureUnit())
          .thenAnswer((_) async => 'metric');
      when(mockRemote.getCurrentWeather(city: 'Berlin', unit: 'metric'))
          .thenThrow(const ServerException(message: 'down'));

      final result = await repository.getSearchHistory(page: 0, limit: 10);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [cached.toEntity()]);
    });

    test(
        'returns empty Right without touching the network when no history exists',
        () async {
      when(mockSearchHistoryLocal.getSearchHistory(page: 0, limit: 10))
          .thenAnswer((_) async => []);

      final result = await repository.getSearchHistory(page: 0, limit: 10);

      expect(result, const Right<Failure, List<SearchHistoryEntry>>([]));
      verifyNever(mockRemote.getCurrentWeather(
          city: anyNamed('city'), unit: anyNamed('unit')));
    });

    test('maps CacheException to CacheFailure', () async {
      when(mockSearchHistoryLocal.getSearchHistory(page: 0, limit: 10))
          .thenThrow(const CacheException(message: 'bad cache'));

      final result = await repository.getSearchHistory(page: 0, limit: 10);

      expect(result, const Left(CacheFailure('bad cache')));
    });
  });

  group('recordSearch', () {
    test('persists the entry and returns Right', () async {
      when(mockSearchHistoryLocal.recordSearch(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.recordSearch(cached.toEntity());

      expect(result, const Right<Failure, void>(null));
      verify(mockSearchHistoryLocal.recordSearch(any)).called(1);
    });

    test('maps CacheException to CacheFailure', () async {
      when(mockSearchHistoryLocal.recordSearch(any))
          .thenThrow(const CacheException(message: 'disk full'));

      final result = await repository.recordSearch(cached.toEntity());

      expect(result, const Left(CacheFailure('disk full')));
    });
  });
}
