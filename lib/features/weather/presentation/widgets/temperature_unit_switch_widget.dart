import 'package:flutter/material.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/temperature_unit.dart';

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
        // Demo branch: display is pinned to metric, so the toggle is inert
        // (disabled) and always reflects Celsius.
        Switch(
          value: temperatureUnit == TemperatureUnit.fahrenheit,
          onChanged: null,
        ),
        Text(TemperatureUnit.fahrenheit.symbol),
      ],
    );
  }
}
