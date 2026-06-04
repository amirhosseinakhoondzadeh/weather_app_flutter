import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/features/weather/data/datasource/saved_cities_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/model/saved_city_model.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late SavedCitiesLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SavedCitiesLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  SavedCityModel city(int i) => SavedCityModel(
        cityName: 'City $i',
        temperature: i.toDouble(),
        description: 'clear',
        icon: '01d',
      );

  String encode(List<SavedCityModel> cities) =>
      json.encode(cities.map((c) => c.toJson()).toList());

  group('getSavedCities (pagination)', () {
    final all = List.generate(25, (i) => city(i));

    setUp(() {
      when(mockSharedPreferences.getString(savedCitiesKey))
          .thenReturn(encode(all));
    });

    test('returns the first page', () async {
      final page = await dataSource.getSavedCities(page: 0, limit: 10);
      expect(page.map((c) => c.cityName),
          List.generate(10, (i) => 'City $i'));
    });

    test('returns a middle page', () async {
      final page = await dataSource.getSavedCities(page: 1, limit: 10);
      expect(page.map((c) => c.cityName),
          List.generate(10, (i) => 'City ${i + 10}'));
    });

    test('returns a short final page', () async {
      final page = await dataSource.getSavedCities(page: 2, limit: 10);
      expect(page.length, 5);
      expect(page.first.cityName, 'City 20');
    });

    test('returns empty past the end', () async {
      final page = await dataSource.getSavedCities(page: 3, limit: 10);
      expect(page, isEmpty);
    });

    test('returns empty when nothing is stored', () async {
      when(mockSharedPreferences.getString(savedCitiesKey)).thenReturn(null);
      final page = await dataSource.getSavedCities(page: 0, limit: 10);
      expect(page, isEmpty);
    });
  });

  group('saveCity', () {
    test('prepends a new city and de-duplicates by name', () async {
      when(mockSharedPreferences.getString(savedCitiesKey))
          .thenReturn(encode([city(0), city(1)]));
      when(mockSharedPreferences.setString(savedCitiesKey, any))
          .thenAnswer((_) async => true);

      await dataSource.saveCity(city(0));

      final captured = verify(
        mockSharedPreferences.setString(savedCitiesKey, captureAny),
      ).captured.single as String;
      final names = (json.decode(captured) as List)
          .map((e) => e['cityName'])
          .toList();
      expect(names, ['City 0', 'City 1']);
    });
  });

  group('removeCity', () {
    test('drops the matching city', () async {
      when(mockSharedPreferences.getString(savedCitiesKey))
          .thenReturn(encode([city(0), city(1)]));
      when(mockSharedPreferences.setString(savedCitiesKey, any))
          .thenAnswer((_) async => true);

      await dataSource.removeCity('City 0');

      final captured = verify(
        mockSharedPreferences.setString(savedCitiesKey, captureAny),
      ).captured.single as String;
      final names = (json.decode(captured) as List)
          .map((e) => e['cityName'])
          .toList();
      expect(names, ['City 1']);
    });
  });
}
