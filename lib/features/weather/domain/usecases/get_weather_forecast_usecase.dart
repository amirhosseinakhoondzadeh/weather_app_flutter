import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';

class GetWeatherForecastUsecase implements UseCase<ForecastEntity, String> {
  final WeatherRepository repository;

  GetWeatherForecastUsecase({required this.repository});

  @override
  Future<Either<Failure, ForecastEntity>> call(String city) {
    return repository.getWeatherForecast(city);
  }
}
