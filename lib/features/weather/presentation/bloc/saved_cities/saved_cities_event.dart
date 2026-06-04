part of 'saved_cities_bloc.dart';

sealed class SavedCitiesEvent extends Equatable {
  const SavedCitiesEvent();

  @override
  List<Object> get props => [];
}

/// Load (or reload) the first page of saved cities.
class SavedCitiesRequested extends SavedCitiesEvent {
  const SavedCitiesRequested();
}

/// Load the next page when the user scrolls to the bottom.
class SavedCitiesNextPageRequested extends SavedCitiesEvent {
  const SavedCitiesNextPageRequested();
}

/// Save the city currently shown on the weather screen.
class CitySaved extends SavedCitiesEvent {
  const CitySaved(this.weatherEntity);

  final WeatherEntity weatherEntity;

  @override
  List<Object> get props => [weatherEntity];
}

/// Remove a city from the saved list.
class SavedCityRemoved extends SavedCitiesEvent {
  const SavedCityRemoved(this.cityName);

  final String cityName;

  @override
  List<Object> get props => [cityName];
}
