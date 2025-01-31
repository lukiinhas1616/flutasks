import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../../../../core/utils/failure/failure.dart';
import '../repositories/task_repository.dart';

abstract class DeleteTaskUseCase
    extends AsyncUseCase<void, DeleteTaskParameters> {
  const DeleteTaskUseCase();
}

class DeleteTaskUseCaseImp implements DeleteTaskUseCase {
  const DeleteTaskUseCaseImp(this.repository);

  final TaskRepository repository;

  @override
  Future<Either<Failure, void>> call(
    DeleteTaskParameters parameters,
  ) async {
    return await repository.delete(parameters);
  }
}
