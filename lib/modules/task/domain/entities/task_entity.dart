import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.status = false,
  });

  final String id;
  final String title;
  final String? description;
  final bool status;

  @override
  // TODO: implement props
  List<Object?> get props => [title, description, status];
}
