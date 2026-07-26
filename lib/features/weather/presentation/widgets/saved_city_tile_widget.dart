import 'package:flutter/material.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/utils/weather_icon.dart';

class SavedCityTileWidget extends StatelessWidget {
  final SavedCity city;
  final VoidCallback onRemove;

  const SavedCityTileWidget({
    required this.city,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 48,
        child: getWeatherIcon(city.icon, size: 2),
      ),
      title: Text(city.cityName),
      subtitle: Text(
        '${city.temperature.round()}° · ${city.description}',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Remove',
        onPressed: onRemove,
      ),
    );
  }
}
