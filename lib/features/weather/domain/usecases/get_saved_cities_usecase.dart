import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city_entity.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class GetSavedCitiesUsecase
    implements UseCase<List<SavedCityEntity>, SavedCitiesParams> {
  final SavedCitiesRepository repository;

  GetSavedCitiesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SavedCityEntity>>> call(
      SavedCitiesParams params) {
    return repository.getSavedCities(
      offset: params.offset,
      limit: params.limit,
    );
  }
}

/// Parameters for fetching a page of saved cities.
class SavedCitiesParams extends Equatable {
  final int offset;
  final int limit;

  const SavedCitiesParams({required this.offset, required this.limit});

  @override
  List<Object> get props => [offset, limit];
}
