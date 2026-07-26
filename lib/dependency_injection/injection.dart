import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/core/network/fixture_http_client.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/saved_cities_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/repository/saved_cities_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/data/repository/weather_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/remove_saved_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app_flutter/features/weather/presentation/bloc/weather_bloc.dart';

final getIt = GetIt.instance;

/// When `true`, the app is wired to [FixtureHttpClient] and serves bundled JSON
/// fixtures instead of the live OpenWeatherMap API. Enabled by default on this
/// demo branch so the app runs deterministically with no `API_KEY` dart-define.
const bool useWeatherFixtures = true;

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

  // Use cases
  getIt.registerFactory(() => GetCurrentWeatherUsecase(repository: getIt()));
  getIt.registerFactory(() => GetTemperatureUnitUsecase(repository: getIt()));
  getIt.registerFactory(() => GetWeatherForecastUsecase(repository: getIt()));
  getIt.registerFactory(() => SaveTemperatureUnitUsecase(repository: getIt()));
  getIt.registerFactory(() => GetSavedCitiesUsecase(repository: getIt()));
  getIt.registerFactory(() => SaveCityUsecase(repository: getIt()));
  getIt.registerFactory(() => RemoveSavedCityUsecase(repository: getIt()));

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

  // External
  getIt.registerLazySingleton<http.Client>(
    () => useWeatherFixtures ? FixtureHttpClient() : http.Client(),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
}
