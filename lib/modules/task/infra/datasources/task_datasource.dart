import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/parameters/create_task_parameters.dart';

abstract class TaskDataSource {
  Future<void> create(CreateTaskParameters parameters);
  Future<void> delete(DeleteTaskParameters parameters);
  Future<void> deleteAll();
  Future<void> toggleStatus(ToggleTaskStatusParameters parameters);
  Future<List<TaskEntity>> getAll();
}
