import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late GetTemperatureUnitUsecase usecase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    usecase = GetTemperatureUnitUsecase(repository: mockRepository);
  });

  const tUnit = 'metric'; // Expected temperature unit

  test('should get the temperature unit from the repository', () async {
    // Arrange
    when(mockRepository.getTemperatureUnit())
        .thenAnswer((_) async => const Right(tUnit));

    // Act
    final result = await usecase(NoParams());

    // Assert
    verify(mockRepository.getTemperatureUnit()).called(1);
    expect(result, const Right(tUnit));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a failure when repository call fails', () async {
    // Arrange
    when(mockRepository.getTemperatureUnit())
        .thenAnswer((_) async => Left(CacheFailure('')));

    // Act
    final result = await usecase(NoParams());

    // Assert
    verify(mockRepository.getTemperatureUnit()).called(1);
    expect(result, Left(CacheFailure('')));
    verifyNoMoreInteractions(mockRepository);
  });
}
