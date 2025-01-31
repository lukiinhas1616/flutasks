import 'package:flutasks/core/shared/domain/services/local_storage_service.dart';
import 'package:flutasks/core/utils/app_routes/task_module_routes.dart';
import 'package:flutasks/modules/task/domain/repositories/task_repository.dart';
import 'package:flutasks/modules/task/domain/usecases/create_task_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/get_tasks_usecase.dart';
import 'package:flutasks/modules/task/domain/usecases/toggle_task_status_usecase.dart';
import 'package:flutasks/modules/task/infra/datasources/local/task_local_datasource_imp.dart';
import 'package:flutasks/modules/task/infra/datasources/task_datasource.dart';
import 'package:flutasks/modules/task/infra/repositories/task_repository_imp.dart';
import 'package:flutasks/modules/task/presentation/controller/blocs/task_bloc.dart';
import 'package:flutasks/modules/task/presentation/ui/pages/tasks_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app_module.dart';

class TaskModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.add<TaskDataSource>(
      () => TaskLocalDataSourceImp(i<LocalStorageService>()),
    );

    i.add<TaskRepository>(
      () => TaskRepositoryImp(i<TaskDataSource>()),
    );

    i.add<ToggleTaskStatusUseCase>(
      () => ToggleTaskStatusUseCaseImp(i<TaskRepository>()),
    );

    i.add<GetTasksUseCase>(
      () => GetTasksUseCaseImp(i<TaskRepository>()),
    );

    i.add<CreateTaskUseCase>(
      () => CreateTaskUseCaseImp(i<TaskRepository>()),
    );

    i.add<TaskBloc>(
      () => TaskBloc(
        i<GetTasksUseCase>(),
        i<CreateTaskUseCase>(),
        i<ToggleTaskStatusUseCase>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(TaskModuleRoutes.initialRoute, child: (_) => const TasksPage());
  }
}
