import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutasks/core/shared/presentation/controller/state/app_state.dart';
import 'package:flutasks/core/shared/presentation/controller/state/loading_state.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/search_task_parameterrs.dart';
import 'package:flutasks/modules/task/domain/usecases/create_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/delete_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/get_tasks_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/search_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/toggle_task_status_usecase.dart';
import 'package:flutasks/modules/task/presentation/controller/events/create_task_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/delete_all_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/delete_task_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_done_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_more_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/search_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/show_create_component_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/toggle_status_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/toogle_card_expand_status_event.dart';
import 'package:flutasks/modules/task/presentation/controller/states/successfully_got_tasks_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/shared/presentation/controller/state/error_state.dart';
import '../../../../../core/shared/presentation/controller/state/idle_state.dart';
import '../../../domain/parameters/toggle_task_status_parameters.dart';
import '../events/tasks_events.dart';
import '../states/show_create_component_state.dart';
import '../states/successfully_create_task_state.dart';

class TaskBloc extends Bloc<TasksEvents, AppState> implements Disposable {
  TaskBloc(
    this._getTasksUseCase,
    this._createTaskUseCase,
    this._toggleTaskStatusUseCase,
    this._searchTaskUseCase,
    this._deleteTaskUseCase,
    this._deleteAllTasksUseCase,
  ) : super(IdleState()) {
    on<GetTasksEvent>(_onGetTasksEvent);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<ShowCreateComponentEvent>(_onShowCreateComponentEvent);
    on<ToggleCardExpandStatusEvent>(_onToggleCardExpandStatusEvent);
    on<GetMoreTasksEvent>(_onGetMoreTasksEvent);
    on<ToggleStatusEvent>(_onToggleStatusEvent);
    on<SearchTasksEvent>(_onSearchTasksEvent);
    on<GetDoneTasksEvent>(_onGetDoneTasksEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<DeleteAllTasksEvent>(_onDeleteAllTasksEvent);
  }

  final GetTasksUseCase _getTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final ToggleTaskStatusUseCase _toggleTaskStatusUseCase;
  final SearchTaskUseCase _searchTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final DeleteAllTasksUseCase _deleteAllTasksUseCase;

  final maxTasks = 9;

  FutureOr<void> _onGetTasksEvent(
    GetTasksEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(IdleState());

    final result = await _getTasksUseCase(null);

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (success) {
        final tasks = success.length > maxTasks
            ? success.take(maxTasks).toList()
            : success;
        return SuccessfullyGotTasksState(
          allTasks: success,
          tasks: tasks,
          tasksLength: success.length,
          isEmpty: success.isEmpty,
        );
      },
    ));
  }

  FutureOr<void> _onCreateTaskEvent(
    CreateTaskEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state as SuccessfullyGotTasksState;
    emit(IdleState());

    final result = await _createTaskUseCase(
      CreateTaskParameters(
        title: event.title,
        description: event.description,
      ),
    );

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (_) {
        return const SuccessfullyCreateTaskState();
      },
    ));

    add(const GetTasksEvent());
  }

  FutureOr<void> _onShowCreateComponentEvent(
    ShowCreateComponentEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    emit(const ShowCreateComponentState());
    emit(currentState);
  }

  FutureOr<void> _onToggleCardExpandStatusEvent(
    ToggleCardExpandStatusEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state as SuccessfullyGotTasksState;
    emit(LoadingState());

    final expandedId = currentState.expandedId == event.id ? null : event.id;

    emit(SuccessfullyGotTasksState(
      allTasks: currentState.allTasks,
      tasks: currentState.tasks,
      tasksLength: currentState.tasksLength,
      isEmpty: currentState.isEmpty,
      expandedId: expandedId,
    ));
  }

  Future<void> _onGetMoreTasksEvent(
    GetMoreTasksEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state as SuccessfullyGotTasksState;
    emit(LoadingState());

    final tasks =
        currentState.allTasks.length > currentState.tasks.length + maxTasks
            ? currentState.allTasks
                .skip(currentState.tasks.length)
                .take(maxTasks)
                .toList()
            : currentState.allTasks.skip(currentState.tasks.length).toList();

    emit(SuccessfullyGotTasksState(
      allTasks: currentState.allTasks,
      tasks: currentState.tasks + tasks,
      tasksLength: currentState.allTasks.length,
      isEmpty: currentState.allTasks.isEmpty,
      expandedId: currentState.expandedId,
    ));
  }

  Future<void> _onSearchTasksEvent(
    SearchTasksEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state as SuccessfullyGotTasksState;
    emit(LoadingState());

    final result = await _searchTaskUseCase(SearchTaskParameters(
      text: event.text,
    ));

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (success) {
        return SuccessfullyGotTasksState(
          allTasks: currentState.allTasks,
          tasks: success,
          tasksLength: success.length,
          isEmpty: success.isEmpty,
          expandedId: currentState.expandedId,
        );
      },
    ));
  }

  Future<void> _onToggleStatusEvent(
    ToggleStatusEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state as SuccessfullyGotTasksState;
    emit(LoadingState());

    final result = await _toggleTaskStatusUseCase((ToggleTaskStatusParameters(
      id: event.id,
      status: event.currentStatus,
    )));

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (success) {
        //TODO: Deveria tratar melhor
        currentState.tasks
            .firstWhere((task) => task.id == event.id)
            .toggleStatus();
        return SuccessfullyGotTasksState(
          allTasks: currentState.allTasks,
          tasks: currentState.tasks,
          tasksLength: currentState.tasksLength,
          isEmpty: currentState.isEmpty,
          expandedId: currentState.expandedId,
        );
      },
    ));
  }

  Future<void> _onGetDoneTasksEvent(
    GetDoneTasksEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(IdleState());

    final result = await _getTasksUseCase(null);

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (success) {
        final tasks = success.where((task) => task.isDone).toList();
        return SuccessfullyGotTasksState(
          allTasks: success,
          tasks: tasks,
          tasksLength: tasks.length,
          isEmpty: tasks.isEmpty,
        );
      },
    ));
  }

  Future<void> _onDeleteTaskEvent(
    DeleteTaskEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state as SuccessfullyGotTasksState;
    emit(LoadingState());

    final result = await _deleteTaskUseCase(DeleteTaskParameters(id: event.id));

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (_) {
        final tasks =
            currentState.tasks.where((task) => task.id != event.id).toList();
        return SuccessfullyGotTasksState(
          allTasks: currentState.allTasks,
          tasks: tasks,
          tasksLength: tasks.length,
          isEmpty: tasks.isEmpty,
        );
      },
    ));
  }

  Future<void> _onDeleteAllTasksEvent(
    DeleteAllTasksEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(LoadingState());

    final result = await _deleteAllTasksUseCase(null);

    emit(result.fold(
      (failure) {
        return ErrorState(failure.message);
      },
      (_) {
        return const SuccessfullyGotTasksState(
          allTasks: [],
          tasks: [],
          tasksLength: 0,
          isEmpty: true,
        );
      },
    ));
  }

  @override
  void dispose() {
    close();
  }
}
