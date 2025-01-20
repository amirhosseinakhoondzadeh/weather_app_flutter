import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app_flutter/core/error/failures.dart';

/// This class defines a contract for any use case, ensuring that it returns
/// a Future of Either a Failure or a specific Type when called with certain parameters.
abstract class UseCase<Type, Params> {
  /// This method must be implemented by any concrete use case class.
  /// It takes a parameter of type Params and returns a Future that
  /// resolves to Either a Failure or a Type.
  ///
  /// [params] The parameters required to execute the use case.
  ///
  /// Returns a [Future] containing [Either] a [Failure] or the expected [Type].
  Future<Either<Failure, Type>> call(Params params);
}

/// This class is used when a use case does not require any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
