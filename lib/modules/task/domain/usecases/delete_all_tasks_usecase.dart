import 'package:dartz/dartz.dart';
import 'package:flutasks/core/utils/failure/failure.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../repositories/task_repository.dart';

abstract class DeleteAllTasksUseCase extends AsyncUseCase<void, void> {
  const DeleteAllTasksUseCase();
}

class DeleteAllTasksUseCaseImp implements DeleteAllTasksUseCase {
  const DeleteAllTasksUseCaseImp(this.repository);

  final TaskRepository repository;

  @override
  Future<Either<Failure, void>> call(void parameters) {
    return repository.deleteAll();
  }
}
