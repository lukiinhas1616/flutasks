import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/coordinator/domain/repositories/coordinator_repository.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../../../../core/utils/failure/failure.dart';

abstract class StartLocalStorageUseCase extends AsyncUseCase<void, void> {
  const StartLocalStorageUseCase();
}

class StartLocalStorageUseCaseImp implements StartLocalStorageUseCase {
  const StartLocalStorageUseCaseImp(this.repository);

  final CoordinatorRepository repository;

  @override
  Future<Either<Failure, void>> call(void parameters) async {
    return await repository.startLocalStorage();
  }
}
