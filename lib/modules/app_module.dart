import 'package:flutasks/core/utils/app_routes/task_module_routes.dart';
import 'package:flutasks/modules/task/task_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module(TaskModuleRoutes.initialRoute, module: TaskModule());
  }
}
