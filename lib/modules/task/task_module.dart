import 'package:flutasks/core/utils/app_routes/task_module_routes.dart';
import 'package:flutasks/modules/task/presentation/ui/pages/tasks_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app_module.dart';

class TaskModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(TaskModuleRoutes.initialRoute, child: (_) => const TasksPage());
  }
}
