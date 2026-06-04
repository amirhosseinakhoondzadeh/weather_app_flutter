import 'package:flutter/material.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';
import 'package:weather_app_flutter/features/weather/utils/weather_icon.dart';

class SavedCityTileWidget extends StatelessWidget {
  final SavedCityEntity city;
  final VoidCallback onDelete;

  const SavedCityTileWidget({
    required this.city,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: SizedBox(
        width: 56,
        child: getWeatherIcon(city.icon, size: 2),
      ),
      title: Text(
        city.cityName,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${city.temperature.toInt()}${city.unitSymbol} • ${city.description}',
        style: theme.textTheme.labelLarge,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Remove',
        onPressed: onDelete,
      ),
    );
  }
}
