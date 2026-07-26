part of 'saved_cities_bloc.dart';

enum SavedCitiesStatus { initial, loading, loaded, error }

final class SavedCitiesState extends Equatable {
  const SavedCitiesState({
    this.status = SavedCitiesStatus.initial,
    this.cities = const [],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final SavedCitiesStatus status;
  final List<SavedCity> cities;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  SavedCitiesState copyWith({
    SavedCitiesStatus? status,
    List<SavedCity>? cities,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return SavedCitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        cities,
        hasReachedMax,
        isLoadingMore,
        errorMessage,
      ];
}
