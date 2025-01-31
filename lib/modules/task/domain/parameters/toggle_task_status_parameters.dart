import 'package:equatable/equatable.dart';

class ToggleTaskStatusParameters extends Equatable {
  final String id;
  final bool status;

  const ToggleTaskStatusParameters({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}
