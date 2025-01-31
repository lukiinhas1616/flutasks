import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutasks/modules/coordinator/domain/usecases/start_local_storage_usecase.dart';
import 'package:flutasks/modules/coordinator/presentation/controllers/events/coordinator_events.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/shared/presentation/controller/state/app_state.dart';
import '../../../../../core/shared/presentation/controller/state/error_state.dart';
import '../../../../../core/shared/presentation/controller/state/idle_state.dart';
import '../events/start_storage_event.dart';
import '../states/successfully_got_coordinator_state.dart';

class CoordinatorBloc extends Bloc<CoordinatorEvents, AppState>
    implements Disposable {
  CoordinatorBloc(
    this._startLocalStorageUseCase,
  ) : super(IdleState()) {
    on<StartStorageEvent>(_onStartStorageEvent);
  }

  final StartLocalStorageUseCase _startLocalStorageUseCase;

  FutureOr<void> _onStartStorageEvent(
    StartStorageEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(IdleState());

    final result = await _startLocalStorageUseCase(null);

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (success) {
        return const SuccessfullyGotCoordinatorState();
      },
    ));
  }

  @override
  void dispose() {
    close();
  }
}
