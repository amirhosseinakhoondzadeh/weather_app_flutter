import 'package:dartz/dartz.dart';
import 'package:weather_app_flutter/core/error/failures.dart';
import 'package:weather_app_flutter/core/usecase/usecase.dart';
import 'package:weather_app_flutter/features/weather/domain/entities/search_history_entry.dart';
import 'package:weather_app_flutter/features/weather/domain/repository/search_history_repository.dart';

class RecordSearchUsecase implements UseCase<void, SearchHistoryEntry> {
  final SearchHistoryRepository repository;

  RecordSearchUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SearchHistoryEntry entry) {
    return repository.recordSearch(entry);
  }
}
