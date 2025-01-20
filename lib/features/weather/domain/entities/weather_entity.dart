import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String icon;
  final DateTime date;
  final double tempMin;
  final double tempMax;

  const WeatherEntity({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.icon,
    required this.date,
    required this.tempMax,
    required this.tempMin,
  });

  @override
  List<Object> get props => [
        cityName,
        temperature,
        description,
        humidity,
        pressure,
        windSpeed,
        icon,
        date,
        tempMax,
        tempMin,
      ];
}
