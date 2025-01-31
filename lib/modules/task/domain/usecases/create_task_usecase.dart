import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/repositories/task_repository.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../../../../core/utils/failure/failure.dart';

abstract class CreateTaskUseCase
    extends AsyncUseCase<void, CreateTaskParameters> {
  const CreateTaskUseCase();
}

class CreateTaskUseCaseImp implements CreateTaskUseCase {
  const CreateTaskUseCaseImp(this.repository);

  final TaskRepository repository;

  @override
  Future<Either<Failure, void>> call(
    CreateTaskParameters parameters,
  ) async {
    return await repository.create(parameters);
  }
}
