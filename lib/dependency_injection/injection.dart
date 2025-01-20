import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/repository/weather_repository_impl.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_temperature_unit_usecase.dart';
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

  // Use cases
  getIt.registerFactory(() => GetCurrentWeatherUsecase(repository: getIt()));
  getIt.registerFactory(() => GetTemperatureUnitUsecase(repository: getIt()));
  getIt.registerFactory(() => GetWeatherForecastUsecase(repository: getIt()));
  getIt.registerFactory(() => SaveTemperatureUnitUsecase(repository: getIt()));

  // Repository
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
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

  // External
  getIt.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
}
