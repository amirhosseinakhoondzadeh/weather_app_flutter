import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';

import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late WeatherBloc weatherBloc;
  late MockGetCurrentWeatherUsecase mockGetCurrentWeatherUsecase;
  late MockGetTemperatureUnitUsecase mockGetTemperatureUnitUsecase;
  late MockGetWeatherForecastUsecase mockGetWeatherForecastUsecase;
  late MockSaveTemperatureUnitUsecase mockSaveTemperatureUnitUsecase;

  const tCity = 'Berlin';
  final tWeatherEntity = WeatherEntity(
    cityName: tCity,
    temperature: 25.0,
    description: 'clear sky',
    humidity: 50,
    pressure: 1015,
    windSpeed: 5.0,
    date: DateTime(2025, 1, 19),
    icon: '',
    tempMax: 100,
    tempMin: 0,
  );
  final tForecastEntity = ForecastEntity(
    cityName: tCity,
    forecastDays: [],
  );

  setUp(() {
    mockGetCurrentWeatherUsecase = MockGetCurrentWeatherUsecase();
    mockGetTemperatureUnitUsecase = MockGetTemperatureUnitUsecase();
    mockGetWeatherForecastUsecase = MockGetWeatherForecastUsecase();
    mockSaveTemperatureUnitUsecase = MockSaveTemperatureUnitUsecase();

    weatherBloc = WeatherBloc(
      getCurrentWeatherUsecase: mockGetCurrentWeatherUsecase,
      getTemperatureUnitUsecase: mockGetTemperatureUnitUsecase,
      getWeatherForecastUsecase: mockGetWeatherForecastUsecase,
      saveTemperatureUnitUsecase: mockSaveTemperatureUnitUsecase,
    );
  });

  tearDown(() {
    weatherBloc.close();
  });

  group('WeatherBloc', () {
    test('initial state is WeatherState', () {
      expect(weatherBloc.state, const WeatherState());
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits [loading, loaded] when WeatherInitiatedEvent is added and unit is fetched successfully',
      build: () {
        when(mockGetTemperatureUnitUsecase.call(NoParams()))
            .thenAnswer((_) async => const Right('metric'));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(WeatherInitiatedEvent()),
      expect: () => [
        const WeatherState(
          status: WeatherStateStatus.initial,
          temperatureUnit: TemperatureUnit.celsius,
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [loading, loaded] when CityNameSearchedEvent is added and both weather and forecast are fetched successfully',
      build: () {
        when(mockGetCurrentWeatherUsecase.call(tCity))
            .thenAnswer((_) async => Right(tWeatherEntity));
        when(mockGetWeatherForecastUsecase.call(tCity))
            .thenAnswer((_) async => Right(tForecastEntity));
        return weatherBloc;
      },
      seed: () => const WeatherState(city: tCity),
      act: (bloc) => bloc.add(CityNameSearchedEvent()),
      expect: () => [
        const WeatherState(status: WeatherStateStatus.loading, city: tCity),
        WeatherState(
          status: WeatherStateStatus.loaded,
          city: tCity,
          weatherEntity: tWeatherEntity,
          forecastEntity: tForecastEntity,
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [loading, error] when CityNameSearchedEvent fails to fetch data',
      build: () {
        when(mockGetCurrentWeatherUsecase.call(tCity))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        when(mockGetWeatherForecastUsecase.call(tCity))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        return weatherBloc;
      },
      seed: () => const WeatherState(city: tCity),
      act: (bloc) => bloc.add(CityNameSearchedEvent()),
      expect: () => [
        const WeatherState(status: WeatherStateStatus.loading, city: tCity),
        const WeatherState(
          status: WeatherStateStatus.error,
          city: tCity,
          errorMessage: 'ErrorError',
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [initial] when CityNameCleared is added',
      build: () => weatherBloc,
      act: (bloc) => bloc.add(CityNameCleared()),
      expect: () => [
        const WeatherState(status: WeatherStateStatus.initial),
      ],
    );
  });
}
