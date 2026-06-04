import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/features/weather/data/model/saved_city_model.dart';

const String savedCitiesKey = 'saved_cities';

abstract class SavedCitiesLocalDataSource {
  /// Returns a single page of saved cities, newest first.
  Future<List<SavedCityModel>> getSavedCities({
    required int page,
    required int limit,
  });

  /// Inserts (or moves) a city to the front of the list.
  Future<void> saveCity(SavedCityModel city);

  /// Removes a city by name; a no-op if it isn't saved.
  Future<void> removeCity(String cityName);

  /// Write-through update of the last-known weather for already-saved cities,
  /// preserving their existing order.
  Future<void> cacheCities(List<SavedCityModel> cities);
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
  Future<List<SavedCityModel>> getSavedCities({
    required int page,
    required int limit,
  }) async {
    try {
      final all = _readAll();
      final start = page * limit;
      if (start >= all.length) {
        return [];
      }
      return all.sublist(start, min(start + limit, all.length));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveCity(SavedCityModel city) async {
    try {
      final all = _readAll()
        ..removeWhere((c) => c.cityName == city.cityName);
      all.insert(0, city);
      await _writeAll(all);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> removeCity(String cityName) async {
    try {
      final all = _readAll()..removeWhere((c) => c.cityName == cityName);
      await _writeAll(all);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheCities(List<SavedCityModel> cities) async {
    try {
      final byName = {for (final c in cities) c.cityName: c};
      final all = _readAll()
          .map((c) => byName[c.cityName] ?? c)
          .toList();
      await _writeAll(all);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
