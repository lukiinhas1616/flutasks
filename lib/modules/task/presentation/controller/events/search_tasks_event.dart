import 'tasks_events.dart';

class SearchTasksEvent implements TasksEvents {
  const SearchTasksEvent({
    required this.text,
  });

  final String text;
}
