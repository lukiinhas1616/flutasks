import 'package:flutasks/core/shared/presentation/ui/widgets/global_appbar_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/presentation/ui/widgets/global_bottombar_widget.dart';
import '../../../../../core/shared/presentation/ui/widgets/global_buttom_widget.dart';
import '../../../../../core/utils/assets_dir/images_dir.dart';
import '../bottomsheets/create_task_bottomsheet.dart';
import '../widgets/task_principal_header_widget.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const GlobalAppbarWidget(),
      bottomNavigationBar: const GlobalBottomBarWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TaskPrincipalHeader(),
            Expanded(
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
                  SizedBox(
                    width: 180,
                    child: GlobalButtonWidget(
                      label: 'Create task',
                      icon: Icons.add,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return const CreateTaskBottomSheet();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
