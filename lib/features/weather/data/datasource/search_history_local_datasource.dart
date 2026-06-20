import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_flutter/core/error/exceptions.dart';
import 'package:weather_app_flutter/features/weather/data/model/search_history_entry_model.dart';

const String searchHistoryKey = 'search_history';

abstract class SearchHistoryLocalDataSource {
  /// Returns a single page of history entries, most recent first.
  Future<List<SearchHistoryEntryModel>> getSearchHistory({
    required int page,
    required int limit,
  });

  /// Prepends a new search to the front of the history (a log, so repeated
  /// searches of the same city each add their own entry).
  Future<void> recordSearch(SearchHistoryEntryModel entry);

  /// Write-through update of the stored weather for existing entries, matched
  /// by their search time, preserving their existing order.
  Future<void> cacheEntries(List<SearchHistoryEntryModel> entries);
}

class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  SearchHistoryLocalDataSourceImpl({required this.sharedPreferences});

  List<SearchHistoryEntryModel> _readAll() {
    final raw = sharedPreferences.getString(searchHistoryKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((e) =>
            SearchHistoryEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeAll(List<SearchHistoryEntryModel> entries) async {
    final encoded = json.encode(entries.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(searchHistoryKey, encoded);
  }

  @override
  Future<List<SearchHistoryEntryModel>> getSearchHistory({
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
  Future<void> recordSearch(SearchHistoryEntryModel entry) async {
    try {
      final all = _readAll()..insert(0, entry);
      await _writeAll(all);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheEntries(List<SearchHistoryEntryModel> entries) async {
    try {
      final byTime = {
        for (final e in entries) e.searchedAt.millisecondsSinceEpoch: e
      };
      final all = _readAll()
          .map((e) => byTime[e.searchedAt.millisecondsSinceEpoch] ?? e)
          .toList();
      await _writeAll(all);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
