import 'package:equatable/equatable.dart';

import '../../../../../core/shared/presentation/controller/state/app_state.dart';

class ShowCreateComponentState extends Equatable implements AppState {
  const ShowCreateComponentState();

  @override
  String get message => 'Show create component';

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
