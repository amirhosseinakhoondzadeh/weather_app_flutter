part of 'saved_cities_bloc.dart';

enum SavedCitiesStatus { initial, loading, loadingMore, loaded, error }

final class SavedCitiesState extends Equatable {
  const SavedCitiesState({
    this.status = SavedCitiesStatus.initial,
    this.cities = const [],
    this.hasReachedMax = false,
    this.errorMessage,
  });

  final SavedCitiesStatus status;
  final List<SavedCityEntity> cities;
  final bool hasReachedMax;
  final String? errorMessage;

  SavedCitiesState copyWith({
    SavedCitiesStatus? status,
    List<SavedCityEntity>? cities,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return SavedCitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cities, hasReachedMax, errorMessage];
}
