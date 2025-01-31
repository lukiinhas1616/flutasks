import 'package:equatable/equatable.dart';

class CreateTaskParameters extends Equatable {
  final String title;
  final String description;

  const CreateTaskParameters({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}
