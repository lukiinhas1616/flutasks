import 'package:dartz/dartz.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/domain/parameters/create_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/delete_task_parameters.dart';
import 'package:flutasks/modules/task/domain/parameters/search_task_parameterrs.dart';
import 'package:flutasks/modules/task/domain/parameters/toggle_task_status_parameters.dart';
import 'package:flutasks/modules/task/infra/datasources/task_datasource.dart';
import 'package:flutasks/modules/task/infra/repositories/task_repository_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskDataSource extends Mock implements TaskDataSource {}

void main() {
  late MockTaskDataSource dataSource;
  late TaskRepositoryImp repository;

  final task = TaskEntity(id: '1', title: 'Test');
  const createParams = CreateTaskParameters(title: 'Test', description: 'Desc');
  const deleteParams = DeleteTaskParameters(id: '1');
  const searchParams = SearchTaskParameters(text: 'Test');
  const toggleParams = ToggleTaskStatusParameters(id: '1', status: false);

  setUp(() {
    dataSource = MockTaskDataSource();
    repository = TaskRepositoryImp(dataSource);
  });

  group('getAll', () {
    test('retorna Right com lista quando datasource tem sucesso', () async {
      when(() => dataSource.getAll()).thenAnswer((_) async => [task]);
      final result = await repository.getAll();
      expect(result, equals(Right<dynamic, List<TaskEntity>>([task])));
    });

    test('retorna Left(Failure) quando datasource lança exceção', () async {
      when(() => dataSource.getAll()).thenThrow(Exception('db error'));
      final result = await repository.getAll();
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('db error')),
        (_) => fail('deveria ser Left'),
      );
    });
  });

  group('create', () {
    test('retorna Right(null) quando datasource tem sucesso', () async {
      when(() => dataSource.create(createParams)).thenAnswer((_) async {});
      final result = await repository.create(createParams);
      expect(result.isRight(), isTrue);
    });

    test('retorna Left(Failure) quando datasource lança exceção', () async {
      when(() => dataSource.create(createParams)).thenThrow(Exception('create error'));
      final result = await repository.create(createParams);
      expect(result.isLeft(), isTrue);
    });
  });

  group('delete', () {
    test('retorna Right(null) quando datasource tem sucesso', () async {
      when(() => dataSource.delete(deleteParams)).thenAnswer((_) async {});
      final result = await repository.delete(deleteParams);
      expect(result.isRight(), isTrue);
    });

    test('retorna Left(Failure) quando datasource lança exceção', () async {
      when(() => dataSource.delete(deleteParams)).thenThrow(Exception('delete error'));
      final result = await repository.delete(deleteParams);
      expect(result.isLeft(), isTrue);
    });
  });

  group('deleteAll', () {
    test('retorna Right(null) quando datasource tem sucesso', () async {
      when(() => dataSource.deleteAll()).thenAnswer((_) async {});
      final result = await repository.deleteAll();
      expect(result.isRight(), isTrue);
    });

    test('retorna Left(Failure) quando datasource lança exceção', () async {
      when(() => dataSource.deleteAll()).thenThrow(Exception('deleteAll error'));
      final result = await repository.deleteAll();
      expect(result.isLeft(), isTrue);
    });
  });

  group('search', () {
    test('retorna Right com lista filtrada quando datasource tem sucesso', () async {
      when(() => dataSource.search(searchParams)).thenAnswer((_) async => [task]);
      final result = await repository.search(searchParams);
      expect(result, equals(Right<dynamic, List<TaskEntity>>([task])));
    });

    test('retorna Left(Failure) quando datasource lança exceção', () async {
      when(() => dataSource.search(searchParams)).thenThrow(Exception('search error'));
      final result = await repository.search(searchParams);
      expect(result.isLeft(), isTrue);
    });
  });

  group('toggleStatus', () {
    test('retorna Right com lista atualizada quando datasource tem sucesso', () async {
      when(() => dataSource.toggleStatus(toggleParams)).thenAnswer((_) async => [task]);
      final result = await repository.toggleStatus(toggleParams);
      expect(result.isRight(), isTrue);
    });

    test('retorna Left(Failure) quando datasource lança exceção', () async {
      when(() => dataSource.toggleStatus(toggleParams)).thenThrow(Exception('toggle error'));
      final result = await repository.toggleStatus(toggleParams);
      expect(result.isLeft(), isTrue);
    });
  });
}
