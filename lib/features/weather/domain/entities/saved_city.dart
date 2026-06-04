import 'package:equatable/equatable.dart';

/// A city the user has chosen to keep, carrying its last-known weather so the
/// list can render (and survive offline) without a fresh network call.
class SavedCity extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  const SavedCity({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  @override
  List<Object> get props => [cityName, temperature, description, icon];
}
