import 'package:flutter/material.dart';

class TaskPrincipalHeader extends StatelessWidget {
  const TaskPrincipalHeader({
    super.key,
    required this.tasksIsEmpty,
    required this.tasksCount,
  });

  final bool tasksIsEmpty;
  final int tasksCount;

  String get message => tasksIsEmpty
      ? 'Create tasks to achieve more.'
      : 'You\'ve got $tasksCount tasks to do.';

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Welcolme, ',
            style: Theme.of(context).textTheme.headlineMedium,
            children: [
              TextSpan(
                text: 'John',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              TextSpan(
                text: '.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}
