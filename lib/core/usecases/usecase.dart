// lib/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCaseNoParams<Type> {
  Stream<Either<Failure, Type>> call();
}

class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}

// Base class for use case parameters
abstract class UseCaseParams {
  const UseCaseParams();

  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UseCaseParams) return false;
    return props.toString() == other.props.toString();
  }

  @override
  int get hashCode => props.hashCode;
}
