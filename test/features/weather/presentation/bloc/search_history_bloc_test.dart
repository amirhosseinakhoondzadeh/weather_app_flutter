import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_search_history_usecase.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/search_history/search_history_bloc.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late SearchHistoryBloc bloc;
  late MockGetSearchHistoryUsecase mockGetSearchHistoryUsecase;
  late MockRecordSearchUsecase mockRecordSearchUsecase;

  SearchHistoryEntry entry(int i) => SearchHistoryEntry(
        cityName: 'City $i',
        temperature: 20.0 + i,
        description: 'clear sky',
        icon: '01d',
        searchedAt: DateTime.fromMillisecondsSinceEpoch(1000 + i),
      );

  // A full page (== searchHistoryPageLimit) and a short final page.
  final fullPage = List.generate(searchHistoryPageLimit, (i) => entry(i));
  final partialPage = [entry(searchHistoryPageLimit)];

  setUp(() {
    mockGetSearchHistoryUsecase = MockGetSearchHistoryUsecase();
    mockRecordSearchUsecase = MockRecordSearchUsecase();

    bloc = SearchHistoryBloc(
      getSearchHistoryUsecase: mockGetSearchHistoryUsecase,
      recordSearchUsecase: mockRecordSearchUsecase,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is SearchHistoryState', () {
    expect(bloc.state, const SearchHistoryState());
  });

  group('pagination', () {
    blocTest<SearchHistoryBloc, SearchHistoryState>(
      'emits [loading, loaded] with a full first page (not yet at max)',
      build: () {
        when(mockGetSearchHistoryUsecase.call(
          const GetSearchHistoryParams(page: 0, limit: searchHistoryPageLimit),
        )).thenAnswer((_) async => Right(fullPage));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchHistoryRequested()),
      expect: () => [
        const SearchHistoryState(status: SearchHistoryStatus.loading),
        SearchHistoryState(
          status: SearchHistoryStatus.loaded,
          entries: fullPage,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<SearchHistoryBloc, SearchHistoryState>(
      'appends the next page and reaches max on a short page',
      build: () {
        when(mockGetSearchHistoryUsecase.call(
          const GetSearchHistoryParams(page: 0, limit: searchHistoryPageLimit),
        )).thenAnswer((_) async => Right(fullPage));
        when(mockGetSearchHistoryUsecase.call(
          const GetSearchHistoryParams(page: 1, limit: searchHistoryPageLimit),
        )).thenAnswer((_) async => Right(partialPage));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SearchHistoryRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchHistoryNextPageRequested());
      },
      expect: () => [
        const SearchHistoryState(status: SearchHistoryStatus.loading),
        SearchHistoryState(
          status: SearchHistoryStatus.loaded,
          entries: fullPage,
          hasReachedMax: false,
        ),
        SearchHistoryState(
          status: SearchHistoryStatus.loaded,
          entries: fullPage,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        SearchHistoryState(
          status: SearchHistoryStatus.loaded,
          entries: [...fullPage, ...partialPage],
          hasReachedMax: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<SearchHistoryBloc, SearchHistoryState>(
      'does not fetch a next page once hasReachedMax is true',
      build: () {
        when(mockGetSearchHistoryUsecase.call(
          const GetSearchHistoryParams(page: 0, limit: searchHistoryPageLimit),
        )).thenAnswer((_) async => Right(partialPage));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SearchHistoryRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchHistoryNextPageRequested());
      },
      expect: () => [
        const SearchHistoryState(status: SearchHistoryStatus.loading),
        SearchHistoryState(
          status: SearchHistoryStatus.loaded,
          entries: partialPage,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verify(mockGetSearchHistoryUsecase.call(
          const GetSearchHistoryParams(page: 0, limit: searchHistoryPageLimit),
        )).called(1);
        verifyNever(mockGetSearchHistoryUsecase.call(
          const GetSearchHistoryParams(page: 1, limit: searchHistoryPageLimit),
        ));
      },
    );

    blocTest<SearchHistoryBloc, SearchHistoryState>(
      'emits [loading, error] when the first page fails',
      build: () {
        when(mockGetSearchHistoryUsecase.call(any))
            .thenAnswer((_) async => const Left(CacheFailure('boom')));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchHistoryRequested()),
      expect: () => [
        const SearchHistoryState(status: SearchHistoryStatus.loading),
        const SearchHistoryState(
          status: SearchHistoryStatus.error,
          errorMessage: 'boom',
        ),
      ],
    );
  });

  group('record', () {
    final weather = WeatherEntity(
      cityName: 'London',
      temperature: 12.0,
      description: 'light rain',
      humidity: 80,
      pressure: 1012,
      windSpeed: 3.0,
      icon: '10d',
      date: DateTime.fromMillisecondsSinceEpoch(0),
      tempMin: 10.0,
      tempMax: 14.0,
    );
    final searchedAt = DateTime.fromMillisecondsSinceEpoch(5000);

    blocTest<SearchHistoryBloc, SearchHistoryState>(
      'prepends a recorded search to the loaded list',
      build: () {
        when(mockRecordSearchUsecase.call(any))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => SearchHistoryState(
        status: SearchHistoryStatus.loaded,
        entries: [entry(0)],
      ),
      act: (bloc) =>
          bloc.add(SearchRecorded(weather, searchedAt: searchedAt)),
      expect: () => [
        SearchHistoryState(
          status: SearchHistoryStatus.loaded,
          entries: [
            SearchHistoryEntry(
              cityName: 'London',
              temperature: 12.0,
              description: 'light rain',
              icon: '10d',
              searchedAt: searchedAt,
            ),
            entry(0),
          ],
        ),
      ],
    );
  });
}
