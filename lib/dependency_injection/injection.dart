import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/saved_cities_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/search_history_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/repository/saved_cities_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/data/repository/search_history_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/data/repository/weather_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/search_history_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_search_history_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/record_search_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/remove_saved_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/search_history/search_history_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // BLoC
  getIt.registerFactory(
    () => WeatherBloc(
        getCurrentWeatherUsecase: getIt<GetCurrentWeatherUsecase>(),
        getTemperatureUnitUsecase: getIt<GetTemperatureUnitUsecase>(),
        getWeatherForecastUsecase: getIt<GetWeatherForecastUsecase>(),
        saveTemperatureUnitUsecase: getIt<SaveTemperatureUnitUsecase>()),
  );

  getIt.registerFactory(
    () => SavedCitiesBloc(
      getSavedCitiesUsecase: getIt<GetSavedCitiesUsecase>(),
      saveCityUsecase: getIt<SaveCityUsecase>(),
      removeSavedCityUsecase: getIt<RemoveSavedCityUsecase>(),
    ),
  );

  getIt.registerFactory(
    () => SearchHistoryBloc(
      getSearchHistoryUsecase: getIt<GetSearchHistoryUsecase>(),
      recordSearchUsecase: getIt<RecordSearchUsecase>(),
    ),
  );

  // Use cases
  getIt.registerFactory(() => GetCurrentWeatherUsecase(repository: getIt()));
  getIt.registerFactory(() => GetTemperatureUnitUsecase(repository: getIt()));
  getIt.registerFactory(() => GetWeatherForecastUsecase(repository: getIt()));
  getIt.registerFactory(() => SaveTemperatureUnitUsecase(repository: getIt()));
  getIt.registerFactory(() => GetSavedCitiesUsecase(repository: getIt()));
  getIt.registerFactory(() => SaveCityUsecase(repository: getIt()));
  getIt.registerFactory(() => RemoveSavedCityUsecase(repository: getIt()));
  getIt.registerFactory(() => GetSearchHistoryUsecase(repository: getIt()));
  getIt.registerFactory(() => RecordSearchUsecase(repository: getIt()));

  // Repository
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<SavedCitiesRepository>(
    () => SavedCitiesRepositoryImpl(
      remoteDataSource: getIt(),
      savedCitiesLocalDataSource: getIt(),
      weatherLocalDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<SearchHistoryRepository>(
    () => SearchHistoryRepositoryImpl(
      remoteDataSource: getIt(),
      searchHistoryLocalDataSource: getIt(),
      weatherLocalDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      client: getIt(),
    ),
  );

  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<SavedCitiesLocalDataSource>(
    () => SavedCitiesLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<SearchHistoryLocalDataSource>(
    () => SearchHistoryLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // External
  getIt.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
}
