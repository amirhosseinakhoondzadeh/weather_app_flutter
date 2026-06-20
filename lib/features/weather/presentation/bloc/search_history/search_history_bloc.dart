import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_search_history_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/record_search_usecase.dart';

part 'search_history_event.dart';
part 'search_history_state.dart';

const int searchHistoryPageLimit = 10;

class SearchHistoryBloc
    extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final GetSearchHistoryUsecase getSearchHistoryUsecase;
  final RecordSearchUsecase recordSearchUsecase;

  int _page = 0;

  SearchHistoryBloc({
    required this.getSearchHistoryUsecase,
    required this.recordSearchUsecase,
  }) : super(const SearchHistoryState()) {
    // restartable(): a reload cancels any in-flight first-page request.
    on<SearchHistoryRequested>(_onRequested, transformer: restartable());
    // droppable(): ignore extra "next page" events while one is fetching.
    on<SearchHistoryNextPageRequested>(_onNextPage, transformer: droppable());
    on<SearchRecorded>(_onSearchRecorded);
  }

  FutureOr<void> _onRequested(
    SearchHistoryRequested event,
    Emitter<SearchHistoryState> emit,
  ) async {
    _page = 0;
    emit(state.copyWith(status: SearchHistoryStatus.loading));

    final result = await getSearchHistoryUsecase(
      const GetSearchHistoryParams(page: 0, limit: searchHistoryPageLimit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchHistoryStatus.error,
        errorMessage: failure.message,
      )),
      (entries) => emit(state.copyWith(
        status: SearchHistoryStatus.loaded,
        entries: entries,
        hasReachedMax: entries.length < searchHistoryPageLimit,
        isLoadingMore: false,
      )),
    );
  }

  FutureOr<void> _onNextPage(
    SearchHistoryNextPageRequested event,
    Emitter<SearchHistoryState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.status != SearchHistoryStatus.loaded) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _page + 1;
    final result = await getSearchHistoryUsecase(
      GetSearchHistoryParams(page: nextPage, limit: searchHistoryPageLimit),
    );

    result.fold(
      // Keep the already-loaded list (stale-but-usable) and stop the spinner.
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (entries) {
        _page = nextPage;
        emit(state.copyWith(
          status: SearchHistoryStatus.loaded,
          entries: [...state.entries, ...entries],
          hasReachedMax: entries.length < searchHistoryPageLimit,
          isLoadingMore: false,
        ));
      },
    );
  }

  FutureOr<void> _onSearchRecorded(
    SearchRecorded event,
    Emitter<SearchHistoryState> emit,
  ) async {
    final entry = SearchHistoryEntry(
      cityName: event.weatherEntity.cityName,
      temperature: event.weatherEntity.temperature,
      description: event.weatherEntity.description,
      icon: event.weatherEntity.icon,
      searchedAt: event.searchedAt,
    );

    final result = await recordSearchUsecase(entry);

    result.fold(
      (_) {},
      (_) => emit(state.copyWith(
        status: SearchHistoryStatus.loaded,
        entries: [entry, ...state.entries],
      )),
    );
  }
}
