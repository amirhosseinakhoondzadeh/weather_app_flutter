import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/local_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/remote_datasource.dart';
import 'package:weather_app_flutter/features/weather/data/datasource/saved_cities_local_datasource.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_saved_cities_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_temperature_unit_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/get_weather_forecast_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/remove_saved_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_city_usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/usecases/save_temperature_unit_usecase.dart';

@GenerateMocks([
  http.Client,
  SharedPreferences,
  WeatherRemoteDataSource,
  WeatherLocalDataSource,
  SavedCitiesLocalDataSource,
  WeatherRepository,
  SavedCitiesRepository,
  GetCurrentWeatherUsecase,
  GetTemperatureUnitUsecase,
  GetWeatherForecastUsecase,
  SaveTemperatureUnitUsecase,
  GetSavedCitiesUsecase,
  SaveCityUsecase,
  RemoveSavedCityUsecase,
])
void main() {}
