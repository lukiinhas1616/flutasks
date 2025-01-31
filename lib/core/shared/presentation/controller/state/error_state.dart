import 'package:equatable/equatable.dart';

import 'app_state.dart';

class ErrorState extends Equatable implements AppState {
  const ErrorState({
    this.message = 'An error occurred',
  });

  @override
  final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
