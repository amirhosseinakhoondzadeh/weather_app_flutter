import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';

class GetTemperatureUnitUsecase implements UseCase<String, NoParams> {
  final WeatherRepository repository;

  GetTemperatureUnitUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.getTemperatureUnit();
  }
}
