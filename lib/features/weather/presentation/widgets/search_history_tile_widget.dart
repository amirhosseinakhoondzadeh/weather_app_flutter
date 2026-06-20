import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/utils/weather_icon.dart';

class SearchHistoryTileWidget extends StatelessWidget {
  final SearchHistoryEntry entry;

  const SearchHistoryTileWidget({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 48,
        child: getWeatherIcon(entry.icon, size: 2),
      ),
      title: Text(entry.cityName),
      subtitle: Text(
        '${entry.temperature.round()}° · ${entry.description}',
      ),
      trailing: Text(
        DateFormat('MMM d, HH:mm').format(entry.searchedAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
