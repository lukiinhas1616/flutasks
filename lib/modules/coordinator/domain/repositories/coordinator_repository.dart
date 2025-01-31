import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure/failure.dart';

abstract class CoordinatorRepository {
  Future<Either<Failure, void>> startLocalStorage();
}
