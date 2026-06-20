part of 'search_history_bloc.dart';

sealed class SearchHistoryEvent extends Equatable {
  const SearchHistoryEvent();

  @override
  List<Object> get props => [];
}

/// Load (or reload) the first page of search history.
class SearchHistoryRequested extends SearchHistoryEvent {
  const SearchHistoryRequested();
}

/// Load the next page when the user scrolls to the bottom.
class SearchHistoryNextPageRequested extends SearchHistoryEvent {
  const SearchHistoryNextPageRequested();
}

/// Record a successful city search, snapshotting the weather shown at the time.
class SearchRecorded extends SearchHistoryEvent {
  const SearchRecorded(this.weatherEntity, {required this.searchedAt});

  final WeatherEntity weatherEntity;
  final DateTime searchedAt;

  @override
  List<Object> get props => [weatherEntity, searchedAt];
}
