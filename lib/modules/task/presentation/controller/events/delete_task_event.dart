import 'package:flutasks/modules/task/presentation/controller/events/tasks_events.dart';

class DeleteTaskEvent implements TasksEvents {
  const DeleteTaskEvent({
    required this.id,
  });

  final String id;
}
