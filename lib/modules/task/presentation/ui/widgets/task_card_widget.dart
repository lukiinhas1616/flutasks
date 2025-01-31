import 'package:flutter/material.dart';

import '../../../domain/entities/task_entity.dart';

class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget({
    super.key,
    required this.expanded,
    required this.onExpand,
    required this.task,
    required this.onToggleStatus,
    this.onDelete,
  });

  final bool expanded;
  final Function(String v) onExpand;
  final Function(TaskEntity v) onToggleStatus;
  final TaskEntity task;
  final Function(String v)? onDelete;

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.expanded) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: buildExpandedTaskCard(
          context,
          task: widget.task,
          onExpand: widget.onExpand,
          onToggleStatus: widget.onToggleStatus,
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: buildMinimizedTaskCard(
        context,
        task: widget.task,
        onExpand: widget.onExpand,
        onToggleStatus: widget.onToggleStatus,
        onDelete: widget.onDelete ?? null,
      ),
    );
  }
}

Widget buildExpandedTaskCard(
  BuildContext context, {
  required TaskEntity task,
  required Function(String v) onExpand,
  required Function(TaskEntity v) onToggleStatus,
}) {
  return GestureDetector(
    onTap: () {
      onExpand(task.id);
    },
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
                  value: task.isDone,
                  onChanged: (v) {
                    onToggleStatus(task);
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    task.description!.isEmpty
                        ? 'Sem descrição'
                        : task.description!,
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
  required Function(TaskEntity v) onToggleStatus,
  required Function(String v)? onDelete,
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
                    value: task.isDone,
                    onChanged: (v) {
                      onToggleStatus(task);
                    },
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
              onDelete != null
                  ? Icons.delete_outlined
                  : Icons.more_horiz_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              if (onDelete != null) {
                onDelete(task.id);
                return;
              }
              onExpand(task.id);
            },
          )
        ],
      ),
    ),
  );
}
