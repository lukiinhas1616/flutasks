import 'package:flutasks/core/shared/presentation/controller/state/error_state.dart';
import 'package:flutasks/core/shared/presentation/ui/widgets/global_appbar_widget.dart';
import 'package:flutasks/modules/task/domain/entities/task_entity.dart';
import 'package:flutasks/modules/task/presentation/controller/blocs/task_bloc.dart';
import 'package:flutasks/modules/task/presentation/controller/events/get_tasks_event.dart';
import 'package:flutasks/modules/task/presentation/controller/events/toggle_status_event.dart';
import 'package:flutasks/modules/task/presentation/ui/widgets/tasks_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/shared/presentation/ui/widgets/global_bottombar_widget.dart';
import '../../controller/events/create_task_event.dart';
import '../../controller/events/get_more_tasks_event.dart';
import '../../controller/events/show_create_component_event.dart';
import '../../controller/events/toogle_card_expand_status_event.dart';
import '../../controller/states/show_create_component_state.dart';
import '../../controller/states/successfully_got_tasks_state.dart';
import '../bottomsheets/create_task_bottomsheet.dart';
import '../widgets/task_card_widget.dart';
import '../widgets/task_principal_header_widget.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final bloc = Modular.get<TaskBloc>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.add(const GetTasksEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      bloc.add(const GetMoreTasksEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppbarWidget(),
      bottomNavigationBar: GlobalBottomBarWidget(
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            bloc.add(const ShowCreateComponentEvent());
          }
        },
      ),
      body: BlocConsumer(
        bloc: bloc,
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ShowCreateComponentState) {
            final result = showModalBottomSheet(
              context: context,
              barrierColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) {
                return const CreateTaskBottomSheet();
              },
            );

            result.then((value) {
              if (value != null) {
                final title = value['title'] as String;
                final description = value['description'] as String;
                bloc.add(CreateTaskEvent(
                  title: title,
                  description: description,
                ));
              }
            });
          }
        },
        builder: (context, state) {
          if (state is SuccessfullyGotTasksState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TaskPrincipalHeader(
                    tasksIsEmpty: state.isEmpty,
                    tasksCount: state.tasksLength,
                  ),
                  if (state.isEmpty)
                    TasksEmptyWidget(onCreateTask: () {
                      bloc.add(const ShowCreateComponentEvent());
                    }),
                  if (!state.isEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
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
