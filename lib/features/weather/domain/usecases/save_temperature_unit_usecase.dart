import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/weather_repository.dart';

class SaveTemperatureUnitUsecase implements UseCase<void, String> {
  final WeatherRepository repository;

  SaveTemperatureUnitUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String unit) {
    return repository.saveTemperatureUnit(unit);
  }
}
