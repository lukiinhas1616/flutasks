import 'package:equatable/equatable.dart';

import '../../../../../core/shared/presentation/controller/state/app_state.dart';

class SuccessfullyGotCoordinatorState extends Equatable implements AppState {
  const SuccessfullyGotCoordinatorState();

  @override
  String get message => 'Successfully got tasks';

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
