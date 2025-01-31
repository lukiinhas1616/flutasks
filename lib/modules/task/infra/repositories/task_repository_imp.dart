import 'package:dartz/dartz.dart';
import 'package:flutasks/core/shared/domain/services/local_storage_service.dart';
import 'package:flutasks/core/utils/failure/failure.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';
import 'package:flutasks/modules/task/domain/repositories/task_repository.dart';

class TaskRepositoryImp extends TaskRepository {
  TaskRepositoryImp(this.localStorageService);

  final LocalStorageService localStorageService;

  @override
  Future<Either<Failure, void>> create(CreateTaskParameters parameters) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> delete(DeleteTaskParameters parameters) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> toggleStatus(
      ToggleTaskStatusParameters parameters) {
    // TODO: implement toggleStatus
    throw UnimplementedError();
  }
}
