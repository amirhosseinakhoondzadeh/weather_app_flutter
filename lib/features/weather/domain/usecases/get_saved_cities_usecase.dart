import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/saved_cities_repository.dart';

class GetSavedCitiesUsecase
    implements UseCase<List<SavedCity>, GetSavedCitiesParams> {
  final SavedCitiesRepository repository;

  GetSavedCitiesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SavedCity>>> call(GetSavedCitiesParams params) {
    return repository.getSavedCities(page: params.page, limit: params.limit);
  }
}

class GetSavedCitiesParams extends Equatable {
  final int page;
  final int limit;

  const GetSavedCitiesParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
