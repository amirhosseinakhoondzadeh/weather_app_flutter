part of 'weather_bloc.dart';

enum WeatherStateStatus { initial, loading, loaded, error }

final class WeatherState extends Equatable {
  const WeatherState({
    this.status = WeatherStateStatus.initial,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.city = '',
    this.errorMessage,
    this.forecastEntity,
    this.weatherEntity,
  });

  final WeatherStateStatus status;
  final String? errorMessage;
  final TemperatureUnit temperatureUnit;
  final String city;
  final ForecastEntity? forecastEntity;
  final WeatherEntity? weatherEntity;

  WeatherState copyWith({
    final WeatherStateStatus? status,
    final String? errorMessage,
    final TemperatureUnit? temperatureUnit,
    final String? city,
    final WeatherEntity? weatherEntity,
    final ForecastEntity? forecastEntity,
  }) {
    return WeatherState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
        city: city ?? this.city,
        weatherEntity: weatherEntity ?? this.weatherEntity,
        forecastEntity: forecastEntity ?? this.forecastEntity);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        temperatureUnit,
        city,
        weatherEntity,
        forecastEntity,
      ];
}
