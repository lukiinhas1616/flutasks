import 'package:equatable/equatable.dart';

class DeleteTaskParameters extends Equatable {
  final String id;

  const DeleteTaskParameters({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
