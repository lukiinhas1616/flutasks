import 'package:dartz/dartz.dart';
import 'package:flutasks/core/utils/failure/failure.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';
import 'package:flutasks/modules/task/domain/repositories/task_repository.dart';
import 'package:flutasks/modules/task/infra/datasources/task_datasource.dart';

class TaskRepositoryImp extends TaskRepository {
  TaskRepositoryImp(this.taskDataSource);

  final TaskDataSource taskDataSource;

  @override
  Future<Either<Failure, void>> create(CreateTaskParameters parameters) async {
    try {
      await taskDataSource.create(parameters);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(DeleteTaskParameters parameters) async {
    try {
      await taskDataSource.delete(parameters);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAll() async {
    try {
      await taskDataSource.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAll() async {
    try {
      final tasks = await taskDataSource.getAll();
      return Right(tasks);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> toggleStatus(
    ToggleTaskStatusParameters parameters,
  ) async {
    try {
      final result = await taskDataSource.toggleStatus(parameters);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
