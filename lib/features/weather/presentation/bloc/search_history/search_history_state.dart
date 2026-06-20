part of 'search_history_bloc.dart';

enum SearchHistoryStatus { initial, loading, loaded, error }

final class SearchHistoryState extends Equatable {
  const SearchHistoryState({
    this.status = SearchHistoryStatus.initial,
    this.entries = const [],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final SearchHistoryStatus status;
  final List<SearchHistoryEntry> entries;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  SearchHistoryState copyWith({
    SearchHistoryStatus? status,
    List<SearchHistoryEntry>? entries,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return SearchHistoryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        entries,
        hasReachedMax,
        isLoadingMore,
        errorMessage,
      ];
}
