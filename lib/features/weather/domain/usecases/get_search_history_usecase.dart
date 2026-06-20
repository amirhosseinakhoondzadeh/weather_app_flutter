import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/search_history_repository.dart';

class GetSearchHistoryUsecase
    implements UseCase<List<SearchHistoryEntry>, GetSearchHistoryParams> {
  final SearchHistoryRepository repository;

  GetSearchHistoryUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SearchHistoryEntry>>> call(
    GetSearchHistoryParams params,
  ) {
    return repository.getSearchHistory(page: params.page, limit: params.limit);
  }
}

class GetSearchHistoryParams extends Equatable {
  final int page;
  final int limit;

  const GetSearchHistoryParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
