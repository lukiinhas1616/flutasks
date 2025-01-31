import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../../../../core/utils/failure/failure.dart';
import '../repositories/task_repository.dart';

abstract class GetTasksUseCase extends AsyncUseCase<List<TaskEntity>, void> {
  const GetTasksUseCase();
}

class GetTasksUseCaseImp implements GetTasksUseCase {
  const GetTasksUseCaseImp(this.repository);

  final TaskRepository repository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(void parameters) async {
    return await repository.getAll();
  }
}
