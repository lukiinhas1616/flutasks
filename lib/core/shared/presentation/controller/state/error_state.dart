import 'package:equatable/equatable.dart';

import 'app_state.dart';

class ErrorState extends Equatable implements AppState {
  ErrorState([String? message]) {
    this.message = message ?? 'Error State';
  }

  @override
  late final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
