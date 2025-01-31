import 'dart:convert';

import 'package:flutasks/core/shared/domain/services/local_storage_service.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';
import 'package:flutasks/modules/task/infra/datasources/task_datasource.dart';
import 'package:flutasks/modules/task/infra/dtos/task_response_dto.dart';

class TaskLocalDataSourceImp implements TaskDataSource {
  final LocalStorageService _localStorageService;

  TaskLocalDataSourceImp(this._localStorageService);

  @override
  Future<void> create(CreateTaskParameters parameters) async {
    final tasks = await getAll();
    final TaskEntity task = TaskEntity(
      id: DateTime.now().toString(),
      title: parameters.title,
      description: parameters.description,
    );
    tasks.add(task);
    final tasksMap = tasks.map((task) => TaskResponseDto.toMap(task)).toList();
    await _localStorageService.save(
      'tasks',
      jsonEncode({'tasks': tasksMap}),
    );
  }

  @override
  Future<void> delete(DeleteTaskParameters parameters) async {
    final tasks = await getAll();
    tasks.removeWhere((task) => task.id == parameters.id);
    await _localStorageService.save(
      'tasks',
      jsonEncode({'tasks': tasks}),
    );
  }

  @override
  Future<void> deleteAll() {
    return _localStorageService.deleteAll();
  }

  @override
  Future<List<TaskEntity>> getAll() async {
    final getTasks = await _localStorageService.get('tasks');
    if (getTasks == null) return [];
    Map<String, dynamic> decoded = jsonDecode(getTasks);
    List<TaskEntity> tasks = List<TaskEntity>.from(
        decoded['tasks'].map((task) => TaskResponseDto.fromMap(task)));
    return tasks;
  }

  @override
  Future<List<TaskEntity>> toggleStatus(
      ToggleTaskStatusParameters parameters) async {
    final tasks = await getAll();
    final task = tasks.firstWhere((task) => task.id == parameters.id);
    task.toggleStatus();
    final tasksMap = tasks.map((task) => TaskResponseDto.toMap(task)).toList();
    await _localStorageService.save(
      'tasks',
      jsonEncode({'tasks': tasksMap}),
    );
    return tasks;
  }
}
