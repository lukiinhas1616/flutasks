import 'package:equatable/equatable.dart';

import 'app_state.dart';

class IdleState extends Equatable implements AppState {
  @override
  String get message => 'Idle State';

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
