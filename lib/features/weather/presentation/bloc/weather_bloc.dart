import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_temperature_unit_usecase.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUsecase getCurrentWeatherUsecase;
  final GetTemperatureUnitUsecase getTemperatureUnitUsecase;
  final SaveTemperatureUnitUsecase saveTemperatureUnitUsecase;
  final GetWeatherForecastUsecase getWeatherForecastUsecase;

  WeatherBloc({
    required this.getCurrentWeatherUsecase,
    required this.getTemperatureUnitUsecase,
    required this.getWeatherForecastUsecase,
    required this.saveTemperatureUnitUsecase,
  }) : super(const WeatherState()) {
    on<WeatherInitiatedEvent>(_onWeatherInitiated);
    on<CityNameChangedEvent>(_onCityNameChanged);
    on<CityNameSearchedEvent>(_onWeatherCityEntered);
    on<WeatherTemperatureUnitChanged>(_onWeatherTemperatureUnitChanged);
    on<CityNameCleared>(_onCityNameCleared);
    on<CurrentWeatherChanged>(_onCurrentWeatherChanged);
  }

  FutureOr<void> _onWeatherInitiated(
    WeatherInitiatedEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final result = await getTemperatureUnitUsecase.call(NoParams());
    result.fold(
        (failure) => emit(
              state.copyWith(
                  status: WeatherStateStatus.error,
                  errorMessage: failure.message),
            ), (unit) {
      final temperatureUnit = unit == TemperatureUnit.celsius.name
          ? TemperatureUnit.celsius
          : TemperatureUnit.fahrenheit;

      return emit(
        state.copyWith(
          status: WeatherStateStatus.initial,
          temperatureUnit: temperatureUnit,
        ),
      );
    });
  }

  FutureOr<void> _onWeatherCityEntered(
    CityNameSearchedEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (state.city.isEmpty) {
      return;
    }

    if (!event.isPullToRefresh) {
      emit(state.copyWith(status: WeatherStateStatus.loading));
    }

    final results = await Future.wait([
      getCurrentWeatherUsecase(state.city),
      getWeatherForecastUsecase(state.city)
    ]);

    final currentWeatherResult = results[0] as Either<Failure, WeatherEntity>;
    final weatherForecaseResult = results[1] as Either<Failure, ForecastEntity>;

    // check if both succedded
    if (currentWeatherResult.isRight() && weatherForecaseResult.isRight()) {
      emit(state.copyWith(
        status: WeatherStateStatus.loaded,
        forecastEntity:
            weatherForecaseResult.getOrElse(() => throw Exception()),
        weatherEntity: currentWeatherResult.getOrElse(() => throw Exception()),
      ));
    } else {
      // Handle error
      final errorMessage = currentWeatherResult.fold(
            (failure) => failure.message,
            (_) => '',
          ) +
          weatherForecaseResult.fold(
            (failure) => failure.message,
            (_) => '',
          );

      emit(
        state.copyWith(
            status: WeatherStateStatus.error, errorMessage: errorMessage),
      );
    }
  }

  FutureOr<void> _onCityNameChanged(
    CityNameChangedEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(city: event.city));
  }

  FutureOr<void> _onWeatherTemperatureUnitChanged(
    WeatherTemperatureUnitChanged event,
    Emitter<WeatherState> emit,
  ) async {
    final prevState = state;

    emit(state.copyWith(status: WeatherStateStatus.loading));
    await saveTemperatureUnitUsecase.call(event.temperatureUnit.name);
    emit(state.copyWith(temperatureUnit: event.temperatureUnit));
    if (state.city.isEmpty) {
      emit(state.copyWith(status: prevState.status));
    } else {
      add(CityNameSearchedEvent());
    }
  }

  FutureOr<void> _onCityNameCleared(
    CityNameCleared event,
    Emitter<WeatherState> emit,
  ) {
    emit(state.copyWith(city: '', status: WeatherStateStatus.initial));
  }

  FutureOr<void> _onCurrentWeatherChanged(
    CurrentWeatherChanged event,
    Emitter<WeatherState> emit,
  ) {
    emit(state.copyWith(weatherEntity: event.weatherEntity));
  }
}
