import 'package:equatable/equatable.dart';

import '../../../../../core/shared/presentation/controller/state/app_state.dart';

class SuccessfullyCreateTaskState extends Equatable implements AppState {
  const SuccessfullyCreateTaskState();

  @override
  String get message => 'Successfully created task';

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
