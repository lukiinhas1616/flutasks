import 'package:flutasks/core/utils/app_routes/coordinator_module_routes.dart';
import 'package:flutasks/core/utils/app_routes/task_module_routes.dart';
import 'package:flutasks/modules/coordinator/coordinator_module.dart';
import 'package:flutasks/modules/task/task_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/shared/domain/services/local_storage_service.dart';
import '../core/shared/infra/services/local_storage_service_imp.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<LocalStorageService>(
      () => LocalStorageServiceImp(),
    );
  }

  @override
  void routes(RouteManager r) {
    r.module(CoordinatorModuleRoutes.base, module: CoordinatorModule());
    r.module(TaskModuleRoutes.base, module: TaskModule());
  }
}
