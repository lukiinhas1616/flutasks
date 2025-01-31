import 'package:dartz/dartz.dart';
import 'package:flutasks/core/shared/domain/services/local_storage_service.dart';
import 'package:flutasks/core/utils/failure/failure.dart';
import 'package:flutasks/modules/coordinator/domain/repositories/coordinator_repository.dart';

class CoordinatorRepositoryImp extends CoordinatorRepository {
  CoordinatorRepositoryImp(this.localStorageService);

  final LocalStorageService localStorageService;
  @override
  Future<Either<Failure, void>> startLocalStorage() async {
    try {
      await localStorageService.init();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
