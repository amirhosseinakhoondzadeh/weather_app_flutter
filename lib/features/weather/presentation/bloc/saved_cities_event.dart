part of 'saved_cities_bloc.dart';

sealed class SavedCitiesEvent extends Equatable {
  const SavedCitiesEvent();

  @override
  List<Object> get props => [];
}

/// Loads the first page of saved cities (resets any existing list).
class SavedCitiesFetched extends SavedCitiesEvent {}

/// Loads the next page of saved cities as the user scrolls to the bottom.
class SavedCitiesNextPageFetched extends SavedCitiesEvent {}

/// Saves the given city snapshot.
class SaveCityRequested extends SavedCitiesEvent {
  const SaveCityRequested(this.city);

  final SavedCityEntity city;

  @override
  List<Object> get props => [city];
}

/// Removes a saved city by name.
class SavedCityDeleted extends SavedCitiesEvent {
  const SavedCityDeleted(this.cityName);

  final String cityName;

  @override
  List<Object> get props => [cityName];
}
