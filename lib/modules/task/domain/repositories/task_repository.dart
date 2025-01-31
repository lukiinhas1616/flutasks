import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';

import '../../../../core/utils/failure/failure.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getAll();
  Future<Either<Failure, void>> create(CreateTaskParameters parameters);

  Future<Either<Failure, void>> delete(DeleteTaskParameters parameters);
  Future<Either<Failure, void>> deleteAll();

  Future<Either<Failure, void>> toggleStatus(
    ToggleTaskStatusParameters parameters,
  );
}
