import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app_flutter/features/weather/data/model/weather_model.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';

part 'search_history_entry_model.g.dart';

@JsonSerializable()
class SearchHistoryEntryModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  /// Stored as epoch milliseconds so the persisted ordering is stable.
  @JsonKey(fromJson: _dateFromMillis, toJson: _dateToMillis)
  final DateTime searchedAt;

  SearchHistoryEntryModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.searchedAt,
  });

  factory SearchHistoryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryEntryModelToJson(this);

  factory SearchHistoryEntryModel.fromEntity(SearchHistoryEntry entry) =>
      SearchHistoryEntryModel(
        cityName: entry.cityName,
        temperature: entry.temperature,
        description: entry.description,
        icon: entry.icon,
        searchedAt: entry.searchedAt,
      );

  /// Snapshot captured from the weather currently shown after a search.
  factory SearchHistoryEntryModel.fromWeatherEntity(
    WeatherEntity entity, {
    required DateTime searchedAt,
  }) =>
      SearchHistoryEntryModel(
        cityName: entity.cityName,
        temperature: entity.temperature,
        description: entity.description,
        icon: entity.icon,
        searchedAt: searchedAt,
      );

  /// Snapshot built from a fresh remote weather response (write-through cache),
  /// preserving the original search time.
  factory SearchHistoryEntryModel.fromWeatherModel(
    WeatherModel model, {
    required DateTime searchedAt,
  }) =>
      SearchHistoryEntryModel(
        cityName: model.name,
        temperature: model.main.temp,
        description: model.weather.first.description,
        icon: model.weather.first.icon,
        searchedAt: searchedAt,
      );

  SearchHistoryEntry toEntity() => SearchHistoryEntry(
        cityName: cityName,
        temperature: temperature,
        description: description,
        icon: icon,
        searchedAt: searchedAt,
      );
}

DateTime _dateFromMillis(int millis) =>
    DateTime.fromMillisecondsSinceEpoch(millis);

int _dateToMillis(DateTime date) => date.millisecondsSinceEpoch;
