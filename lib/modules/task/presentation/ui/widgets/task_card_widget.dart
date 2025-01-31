import 'package:flutter/material.dart';

import '../../../domain/entities/task_entity.dart';

class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget({
    super.key,
    required this.expanded,
    required this.onExpand,
    required this.task,
  });

  final bool expanded;
  final Function(String v) onExpand;
  final TaskEntity task;

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.expanded) {
      return buildExpandedTaskCard(
        context,
        task: widget.task,
        onExpand: widget.onExpand,
      );
    }
    return buildMinimizedTaskCard(
      context,
      task: widget.task,
      onExpand: widget.onExpand,
    );
  }
}

Widget buildExpandedTaskCard(
  BuildContext context, {
  required TaskEntity task,
  required Function(String v) onExpand,
}) {
  return GestureDetector(
    onTap: onExpand(task.id),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: true,
                  onChanged: (v) {},
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task 1',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec odio.   ',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildMinimizedTaskCard(
  BuildContext context, {
  required TaskEntity task,
  required Function(String v) onExpand,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: false,
                    onChanged: (v) {},
                  ),
                ),
              ),
              Text(
                task.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.more_horiz_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: onExpand(task.id),
          )
        ],
      ),
    ),
  );
}
