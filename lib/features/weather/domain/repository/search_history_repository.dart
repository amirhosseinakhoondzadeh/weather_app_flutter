import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';

abstract class SearchHistoryRepository {
  /// Loads one page of search history, most recent first. Network-first:
  /// refreshes each entry's weather and writes it through to the cache; on a
  /// network/server error the cached page is returned instead so the screen
  /// works offline.
  Future<Either<Failure, List<SearchHistoryEntry>>> getSearchHistory({
    required int page,
    required int limit,
  });

  /// Appends a successful search to the front of the history.
  Future<Either<Failure, void>> recordSearch(SearchHistoryEntry entry);
}
