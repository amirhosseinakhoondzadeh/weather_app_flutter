import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';

import '../../mocks/mock_dependencies.mocks.dart';

void main() {
  late SavedCitiesBloc bloc;
  late MockGetSavedCitiesUsecase mockGetSavedCitiesUsecase;
  late MockSaveCityUsecase mockSaveCityUsecase;
  late MockRemoveSavedCityUsecase mockRemoveSavedCityUsecase;

  SavedCity city(int i) => SavedCity(
        cityName: 'City $i',
        temperature: 20.0 + i,
        description: 'clear sky',
        icon: '01d',
      );

  // A full page (== savedCitiesPageLimit) and a short final page.
  final fullPage =
      List.generate(savedCitiesPageLimit, (i) => city(i));
  final partialPage = [city(savedCitiesPageLimit)];

  setUp(() {
    mockGetSavedCitiesUsecase = MockGetSavedCitiesUsecase();
    mockSaveCityUsecase = MockSaveCityUsecase();
    mockRemoveSavedCityUsecase = MockRemoveSavedCityUsecase();

    bloc = SavedCitiesBloc(
      getSavedCitiesUsecase: mockGetSavedCitiesUsecase,
      saveCityUsecase: mockSaveCityUsecase,
      removeSavedCityUsecase: mockRemoveSavedCityUsecase,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is SavedCitiesState', () {
    expect(bloc.state, const SavedCitiesState());
  });

  group('pagination', () {
    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'emits [loading, loaded] with a full first page (not yet at max)',
      build: () {
        when(mockGetSavedCitiesUsecase.call(
          const GetSavedCitiesParams(page: 0, limit: savedCitiesPageLimit),
        )).thenAnswer((_) async => Right(fullPage));
        return bloc;
      },
      act: (bloc) => bloc.add(const SavedCitiesRequested()),
      expect: () => [
        const SavedCitiesState(status: SavedCitiesStatus.loading),
        SavedCitiesState(
          status: SavedCitiesStatus.loaded,
          cities: fullPage,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'appends the next page and reaches max on a short page',
      build: () {
        when(mockGetSavedCitiesUsecase.call(
          const GetSavedCitiesParams(page: 0, limit: savedCitiesPageLimit),
        )).thenAnswer((_) async => Right(fullPage));
        when(mockGetSavedCitiesUsecase.call(
          const GetSavedCitiesParams(page: 1, limit: savedCitiesPageLimit),
        )).thenAnswer((_) async => Right(partialPage));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SavedCitiesRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SavedCitiesNextPageRequested());
      },
      expect: () => [
        const SavedCitiesState(status: SavedCitiesStatus.loading),
        SavedCitiesState(
          status: SavedCitiesStatus.loaded,
          cities: fullPage,
          hasReachedMax: false,
        ),
        SavedCitiesState(
          status: SavedCitiesStatus.loaded,
          cities: fullPage,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        SavedCitiesState(
          status: SavedCitiesStatus.loaded,
          cities: [...fullPage, ...partialPage],
          hasReachedMax: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'does not fetch a next page once hasReachedMax is true',
      build: () {
        when(mockGetSavedCitiesUsecase.call(
          const GetSavedCitiesParams(page: 0, limit: savedCitiesPageLimit),
        )).thenAnswer((_) async => Right(partialPage));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SavedCitiesRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SavedCitiesNextPageRequested());
      },
      expect: () => [
        const SavedCitiesState(status: SavedCitiesStatus.loading),
        SavedCitiesState(
          status: SavedCitiesStatus.loaded,
          cities: partialPage,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verify(mockGetSavedCitiesUsecase.call(
          const GetSavedCitiesParams(page: 0, limit: savedCitiesPageLimit),
        )).called(1);
        verifyNever(mockGetSavedCitiesUsecase.call(
          const GetSavedCitiesParams(page: 1, limit: savedCitiesPageLimit),
        ));
      },
    );

    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'emits [loading, error] when the first page fails',
      build: () {
        when(mockGetSavedCitiesUsecase.call(any))
            .thenAnswer((_) async => const Left(CacheFailure('boom')));
        return bloc;
      },
      act: (bloc) => bloc.add(const SavedCitiesRequested()),
      expect: () => [
        const SavedCitiesState(status: SavedCitiesStatus.loading),
        const SavedCitiesState(
          status: SavedCitiesStatus.error,
          errorMessage: 'boom',
        ),
      ],
    );
  });

  group('remove', () {
    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'removes a city from the loaded list',
      build: () {
        when(mockRemoveSavedCityUsecase.call('City 0'))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => SavedCitiesState(
        status: SavedCitiesStatus.loaded,
        cities: [city(0), city(1)],
      ),
      act: (bloc) => bloc.add(const SavedCityRemoved('City 0')),
      expect: () => [
        SavedCitiesState(
          status: SavedCitiesStatus.loaded,
          cities: [city(1)],
        ),
      ],
    );
  });
}
