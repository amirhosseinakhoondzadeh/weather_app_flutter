import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/data/model/saved_city_model.dart';
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart';
import 'package:weather_app_flutter/features/weather/data/repository/saved_cities_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late SavedCitiesRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemote;
  late MockSavedCitiesLocalDataSource mockSavedCitiesLocal;
  late MockWeatherLocalDataSource mockWeatherLocal;

  setUp(() {
    mockRemote = MockWeatherRemoteDataSource();
    mockSavedCitiesLocal = MockSavedCitiesLocalDataSource();
    mockWeatherLocal = MockWeatherLocalDataSource();

    repository = SavedCitiesRepositoryImpl(
      remoteDataSource: mockRemote,
      savedCitiesLocalDataSource: mockSavedCitiesLocal,
      weatherLocalDataSource: mockWeatherLocal,
    );
  });

  final cached = SavedCityModel(
    cityName: 'Berlin',
    temperature: 10.0,
    description: 'cached clouds',
    icon: '04d',
  );

  group('getSavedCities', () {
    test(
        'returns the cached page (Right) and writes through when the network refreshes',
        () async {
      final weatherModel =
          WeatherModel.fromJson(json.decode(fixture('current_weather.json')));

      when(mockSavedCitiesLocal.getSavedCities(page: 0, limit: 10))
          .thenAnswer((_) async => [cached]);
      when(mockWeatherLocal.getTemperatureUnit())
          .thenAnswer((_) async => 'metric');
      when(mockRemote.getCurrentWeather(city: 'Berlin', unit: 'metric'))
          .thenAnswer((_) async => weatherModel);
      when(mockSavedCitiesLocal.cacheCities(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.getSavedCities(page: 0, limit: 10);

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => []),
        const [
          SavedCity(
            cityName: 'Berlin',
            temperature: 34.66,
            description: 'clear sky',
            icon: '01n',
          ),
        ],
      );
      // Fresh weather is persisted before being served.
      verify(mockSavedCitiesLocal.cacheCities(any)).called(1);
    });

    test(
        'offline: when remote throws NetworkException, returns cached data as Right',
        () async {
      when(mockSavedCitiesLocal.getSavedCities(page: 0, limit: 10))
          .thenAnswer((_) async => [cached]);
      when(mockWeatherLocal.getTemperatureUnit())
          .thenAnswer((_) async => 'metric');
      when(mockRemote.getCurrentWeather(city: 'Berlin', unit: 'metric'))
          .thenThrow(const NetworkException(message: 'offline'));

      final result = await repository.getSavedCities(page: 0, limit: 10);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [cached.toEntity()]);
      verifyNever(mockSavedCitiesLocal.cacheCities(any));
    });

    test('offline: when remote throws ServerException, returns cached data',
        () async {
      when(mockSavedCitiesLocal.getSavedCities(page: 0, limit: 10))
          .thenAnswer((_) async => [cached]);
      when(mockWeatherLocal.getTemperatureUnit())
          .thenAnswer((_) async => 'metric');
      when(mockRemote.getCurrentWeather(city: 'Berlin', unit: 'metric'))
          .thenThrow(const ServerException(message: 'down'));

      final result = await repository.getSavedCities(page: 0, limit: 10);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [cached.toEntity()]);
    });

    test('returns empty Right without touching the network when no cities saved',
        () async {
      when(mockSavedCitiesLocal.getSavedCities(page: 0, limit: 10))
          .thenAnswer((_) async => []);

      final result = await repository.getSavedCities(page: 0, limit: 10);

      expect(result, const Right<Failure, List<SavedCity>>([]));
      verifyNever(mockRemote.getCurrentWeather(
          city: anyNamed('city'), unit: anyNamed('unit')));
    });

    test('maps CacheException to CacheFailure', () async {
      when(mockSavedCitiesLocal.getSavedCities(page: 0, limit: 10))
          .thenThrow(const CacheException(message: 'bad cache'));

      final result = await repository.getSavedCities(page: 0, limit: 10);

      expect(result, const Left(CacheFailure('bad cache')));
    });
  });
}
