import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';

import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late GetCurrentWeatherUsecase usecase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherUsecase(repository: mockRepository);
  });

  const tCity = 'Berlin';
  final tWeatherEntity = WeatherEntity(
    cityName: 'Berlin',
    temperature: 25.0,
    description: 'clear sky',
    humidity: 50,
    pressure: 1015,
    windSpeed: 5.0,
    icon: '',
    date: DateTime(2025, 1, 19),
    tempMax: 100,
    tempMin: 0,
  );

  test('should get current weather for the city from the repository', () async {
    // Arrange
    when(mockRepository.getCurrentWeather(tCity))
        .thenAnswer((_) async => Right(tWeatherEntity));

    // Act
    final result = await usecase(tCity);

    // Assert
    verify(mockRepository.getCurrentWeather(tCity)).called(1);
    expect(result, Right(tWeatherEntity));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a failure when repository call fails', () async {
    // Arrange
    when(mockRepository.getCurrentWeather(tCity))
        .thenAnswer((_) async => Left(ServerFailure('')));

    // Act
    final result = await usecase(tCity);

    // Assert
    verify(mockRepository.getCurrentWeather(tCity)).called(1);
    expect(result, Left(ServerFailure('')));
    verifyNoMoreInteractions(mockRepository);
  });
}
