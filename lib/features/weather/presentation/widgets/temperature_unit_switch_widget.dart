import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

class TemperatureUnitSwitchWidget extends StatelessWidget {
  const TemperatureUnitSwitchWidget({
    required this.temperatureUnit,
    super.key,
  });

  final TemperatureUnit temperatureUnit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(TemperatureUnit.celsius.symbol),
        Switch(
          value: temperatureUnit == TemperatureUnit.fahrenheit,
          onChanged: (value) => _onUnitChanged(value, context),
        ),
        Text(TemperatureUnit.fahrenheit.symbol),
      ],
    );
  }

  void _onUnitChanged(value, BuildContext context) {
    context.read<WeatherBloc>().add(WeatherTemperatureUnitChanged(
        value ? TemperatureUnit.fahrenheit : TemperatureUnit.celsius));
  }
}
