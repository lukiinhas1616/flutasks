import 'package:flutasks/modules/task/domain/entities/task_entity.dart';

class TaskResponseDto {
  static TaskEntity fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
    );
  }

  static Map<String, dynamic> toMap(TaskEntity task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
    };
  }
}
