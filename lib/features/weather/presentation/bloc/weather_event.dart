part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherInitiatedEvent extends WeatherEvent {}

class CityNameSearchedEvent extends WeatherEvent {
  const CityNameSearchedEvent({this.isPullToRefresh = false});

  final bool isPullToRefresh;
}

class CityNameCleared extends WeatherEvent {}

class CityNameChangedEvent extends WeatherEvent {
  const CityNameChangedEvent(this.city);
  final String city;
}

class WeatherTemperatureUnitChanged extends WeatherEvent {
  const WeatherTemperatureUnitChanged(this.temperatureUnit);

  final TemperatureUnit temperatureUnit;
}

class CurrentWeatherChanged extends WeatherEvent {
  const CurrentWeatherChanged(this.weatherEntity);

  final WeatherEntity weatherEntity;
}
