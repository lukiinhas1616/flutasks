import 'package:equatable/equatable.dart';

import 'app_state.dart';

class LoadingState extends Equatable implements AppState {
  @override
  String get message => 'Loading';

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => true;
}
