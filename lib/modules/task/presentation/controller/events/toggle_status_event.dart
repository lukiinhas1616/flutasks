import 'package:flutasks/modules/task/presentation/controller/events/tasks_events.dart';

class ToggleStatusEvent implements TasksEvents {
  const ToggleStatusEvent({
    required this.id,
    required this.currentStatus,
  });

  final String id;
  final bool currentStatus;
}
