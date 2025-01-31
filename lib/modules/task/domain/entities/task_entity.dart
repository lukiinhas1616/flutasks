import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
  });

  final String id;
  final String title;
  final String? description;
  bool isDone;

  void toggleStatus() {
    isDone = !isDone;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [title, description, isDone];
}
