import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutasks/core/shared/presentation/controller/state/error_state.dart';
import 'package:flutasks/core/shared/presentation/controller/state/idle_state.dart';
import 'package:flutasks/core/shared/presentation/controller/state/loading_state.dart';
import 'package:flutasks/core/utils/failure/failure.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/search_task_parameterrs.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';
import 'package:flutasks/modules/task/domain/usecases/create_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/delete_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/get_tasks_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/search_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/toggle_task_status_usecase.dart';
import 'package:flutasks/modules/task/presentation/controller/blocs/task_bloc.dart';
import 'package:flutasks/modules/task/presentation/controller/events/create_task_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/delete_all_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/delete_task_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_done_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_more_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/search_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/toggle_status_event.dart';
import 'package:flutasks/modules/task/presentation/controller/states/successfully_create_task_state.dart';
import 'package:flutasks/modules/task/presentation/controller/states/successfully_got_tasks_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

class MockToggleTaskStatusUseCase extends Mock implements ToggleTaskStatusUseCase {}

class MockSearchTaskUseCase extends Mock implements SearchTaskUseCase {}

class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

class MockDeleteAllTasksUseCase extends Mock implements DeleteAllTasksUseCase {}

TaskEntity _task({String id = '1', String title = 'Test', bool isDone = false}) =>
    TaskEntity(id: id, title: title, isDone: isDone);

SuccessfullyGotTasksState _gotState(
  List<TaskEntity> tasks, {
  List<TaskEntity>? allTasks,
}) =>
    SuccessfullyGotTasksState(
      allTasks: allTasks ?? tasks,
      tasks: tasks,
      tasksLength: tasks.length,
      isEmpty: tasks.isEmpty,
    );

void main() {
  late MockGetTasksUseCase getTasksUseCase;
  late MockCreateTaskUseCase createTaskUseCase;
  late MockToggleTaskStatusUseCase toggleTaskStatusUseCase;
  late MockSearchTaskUseCase searchTaskUseCase;
  late MockDeleteTaskUseCase deleteTaskUseCase;
  late MockDeleteAllTasksUseCase deleteAllTasksUseCase;

  TaskBloc buildBloc() => TaskBloc(
        getTasksUseCase,
        createTaskUseCase,
        toggleTaskStatusUseCase,
        searchTaskUseCase,
        deleteTaskUseCase,
        deleteAllTasksUseCase,
      );

  setUpAll(() {
    registerFallbackValue(const CreateTaskParameters(title: '', description: ''));
    registerFallbackValue(const DeleteTaskParameters(id: ''));
    registerFallbackValue(const SearchTaskParameters(text: ''));
    registerFallbackValue(const ToggleTaskStatusParameters(id: '', status: false));
  });

  setUp(() {
    getTasksUseCase = MockGetTasksUseCase();
    createTaskUseCase = MockCreateTaskUseCase();
    toggleTaskStatusUseCase = MockToggleTaskStatusUseCase();
    searchTaskUseCase = MockSearchTaskUseCase();
    deleteTaskUseCase = MockDeleteTaskUseCase();
    deleteAllTasksUseCase = MockDeleteAllTasksUseCase();
  });

  group('GetTasksEvent', () {
    blocTest<TaskBloc, dynamic>(
      'emite [IdleState, SuccessfullyGotTasksState] em sucesso',
      build: buildBloc,
      setUp: () {
        when(() => getTasksUseCase(null))
            .thenAnswer((_) async => Right([_task()]));
      },
      act: (bloc) => bloc.add(const GetTasksEvent()),
      expect: () => [
        isA<IdleState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
    );

    blocTest<TaskBloc, dynamic>(
      'emite [IdleState, ErrorState] em falha',
      build: buildBloc,
      setUp: () {
        when(() => getTasksUseCase(null))
            .thenAnswer((_) async => const Left(Failure('erro ao buscar')));
      },
      act: (bloc) => bloc.add(const GetTasksEvent()),
      expect: () => [
        isA<IdleState>(),
        isA<ErrorState>(),
      ],
    );

    blocTest<TaskBloc, dynamic>(
      'limita tasks exibidas ao máximo de 9',
      build: buildBloc,
      setUp: () {
        final tasks = List.generate(15, (i) => _task(id: '$i', title: 'T$i'));
        when(() => getTasksUseCase(null)).thenAnswer((_) async => Right(tasks));
      },
      act: (bloc) => bloc.add(const GetTasksEvent()),
      verify: (bloc) {
        final state = bloc.state as SuccessfullyGotTasksState;
        expect(state.tasks.length, equals(9));
        expect(state.tasksLength, equals(15));
      },
    );
  });

  group('CreateTaskEvent', () {
    blocTest<TaskBloc, dynamic>(
      'emite [Idle, SuccessfullyCreateTaskState, Idle, SuccessfullyGotTasksState] em sucesso',
      build: buildBloc,
      seed: () => _gotState([]),
      setUp: () {
        when(() => createTaskUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => getTasksUseCase(null))
            .thenAnswer((_) async => Right([_task()]));
      },
      act: (bloc) => bloc.add(const CreateTaskEvent(title: 'Nova tarefa')),
      expect: () => [
        isA<IdleState>(),
        isA<SuccessfullyCreateTaskState>(),
        isA<IdleState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
    );

    blocTest<TaskBloc, dynamic>(
      'emite [Idle, ErrorState] em falha',
      build: buildBloc,
      seed: () => _gotState([]),
      setUp: () {
        when(() => createTaskUseCase(any()))
            .thenAnswer((_) async => const Left(Failure('erro ao criar')));
      },
      act: (bloc) => bloc.add(const CreateTaskEvent(title: 'Nova tarefa')),
      expect: () => [
        isA<IdleState>(),
        isA<ErrorState>(),
      ],
    );
  });

  group('DeleteTaskEvent', () {
    final existing = _task(id: 'abc');

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, SuccessfullyGotTasksState] removendo a task em sucesso',
      build: buildBloc,
      seed: () => _gotState([existing]),
      setUp: () {
        when(() => deleteTaskUseCase(any()))
            .thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(const DeleteTaskEvent(id: 'abc')),
      expect: () => [
        isA<LoadingState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SuccessfullyGotTasksState;
        expect(state.tasks.any((t) => t.id == 'abc'), isFalse);
        expect(state.isEmpty, isTrue);
      },
    );

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, ErrorState] em falha',
      build: buildBloc,
      seed: () => _gotState([existing]),
      setUp: () {
        when(() => deleteTaskUseCase(any()))
            .thenAnswer((_) async => const Left(Failure('erro ao deletar')));
      },
      act: (bloc) => bloc.add(const DeleteTaskEvent(id: 'abc')),
      expect: () => [
        isA<LoadingState>(),
        isA<ErrorState>(),
      ],
    );
  });

  group('DeleteAllTasksEvent', () {
    blocTest<TaskBloc, dynamic>(
      'emite [Loading, SuccessfullyGotTasksState] com lista vazia em sucesso',
      build: buildBloc,
      setUp: () {
        when(() => deleteAllTasksUseCase(null))
            .thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(const DeleteAllTasksEvent()),
      expect: () => [
        isA<LoadingState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SuccessfullyGotTasksState;
        expect(state.isEmpty, isTrue);
        expect(state.tasks, isEmpty);
      },
    );

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, ErrorState] em falha',
      build: buildBloc,
      setUp: () {
        when(() => deleteAllTasksUseCase(null))
            .thenAnswer((_) async => const Left(Failure('erro')));
      },
      act: (bloc) => bloc.add(const DeleteAllTasksEvent()),
      expect: () => [
        isA<LoadingState>(),
        isA<ErrorState>(),
      ],
    );
  });

  group('ToggleStatusEvent', () {
    final task = _task(id: 'x', isDone: false);

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, SuccessfullyGotTasksState] e inverte isDone em sucesso',
      build: buildBloc,
      seed: () => _gotState([task]),
      setUp: () {
        when(() => toggleTaskStatusUseCase(any()))
            .thenAnswer((_) async => Right([task]));
      },
      act: (bloc) =>
          bloc.add(const ToggleStatusEvent(id: 'x', currentStatus: false)),
      expect: () => [
        isA<LoadingState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
      verify: (_) {
        expect(task.isDone, isTrue);
      },
    );

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, ErrorState] em falha',
      build: buildBloc,
      seed: () => _gotState([task]),
      setUp: () {
        when(() => toggleTaskStatusUseCase(any()))
            .thenAnswer((_) async => const Left(Failure('erro ao alternar')));
      },
      act: (bloc) =>
          bloc.add(const ToggleStatusEvent(id: 'x', currentStatus: false)),
      expect: () => [
        isA<LoadingState>(),
        isA<ErrorState>(),
      ],
    );
  });

  group('SearchTasksEvent', () {
    final task = _task(title: 'Flutter');

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, SuccessfullyGotTasksState] com resultados em sucesso',
      build: buildBloc,
      seed: () => _gotState([task]),
      setUp: () {
        when(() => searchTaskUseCase(any()))
            .thenAnswer((_) async => Right([task]));
      },
      act: (bloc) => bloc.add(const SearchTasksEvent(text: 'Flutter')),
      expect: () => [
        isA<LoadingState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
    );

    blocTest<TaskBloc, dynamic>(
      'emite [Loading, ErrorState] em falha',
      build: buildBloc,
      seed: () => _gotState([task]),
      setUp: () {
        when(() => searchTaskUseCase(any()))
            .thenAnswer((_) async => const Left(Failure('erro na busca')));
      },
      act: (bloc) => bloc.add(const SearchTasksEvent(text: 'Flutter')),
      expect: () => [
        isA<LoadingState>(),
        isA<ErrorState>(),
      ],
    );
  });

  group('GetDoneTasksEvent', () {
    blocTest<TaskBloc, dynamic>(
      'emite [Idle, SuccessfullyGotTasksState] apenas com tarefas concluídas',
      build: buildBloc,
      setUp: () {
        when(() => getTasksUseCase(null)).thenAnswer((_) async => Right([
              _task(id: '1', isDone: true),
              _task(id: '2', isDone: false),
            ]));
      },
      act: (bloc) => bloc.add(const GetDoneTasksEvent()),
      expect: () => [
        isA<IdleState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SuccessfullyGotTasksState;
        expect(state.tasks.length, equals(1));
        expect(state.tasks.first.isDone, isTrue);
      },
    );
  });

  group('GetMoreTasksEvent', () {
    blocTest<TaskBloc, dynamic>(
      'emite [Loading, SuccessfullyGotTasksState] carregando mais tasks da lista local',
      build: buildBloc,
      seed: () {
        final allTasks = List.generate(15, (i) => _task(id: '$i', title: 'T$i'));
        return SuccessfullyGotTasksState(
          allTasks: allTasks,
          tasks: allTasks.take(9).toList(),
          tasksLength: allTasks.length,
          isEmpty: false,
        );
      },
      act: (bloc) => bloc.add(const GetMoreTasksEvent()),
      expect: () => [
        isA<LoadingState>(),
        isA<SuccessfullyGotTasksState>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SuccessfullyGotTasksState;
        expect(state.tasks.length, equals(15));
      },
    );
  });
}
