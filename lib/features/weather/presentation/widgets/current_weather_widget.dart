import 'package:flutter/material.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/utils/date_time_converter.dart';
import 'package:weather_app_flutter/features/weather/utils/weather_icon.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherEntity weatherEntity;
  final TemperatureUnit temperatureUnit;

  const CurrentWeatherWidget(
      {required this.weatherEntity, required this.temperatureUnit, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateTimeConverter.getDayOfWeek(weatherEntity.date),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            weatherEntity.description,
            style: theme.textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 8),
        getWeatherImage(weatherEntity.icon),
        SizedBox(height: 16),
        Text(
          "${weatherEntity.temperature.toInt()}${temperatureUnit.symbol}",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Humidity: ${weatherEntity.humidity}%",
            style: theme.textTheme.labelLarge,
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Pressure: ${weatherEntity.pressure} hPa",
            style: theme.textTheme.labelLarge,
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Wind Speed: ${weatherEntity.windSpeed} m/s",
            style: theme.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
