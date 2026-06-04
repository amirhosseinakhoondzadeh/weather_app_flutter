import 'package:equatable/equatable.dart';

/// A city the user has saved, together with a snapshot of its last-known
/// weather. The snapshot is what allows the Saved Cities screen to render
/// each row (and work offline) without hitting the network.
class SavedCityEntity extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  /// The temperature unit symbol that was active when the city was saved
  /// (e.g. '°C' or '°F'), so the cached temperature renders correctly.
  final String unitSymbol;

  const SavedCityEntity({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.unitSymbol,
  });

  @override
  List<Object> get props => [
        cityName,
        temperature,
        description,
        icon,
        unitSymbol,
      ];
}
