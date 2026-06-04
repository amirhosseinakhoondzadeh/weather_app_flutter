import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/features/weather/data/model/saved_city_model.dart';

const String savedCitiesKey = 'saved_cities';

abstract class SavedCitiesLocalDataSource {
  /// Persists [city], replacing any existing entry with the same name
  /// (case-insensitive) and moving it to the front of the list.
  Future<void> saveCity(SavedCityModel city);

  /// Removes the saved city with the given [cityName] (case-insensitive).
  Future<void> deleteSavedCity(String cityName);

  /// Returns a slice of the saved cities (newest first) starting at [offset]
  /// and containing at most [limit] entries.
  Future<List<SavedCityModel>> getSavedCities({
    required int offset,
    required int limit,
  });
}

class SavedCitiesLocalDataSourceImpl implements SavedCitiesLocalDataSource {
  final SharedPreferences sharedPreferences;

  SavedCitiesLocalDataSourceImpl({required this.sharedPreferences});

  List<SavedCityModel> _readAll() {
    final raw = sharedPreferences.getString(savedCitiesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((e) => SavedCityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeAll(List<SavedCityModel> cities) async {
    final encoded = json.encode(cities.map((c) => c.toJson()).toList());
    await sharedPreferences.setString(savedCitiesKey, encoded);
  }

  @override
  Future<void> saveCity(SavedCityModel city) async {
    try {
      final cities = _readAll()
        ..removeWhere(
          (c) => c.cityName.toLowerCase() == city.cityName.toLowerCase(),
        );
      cities.insert(0, city);
      await _writeAll(cities);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> deleteSavedCity(String cityName) async {
    try {
      final cities = _readAll()
        ..removeWhere(
          (c) => c.cityName.toLowerCase() == cityName.toLowerCase(),
        );
      await _writeAll(cities);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<SavedCityModel>> getSavedCities({
    required int offset,
    required int limit,
  }) async {
    try {
      final cities = _readAll();
      if (offset >= cities.length) {
        return [];
      }
      final end =
          (offset + limit) > cities.length ? cities.length : (offset + limit);
      return cities.sublist(offset, end);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
