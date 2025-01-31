import 'package:flutasks/core/utils/app_routes/task_module_routes.dart';
import 'package:flutasks/modules/task/task_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/shared/domain/services/local_storage_service.dart';
import '../core/shared/infra/services/local_storage_service_imp.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.add<LocalStorageService>(
      () => LocalStorageServiceImp(),
    );
  }

  @override
  void routes(RouteManager r) {
    r.module(TaskModuleRoutes.initialRoute, module: TaskModule());
  }
}
