import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/features/weather/data/datasource/search_history_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/model/search_history_entry_model.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late SearchHistoryLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SearchHistoryLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  SearchHistoryEntryModel entry(int i) => SearchHistoryEntryModel(
        cityName: 'City $i',
        temperature: i.toDouble(),
        description: 'clear',
        icon: '01d',
        searchedAt: DateTime.fromMillisecondsSinceEpoch(1000 + i),
      );

  String encode(List<SearchHistoryEntryModel> entries) =>
      json.encode(entries.map((e) => e.toJson()).toList());

  group('getSearchHistory (pagination)', () {
    final all = List.generate(25, (i) => entry(i));

    setUp(() {
      when(mockSharedPreferences.getString(searchHistoryKey))
          .thenReturn(encode(all));
    });

    test('returns the first page', () async {
      final page = await dataSource.getSearchHistory(page: 0, limit: 10);
      expect(page.map((e) => e.cityName), List.generate(10, (i) => 'City $i'));
    });

    test('returns a middle page', () async {
      final page = await dataSource.getSearchHistory(page: 1, limit: 10);
      expect(page.map((e) => e.cityName),
          List.generate(10, (i) => 'City ${i + 10}'));
    });

    test('returns a short final page', () async {
      final page = await dataSource.getSearchHistory(page: 2, limit: 10);
      expect(page.length, 5);
      expect(page.first.cityName, 'City 20');
    });

    test('returns empty past the end', () async {
      final page = await dataSource.getSearchHistory(page: 3, limit: 10);
      expect(page, isEmpty);
    });

    test('returns empty when nothing is stored', () async {
      when(mockSharedPreferences.getString(searchHistoryKey)).thenReturn(null);
      final page = await dataSource.getSearchHistory(page: 0, limit: 10);
      expect(page, isEmpty);
    });
  });

  group('recordSearch', () {
    test('prepends a new entry, keeping duplicates (it is a log)', () async {
      when(mockSharedPreferences.getString(searchHistoryKey))
          .thenReturn(encode([entry(0), entry(1)]));
      when(mockSharedPreferences.setString(searchHistoryKey, any))
          .thenAnswer((_) async => true);

      await dataSource.recordSearch(entry(0));

      final captured = verify(
        mockSharedPreferences.setString(searchHistoryKey, captureAny),
      ).captured.single as String;
      final names = (json.decode(captured) as List)
          .map((e) => e['cityName'])
          .toList();
      expect(names, ['City 0', 'City 0', 'City 1']);
    });
  });

  group('cacheEntries', () {
    test('write-through updates matching entries by search time, keeping order',
        () async {
      when(mockSharedPreferences.getString(searchHistoryKey))
          .thenReturn(encode([entry(0), entry(1)]));
      when(mockSharedPreferences.setString(searchHistoryKey, any))
          .thenAnswer((_) async => true);

      final refreshed = SearchHistoryEntryModel(
        cityName: 'City 0',
        temperature: 99.0,
        description: 'updated',
        icon: '01d',
        searchedAt: DateTime.fromMillisecondsSinceEpoch(1000),
      );

      await dataSource.cacheEntries([refreshed]);

      final captured = verify(
        mockSharedPreferences.setString(searchHistoryKey, captureAny),
      ).captured.single as String;
      final decoded = json.decode(captured) as List;
      expect(decoded.map((e) => e['cityName']), ['City 0', 'City 1']);
      expect(decoded.first['temperature'], 99.0);
      expect(decoded.first['description'], 'updated');
    });
  });
}
