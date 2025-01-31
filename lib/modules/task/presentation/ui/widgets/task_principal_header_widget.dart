import 'package:flutter/material.dart';

class TaskPrincipalHeader extends StatelessWidget {
  const TaskPrincipalHeader({super.key});

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
          'You\'ve got 7 tasks to do.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}
