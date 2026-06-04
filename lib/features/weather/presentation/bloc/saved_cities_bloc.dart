import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/delete_saved_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_city_usecase.dart';

part 'saved_cities_event.dart';
part 'saved_cities_state.dart';

/// Number of saved cities fetched per page as the user scrolls.
const int savedCitiesPageSize = 8;

class SavedCitiesBloc extends Bloc<SavedCitiesEvent, SavedCitiesState> {
  final GetSavedCitiesUsecase getSavedCitiesUsecase;
  final SaveCityUsecase saveCityUsecase;
  final DeleteSavedCityUsecase deleteSavedCityUsecase;

  SavedCitiesBloc({
    required this.getSavedCitiesUsecase,
    required this.saveCityUsecase,
    required this.deleteSavedCityUsecase,
  }) : super(const SavedCitiesState()) {
    on<SavedCitiesFetched>(_onSavedCitiesFetched);
    on<SavedCitiesNextPageFetched>(_onSavedCitiesNextPageFetched);
    on<SaveCityRequested>(_onSaveCityRequested);
    on<SavedCityDeleted>(_onSavedCityDeleted);
  }

  FutureOr<void> _onSavedCitiesFetched(
    SavedCitiesFetched event,
    Emitter<SavedCitiesState> emit,
  ) async {
    emit(state.copyWith(status: SavedCitiesStatus.loading));

    final result = await getSavedCitiesUsecase(
      const SavedCitiesParams(offset: 0, limit: savedCitiesPageSize),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SavedCitiesStatus.error,
        errorMessage: failure.message,
      )),
      (cities) => emit(state.copyWith(
        status: SavedCitiesStatus.loaded,
        cities: cities,
        hasReachedMax: cities.length < savedCitiesPageSize,
      )),
    );
  }

  FutureOr<void> _onSavedCitiesNextPageFetched(
    SavedCitiesNextPageFetched event,
    Emitter<SavedCitiesState> emit,
  ) async {
    if (state.hasReachedMax || state.status == SavedCitiesStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: SavedCitiesStatus.loadingMore));

    final result = await getSavedCitiesUsecase(
      SavedCitiesParams(
        offset: state.cities.length,
        limit: savedCitiesPageSize,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SavedCitiesStatus.error,
        errorMessage: failure.message,
      )),
      (cities) => emit(state.copyWith(
        status: SavedCitiesStatus.loaded,
        cities: [...state.cities, ...cities],
        hasReachedMax: cities.length < savedCitiesPageSize,
      )),
    );
  }

  FutureOr<void> _onSaveCityRequested(
    SaveCityRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    final result = await saveCityUsecase(event.city);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SavedCitiesStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        // Keep the in-memory list in sync so the city appears immediately if
        // the Saved Cities screen has already been opened.
        final updated = [
          event.city,
          ...state.cities.where(
            (c) => c.cityName.toLowerCase() != event.city.cityName.toLowerCase(),
          ),
        ];
        emit(state.copyWith(cities: updated));
      },
    );
  }

  FutureOr<void> _onSavedCityDeleted(
    SavedCityDeleted event,
    Emitter<SavedCitiesState> emit,
  ) async {
    final result = await deleteSavedCityUsecase(event.cityName);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SavedCitiesStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        cities: state.cities
            .where((c) =>
                c.cityName.toLowerCase() != event.cityName.toLowerCase())
            .toList(),
      )),
    );
  }
}
