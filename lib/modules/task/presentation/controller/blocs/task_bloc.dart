import 'package:bloc/bloc.dart';
import 'package:flutasks/core/shared/presentation/controller/state/app_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/shared/presentation/controller/state/idle_state.dart';
import '../events/tasks_events.dart';

class TaskBloc extends Bloc<TasksEvents, AppState> implements Disposable {
  TaskBloc() : super(IdleState()) {}
}
