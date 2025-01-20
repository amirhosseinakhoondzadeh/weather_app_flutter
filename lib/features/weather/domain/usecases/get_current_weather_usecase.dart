import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';

class GetCurrentWeatherUsecase implements UseCase<WeatherEntity, String> {
  final WeatherRepository repository;

  GetCurrentWeatherUsecase({required this.repository});

  @override
  Future<Either<Failure, WeatherEntity>> call(String city) {
    return repository.getCurrentWeather(city);
  }
}
