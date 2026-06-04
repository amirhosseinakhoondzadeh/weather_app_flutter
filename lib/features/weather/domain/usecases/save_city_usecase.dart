import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class SaveCityUsecase implements UseCase<void, SavedCityEntity> {
  final SavedCitiesRepository repository;

  SaveCityUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SavedCityEntity city) {
    return repository.saveCity(city);
  }
}
