import 'package:flutasks/modules/task/presentation/controller/events/tasks_events.dart';

class ToggleCardExpandStatusEvent implements TasksEvents {
  const ToggleCardExpandStatusEvent({
    required this.id,
  });

  final String id;
}
