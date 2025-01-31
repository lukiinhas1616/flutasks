import 'package:flutter/material.dart';

import '../../../../../core/shared/presentation/ui/widgets/global_buttom_widget.dart';
import '../../../../../core/utils/assets_dir/images_dir.dart';

class TasksEmptyWidget extends StatelessWidget {
  const TasksEmptyWidget({super.key, this.onCreateTask});

  final VoidCallback? onCreateTask;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            ImagesDir.empty,
            scale: 2.4,
          ),
          Text(
            'You have no tasks listed',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 16),
          if (onCreateTask != null)
            SizedBox(
              width: 180,
              child: GlobalButtonWidget(
                label: 'Create task',
                icon: Icons.add,
                onPressed: onCreateTask!,
              ),
            ),
        ],
      ),
    );
  }
}
