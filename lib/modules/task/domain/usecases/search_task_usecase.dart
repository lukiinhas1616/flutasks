import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/search_task_parameterrs.dart';

import '../../../../core/shared/domain/usecases/async_usecase.dart';
import '../../../../core/utils/failure/failure.dart';
import '../repositories/task_repository.dart';

abstract class SearchTaskUseCase
    extends AsyncUseCase<List<TaskEntity>, SearchTaskParameters> {
  const SearchTaskUseCase();
}

class SearchTaskUseCaseImp implements SearchTaskUseCase {
  const SearchTaskUseCaseImp(this.repository);

  final TaskRepository repository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(
    SearchTaskParameters parameters,
  ) async {
    return await repository.search(parameters);
  }
}
