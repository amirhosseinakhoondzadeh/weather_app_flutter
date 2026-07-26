import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class SaveCityUsecase implements UseCase<void, SavedCity> {
  final SavedCitiesRepository repository;

  SaveCityUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SavedCity city) {
    return repository.saveCity(city);
  }
}
