import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class RemoveSavedCityUsecase implements UseCase<void, String> {
  final SavedCitiesRepository repository;

  RemoveSavedCityUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String cityName) {
    return repository.removeCity(cityName);
  }
}
