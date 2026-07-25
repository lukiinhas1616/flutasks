import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskEntity', () {
    test('toggleStatus inverte isDone de false para true', () {
      final task = TaskEntity(id: '1', title: 'Test');
      expect(task.isDone, isFalse);
      task.toggleStatus();
      expect(task.isDone, isTrue);
    });

    test('toggleStatus inverte isDone de true para false', () {
      final task = TaskEntity(id: '1', title: 'Test', isDone: true);
      task.toggleStatus();
      expect(task.isDone, isFalse);
    });

    test('duas entidades com mesmo título, descrição e isDone são iguais', () {
      final a = TaskEntity(id: '1', title: 'Test', description: 'Desc');
      final b = TaskEntity(id: '2', title: 'Test', description: 'Desc');
      expect(a, equals(b));
    });

    test('entidades com isDone diferente não são iguais', () {
      final a = TaskEntity(id: '1', title: 'Test');
      final b = TaskEntity(id: '1', title: 'Test', isDone: true);
      expect(a, isNot(equals(b)));
    });

    test('description é null por padrão', () {
      final task = TaskEntity(id: '1', title: 'Test');
      expect(task.description, isNull);
    });
  });
}
