import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../../../../core/utils/failure/failure.dart';
import '../repositories/task_repository.dart';

abstract class ToggleTaskStatusUseCase
    extends AsyncUseCase<void, ToggleTaskStatusParameters> {
  const ToggleTaskStatusUseCase();
}

class ToggleTaskStatusUseCaseImp implements ToggleTaskStatusUseCase {
  const ToggleTaskStatusUseCaseImp(this.repository);

  final TaskRepository repository;

  @override
  Future<Either<Failure, void>> call(
    ToggleTaskStatusParameters parameters,
  ) async {
    return await repository.toggleStatus(parameters);
  }
}
