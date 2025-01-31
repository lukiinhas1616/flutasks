import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure([
    this.message,
    this.stackTrace,
    this.requestBody,
  ]);

  final String? message;
  final String? stackTrace;
  final String? requestBody;

  @override
  List<Object?> get props => [message];
}
