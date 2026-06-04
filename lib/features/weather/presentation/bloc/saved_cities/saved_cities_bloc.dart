import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/remove_saved_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_city_usecase.dart';

part 'saved_cities_event.dart';
part 'saved_cities_state.dart';

const int savedCitiesPageLimit = 10;

class SavedCitiesBloc extends Bloc<SavedCitiesEvent, SavedCitiesState> {
  final GetSavedCitiesUsecase getSavedCitiesUsecase;
  final SaveCityUsecase saveCityUsecase;
  final RemoveSavedCityUsecase removeSavedCityUsecase;

  int _page = 0;

  SavedCitiesBloc({
    required this.getSavedCitiesUsecase,
    required this.saveCityUsecase,
    required this.removeSavedCityUsecase,
  }) : super(const SavedCitiesState()) {
    // restartable(): a reload cancels any in-flight first-page request.
    on<SavedCitiesRequested>(_onRequested, transformer: restartable());
    // droppable(): ignore extra "next page" events while one is fetching.
    on<SavedCitiesNextPageRequested>(_onNextPage, transformer: droppable());
    on<CitySaved>(_onCitySaved);
    on<SavedCityRemoved>(_onRemoved);
  }

  FutureOr<void> _onRequested(
    SavedCitiesRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    _page = 0;
    emit(state.copyWith(status: SavedCitiesStatus.loading));

    final result = await getSavedCitiesUsecase(
      const GetSavedCitiesParams(page: 0, limit: savedCitiesPageLimit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SavedCitiesStatus.error,
        errorMessage: failure.message,
      )),
      (cities) => emit(state.copyWith(
        status: SavedCitiesStatus.loaded,
        cities: cities,
        hasReachedMax: cities.length < savedCitiesPageLimit,
        isLoadingMore: false,
      )),
    );
  }

  FutureOr<void> _onNextPage(
    SavedCitiesNextPageRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.status != SavedCitiesStatus.loaded) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _page + 1;
    final result = await getSavedCitiesUsecase(
      GetSavedCitiesParams(page: nextPage, limit: savedCitiesPageLimit),
    );

    result.fold(
      // Keep the already-loaded list (stale-but-usable) and stop the spinner.
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (cities) {
        _page = nextPage;
        emit(state.copyWith(
          status: SavedCitiesStatus.loaded,
          cities: [...state.cities, ...cities],
          hasReachedMax: cities.length < savedCitiesPageLimit,
          isLoadingMore: false,
        ));
      },
    );
  }

  FutureOr<void> _onCitySaved(
    CitySaved event,
    Emitter<SavedCitiesState> emit,
  ) async {
    final city = SavedCity(
      cityName: event.weatherEntity.cityName,
      temperature: event.weatherEntity.temperature,
      description: event.weatherEntity.description,
      icon: event.weatherEntity.icon,
    );

    final result = await saveCityUsecase(city);

    result.fold(
      (_) {},
      (_) {
        final withoutDuplicate =
            state.cities.where((c) => c.cityName != city.cityName);
        emit(state.copyWith(
          status: SavedCitiesStatus.loaded,
          cities: [city, ...withoutDuplicate],
        ));
      },
    );
  }

  FutureOr<void> _onRemoved(
    SavedCityRemoved event,
    Emitter<SavedCitiesState> emit,
  ) async {
    final result = await removeSavedCityUsecase(event.cityName);

    result.fold(
      (_) {},
      (_) => emit(state.copyWith(
        cities: state.cities
            .where((c) => c.cityName != event.cityName)
            .toList(),
      )),
    );
  }
}
