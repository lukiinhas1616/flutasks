import 'package:flutasks/modules/task/presentation/controller/events/tasks_events.dart';

class CreateTaskEvent implements TasksEvents {
  const CreateTaskEvent({
    required this.title,
    this.description = 'No description',
  });

  final String title;
  final String description;
}
