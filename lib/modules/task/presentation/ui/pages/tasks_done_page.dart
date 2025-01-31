import 'package:flutasks/modules/task/presentation/controller/events/delete_all_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_done_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/search_tasks_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/shared/presentation/ui/widgets/global_appbar_widget.dart';
import '../../../../../core/shared/presentation/ui/widgets/global_bottombar_widget.dart';
import '../../../../../core/utils/debouncer/debouncer.dart';
import '../../../domain/entities/task_entity.dart';
import '../../controller/blocs/task_bloc.dart';
import '../../controller/events/delete_task_event.dart';
import '../../controller/events/toggle_status_event.dart';
import '../../controller/events/toogle_card_expand_status_event.dart';
import '../../controller/states/successfully_got_tasks_state.dart';
import '../widgets/task_card_widget.dart';
import '../widgets/tasks_empty_widget.dart';

class TasksDonePage extends StatefulWidget {
  const TasksDonePage({super.key});

  @override
  State<TasksDonePage> createState() => _TasksDonePageState();
}

class _TasksDonePageState extends State<TasksDonePage> {
  final bloc = Modular.get<TaskBloc>();

  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    bloc.add(const GetDoneTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    void onSearchChanged(String text) {
      if (bloc.state is SuccessfullyGotTasksState) {
        _debouncer.run(() {
          bloc.add(SearchTasksEvent(
            text: text.toLowerCase(),
          ));
        });
      }
    }

    return Scaffold(
      appBar: const GlobalAppbarWidget(),
      bottomNavigationBar: GlobalBottomBarWidget(
        currentIndex: 3,
        onTap: (int index) {},
      ),
      body: BlocConsumer(
        bloc: bloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SuccessfullyGotTasksState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Completed tasks',
                          style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                          onPressed: () {
                            bloc.add(const DeleteAllTasksEvent());
                          },
                          child: Text(
                            'Delete all',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.red,
                                ),
                          )),
                    ],
                  ),
                  if (state.isEmpty) const TasksEmptyWidget(),
                  if (!state.isEmpty)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
                          return TaskCardWidget(
                            task: task,
                            expanded: task.id == state.expandedId,
                            onExpand: (String v) {
                              bloc.add(ToggleCardExpandStatusEvent(id: v));
                            },
                            onToggleStatus: (TaskEntity v) {
                              bloc.add(ToggleStatusEvent(
                                id: v.id,
                                currentStatus: v.isDone,
                              ));
                            },
                            onDelete: (String v) {
                              bloc.add(DeleteTaskEvent(id: v));
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ));
        },
      ),
    );
  }
}
