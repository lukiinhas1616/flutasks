import 'package:dartz/dartz.dart';

import '../../../utils/failure/failure.dart';

abstract class AsyncUseCase<Type, Parameters> {
  const AsyncUseCase();

  Future<Either<Failure, Type>> call(Parameters parameters);
}
