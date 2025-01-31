import 'package:equatable/equatable.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';

import '../../../../../core/shared/presentation/controller/state/app_state.dart';

class SuccessfullyGotTasksState extends Equatable implements AppState {
  const SuccessfullyGotTasksState({
    required this.allTasks,
    required this.tasks,
    required this.tasksLength,
    required this.isEmpty,
    this.expandedId,
  });

  final List<TaskEntity> allTasks;
  final List<TaskEntity> tasks;
  final int tasksLength;
  final bool isEmpty;
  final String? expandedId;

  @override
  String get message => 'Successfully got tasks';

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
