import 'package:equatable/equatable.dart';

/// A single successful city search, carrying the weather snapshot captured at
/// the moment of the search so the history list can render (and survive
/// offline) without a fresh network call.
class SearchHistoryEntry extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  /// When the user searched this city. Drives the most-recent-first ordering.
  final DateTime searchedAt;

  const SearchHistoryEntry({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.searchedAt,
  });

  @override
  List<Object> get props => [
        cityName,
        temperature,
        description,
        icon,
        searchedAt,
      ];
}
